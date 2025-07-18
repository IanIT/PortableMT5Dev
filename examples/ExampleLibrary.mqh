//+------------------------------------------------------------------+
//| Example Library for Portable MT5 Development Environment        |
//+------------------------------------------------------------------+
#property copyright "Portable MT5 Development Environment"
#property link      "https://github.com/IanIT/PortableMT5Dev"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

//+------------------------------------------------------------------+
//| Example utility class for common trading operations             |
//+------------------------------------------------------------------+
class CExampleLibrary
{
private:
    CTrade            m_trade;
    CSymbolInfo       m_symbol;
    CAccountInfo      m_account;

public:
    //--- Constructor
                     CExampleLibrary(void);
    //--- Destructor
                    ~CExampleLibrary(void);

    //--- Initialization
    bool              Init(const string symbol, const ulong magic = 0);

    //--- Trading functions
    bool              OpenBuy(const double lots, const double sl = 0, const double tp = 0, const string comment = "");
    bool              OpenSell(const double lots, const double sl = 0, const double tp = 0, const string comment = "");
    bool              ClosePosition(const ulong ticket);
    bool              CloseAllPositions(void);

    //--- Position management
    int               GetPositionsCount(void);
    double            GetTotalProfit(void);
    ulong             GetPositionTicket(const int index);

    //--- Market analysis
    bool              IsBullishCandle(const int index = 1);
    bool              IsBearishCandle(const int index = 1);
    double            GetCandleSize(const int index = 1);

    //--- Risk management
    double            CalculateLotSize(const double riskPercent, const double stopLossPoints);
    bool              IsSpreadAcceptable(const double maxSpread);

    //--- Utility functions
    bool              IsNewBar(void);
    string            GetTimeString(void);
    void              PrintTradeResult(void);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExampleLibrary::CExampleLibrary(void)
{
    // Constructor implementation
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExampleLibrary::~CExampleLibrary(void)
{
    // Destructor implementation
}

//+------------------------------------------------------------------+
//| Initialize the library                                           |
//+------------------------------------------------------------------+
bool CExampleLibrary::Init(const string symbol, const ulong magic = 0)
{
    // Set magic number
    if (magic > 0)
        m_trade.SetExpertMagicNumber(magic);

    // Initialize symbol
    if (!m_symbol.Name(symbol))
    {
        Print("Failed to initialize symbol: ", symbol);
        return false;
    }

    // Check if trading is allowed
    if (!m_account.TradeAllowed())
    {
        Print("Trading is not allowed for this account");
        return false;
    }

    Print("Example Library initialized for symbol: ", symbol);
    return true;
}

//+------------------------------------------------------------------+
//| Open buy position                                                |
//+------------------------------------------------------------------+
bool CExampleLibrary::OpenBuy(const double lots, const double sl = 0, const double tp = 0, const string comment = "")
{
    double price = m_symbol.Ask();
    bool result = m_trade.Buy(lots, m_symbol.Name(), price, sl, tp, comment);

    if (result)
    {
        Print("Buy order opened: Lots=", lots, " Price=", price, " SL=", sl, " TP=", tp);
    }
    else
    {
        Print("Failed to open buy order: ", m_trade.ResultRetcode(), " - ", m_trade.ResultRetcodeDescription());
    }

    return result;
}

//+------------------------------------------------------------------+
//| Open sell position                                               |
//+------------------------------------------------------------------+
bool CExampleLibrary::OpenSell(const double lots, const double sl = 0, const double tp = 0, const string comment = "")
{
    double price = m_symbol.Bid();
    bool result = m_trade.Sell(lots, m_symbol.Name(), price, sl, tp, comment);

    if (result)
    {
        Print("Sell order opened: Lots=", lots, " Price=", price, " SL=", sl, " TP=", tp);
    }
    else
    {
        Print("Failed to open sell order: ", m_trade.ResultRetcode(), " - ", m_trade.ResultRetcodeDescription());
    }

    return result;
}

//+------------------------------------------------------------------+
//| Close position by ticket                                         |
//+------------------------------------------------------------------+
bool CExampleLibrary::ClosePosition(const ulong ticket)
{
    if (!PositionSelectByTicket(ticket))
    {
        Print("Position not found: ", ticket);
        return false;
    }

    bool result = m_trade.PositionClose(ticket);

    if (result)
    {
        Print("Position closed: ", ticket);
    }
    else
    {
        Print("Failed to close position: ", ticket, " Error: ", m_trade.ResultRetcode());
    }

    return result;
}

//+------------------------------------------------------------------+
//| Close all positions                                              |
//+------------------------------------------------------------------+
bool CExampleLibrary::CloseAllPositions(void)
{
    int total = PositionsTotal();
    bool allClosed = true;

    for (int i = total - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket > 0)
        {
            if (!ClosePosition(ticket))
                allClosed = false;
        }
    }

    return allClosed;
}

//+------------------------------------------------------------------+
//| Get positions count                                              |
//+------------------------------------------------------------------+
int CExampleLibrary::GetPositionsCount(void)
{
    return PositionsTotal();
}

//+------------------------------------------------------------------+
//| Get total profit                                                 |
//+------------------------------------------------------------------+
double CExampleLibrary::GetTotalProfit(void)
{
    double totalProfit = 0.0;
    int total = PositionsTotal();

    for (int i = 0; i < total; i++)
    {
        if (PositionSelectByIndex(i))
        {
            totalProfit += PositionGetDouble(POSITION_PROFIT);
        }
    }

    return totalProfit;
}

//+------------------------------------------------------------------+
//| Check if candle is bullish                                       |
//+------------------------------------------------------------------+
bool CExampleLibrary::IsBullishCandle(const int index = 1)
{
    double open = iOpen(m_symbol.Name(), PERIOD_CURRENT, index);
    double close = iClose(m_symbol.Name(), PERIOD_CURRENT, index);

    return close > open;
}

//+------------------------------------------------------------------+
//| Check if candle is bearish                                       |
//+------------------------------------------------------------------+
bool CExampleLibrary::IsBearishCandle(const int index = 1)
{
    double open = iOpen(m_symbol.Name(), PERIOD_CURRENT, index);
    double close = iClose(m_symbol.Name(), PERIOD_CURRENT, index);

    return close < open;
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                 |
//+------------------------------------------------------------------+
double CExampleLibrary::CalculateLotSize(const double riskPercent, const double stopLossPoints)
{
    if (stopLossPoints <= 0 || riskPercent <= 0)
        return m_symbol.LotsMin();

    double riskAmount = m_account.Balance() * riskPercent / 100.0;
    double tickValue = m_symbol.TickValue();
    double lotSize = riskAmount / (stopLossPoints * tickValue);

    // Normalize lot size
    double minLot = m_symbol.LotsMin();
    double maxLot = m_symbol.LotsMax();
    double stepLot = m_symbol.LotsStep();

    lotSize = MathMax(minLot, MathMin(maxLot, MathRound(lotSize / stepLot) * stepLot));

    return lotSize;
}

//+------------------------------------------------------------------+
//| Check if spread is acceptable                                    |
//+------------------------------------------------------------------+
bool CExampleLibrary::IsSpreadAcceptable(const double maxSpread)
{
    double currentSpread = (m_symbol.Ask() - m_symbol.Bid()) / m_symbol.Point();
    return currentSpread <= maxSpread;
}

//+------------------------------------------------------------------+
//| Check for new bar                                                |
//+------------------------------------------------------------------+
bool CExampleLibrary::IsNewBar(void)
{
    static datetime lastBarTime = 0;
    datetime currentBarTime = iTime(m_symbol.Name(), PERIOD_CURRENT, 0);

    if (currentBarTime != lastBarTime)
    {
        lastBarTime = currentBarTime;
        return true;
    }

    return false;
}

//+------------------------------------------------------------------+
//| Get formatted time string                                        |
//+------------------------------------------------------------------+
string CExampleLibrary::GetTimeString(void)
{
    return TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES);
}

//+------------------------------------------------------------------+
//| Print last trade result                                          |
//+------------------------------------------------------------------+
void CExampleLibrary::PrintTradeResult(void)
{
    Print("Last trade result: ", m_trade.ResultRetcode(), " - ", m_trade.ResultRetcodeDescription());
    Print("Last trade price: ", m_trade.ResultPrice());
    Print("Last trade volume: ", m_trade.ResultVolume());
}
