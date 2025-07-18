//+------------------------------------------------------------------+
//| Example Expert Advisor for Portable MT5 Development Environment |
//+------------------------------------------------------------------+
#property copyright "Portable MT5 Development Environment"
#property link      "https://github.com/IanLGit/PortableMT5Dev"
#property version   "1.00"
#property strict

//--- Include files
#include "ExampleLibrary.mqh"

//--- Input parameters
input double   LotSize = 0.01;      // Lot size for trading
input int      TakeProfit = 100;    // Take profit in points
input int      StopLoss = 50;       // Stop loss in points
input ENUM_TIMEFRAMES TimeFrame = PERIOD_M5;  // Trading timeframe

//--- Global variables
CTrade trade;
CSymbolInfo symbol;
CAccountInfo account;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Initialize trade object
    trade.SetExpertMagicNumber(12345);

    // Initialize symbol info
    if (!symbol.Name(Symbol()))
    {
        Print("Failed to initialize symbol info");
        return INIT_FAILED;
    }

    // Check account permissions
    if (!account.TradeAllowed())
    {
        Print("Trading is not allowed for this account");
        return INIT_FAILED;
    }

    Print("Example EA initialized successfully");
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    Print("Example EA deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Check if it's a new bar
    static datetime lastBarTime = 0;
    datetime currentBarTime = iTime(Symbol(), TimeFrame, 0);

    if (currentBarTime == lastBarTime)
        return;

    lastBarTime = currentBarTime;

    // Simple example strategy: Buy on bullish candle, sell on bearish candle
    double open = iOpen(Symbol(), TimeFrame, 1);
    double close = iClose(Symbol(), TimeFrame, 1);

    // Check if we have any open positions
    if (PositionsTotal() > 0)
        return;

    // Buy signal
    if (close > open)
    {
        double ask = symbol.Ask();
        double tp = ask + TakeProfit * symbol.Point();
        double sl = ask - StopLoss * symbol.Point();

        if (trade.Buy(LotSize, Symbol(), ask, sl, tp, "Example EA Buy"))
        {
            Print("Buy order placed successfully");
        }
        else
        {
            Print("Failed to place buy order: ", trade.ResultRetcode());
        }
    }
    // Sell signal
    else if (close < open)
    {
        double bid = symbol.Bid();
        double tp = bid - TakeProfit * symbol.Point();
        double sl = bid + StopLoss * symbol.Point();

        if (trade.Sell(LotSize, Symbol(), bid, sl, tp, "Example EA Sell"))
        {
            Print("Sell order placed successfully");
        }
        else
        {
            Print("Failed to place sell order: ", trade.ResultRetcode());
        }
    }
}

//+------------------------------------------------------------------+
//| Trade event handler                                              |
//+------------------------------------------------------------------+
void OnTrade()
{
    // Handle trade events
    Print("Trade event occurred");
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    // Handle chart events if needed
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    // Timer-based actions if needed
}

//+------------------------------------------------------------------+
//| Example utility function                                         |
//+------------------------------------------------------------------+
bool IsNewBar()
{
    static datetime lastBarTime = 0;
    datetime currentBarTime = iTime(Symbol(), TimeFrame, 0);

    if (currentBarTime != lastBarTime)
    {
        lastBarTime = currentBarTime;
        return true;
    }

    return false;
}

//+------------------------------------------------------------------+
//| Example function to get account information                      |
//+------------------------------------------------------------------+
void PrintAccountInfo()
{
    Print("Account Info:");
    Print("  Balance: ", account.Balance());
    Print("  Equity: ", account.Equity());
    Print("  Margin: ", account.Margin());
    Print("  Free Margin: ", account.FreeMargin());
    Print("  Profit: ", account.Profit());
}

//+------------------------------------------------------------------+
//| Example function to get symbol information                       |
//+------------------------------------------------------------------+
void PrintSymbolInfo()
{
    Print("Symbol Info for ", Symbol(), ":");
    Print("  Bid: ", symbol.Bid());
    Print("  Ask: ", symbol.Ask());
    Print("  Point: ", symbol.Point());
    Print("  Digits: ", symbol.Digits());
    Print("  Spread: ", symbol.Spread());
    Print("  Volume Min: ", symbol.LotsMin());
    Print("  Volume Max: ", symbol.LotsMax());
    Print("  Volume Step: ", symbol.LotsStep());
}
