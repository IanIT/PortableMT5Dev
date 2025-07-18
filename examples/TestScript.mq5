//+------------------------------------------------------------------+
//| Test Script for Portable MT5 Development Environment            |
//+------------------------------------------------------------------+
#property copyright "Portable MT5 Development Environment"
#property link      "https://github.com/IanLGit/PortableMT5Dev"
#property version   "1.00"
#property script_show_inputs

//--- Include the example library
#include "ExampleLibrary.mqh"

//--- Input parameters
input string TestSymbol = "EURUSD";     // Symbol to test
input bool   RunTradeTests = false;     // Run trading tests (be careful!)
input bool   RunAnalysisTests = true;   // Run market analysis tests

//--- Global variables
CExampleLibrary exampleLib;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
    Print("========================================");
    Print("Portable MT5 Development Environment");
    Print("Test Script Started");
    Print("========================================");

    // Test library initialization
    if (!TestLibraryInit())
    {
        Print("❌ Library initialization test failed");
        return;
    }

    // Test market analysis functions
    if (RunAnalysisTests)
    {
        TestMarketAnalysis();
    }

    // Test trading functions (only if explicitly enabled)
    if (RunTradeTests)
    {
        Print("⚠️ WARNING: Trading tests are enabled!");
        if (MessageBox("Are you sure you want to run trading tests?\nThis will place real trades!",
                      "Trading Test Warning", MB_YESNO | MB_ICONWARNING) == IDYES)
        {
            TestTradingFunctions();
        }
        else
        {
            Print("Trading tests skipped by user");
        }
    }

    // Test utility functions
    TestUtilityFunctions();

    // Test environment verification
    TestEnvironmentSetup();

    Print("========================================");
    Print("Test Script Completed");
    Print("========================================");
}

//+------------------------------------------------------------------+
//| Test library initialization                                      |
//+------------------------------------------------------------------+
bool TestLibraryInit()
{
    Print("\n🔧 Testing Library Initialization...");

    if (!exampleLib.Init(TestSymbol, 12345))
    {
        Print("❌ Failed to initialize library");
        return false;
    }

    Print("✅ Library initialized successfully for symbol: ", TestSymbol);
    return true;
}

//+------------------------------------------------------------------+
//| Test market analysis functions                                   |
//+------------------------------------------------------------------+
void TestMarketAnalysis()
{
    Print("\n📊 Testing Market Analysis Functions...");

    // Test candle analysis
    bool isBullish = exampleLib.IsBullishCandle(1);
    bool isBearish = exampleLib.IsBearishCandle(1);

    Print("Last candle analysis:");
    Print("  Bullish: ", isBullish ? "Yes" : "No");
    Print("  Bearish: ", isBearish ? "Yes" : "No");

    // Test spread check
    bool spreadOK = exampleLib.IsSpreadAcceptable(3.0);
    Print("  Spread acceptable (max 3 points): ", spreadOK ? "Yes" : "No");

    // Test lot size calculation
    double lotSize = exampleLib.CalculateLotSize(2.0, 50.0);
    Print("  Calculated lot size (2% risk, 50 points SL): ", lotSize);

    Print("✅ Market analysis tests completed");
}

//+------------------------------------------------------------------+
//| Test trading functions (CAUTION: Real trades!)                  |
//+------------------------------------------------------------------+
void TestTradingFunctions()
{
    Print("\n⚠️ Testing Trading Functions (REAL TRADES!)...");

    // Get current positions count
    int initialPositions = exampleLib.GetPositionsCount();
    Print("Initial positions count: ", initialPositions);

    // Test opening a small position
    double testLotSize = SymbolInfoDouble(TestSymbol, SYMBOL_VOLUME_MIN);
    Print("Attempting to open test position with lot size: ", testLotSize);

    bool buyResult = exampleLib.OpenBuy(testLotSize, 0, 0, "Test Buy Position");

    if (buyResult)
    {
        Sleep(1000); // Wait for the position to appear

        int newPositions = exampleLib.GetPositionsCount();
        Print("New positions count: ", newPositions);

        if (newPositions > initialPositions)
        {
            Print("✅ Position opened successfully");

            // Close the test position immediately
            ulong ticket = exampleLib.GetPositionTicket(newPositions - 1);
            if (ticket > 0)
            {
                if (exampleLib.ClosePosition(ticket))
                {
                    Print("✅ Test position closed successfully");
                }
                else
                {
                    Print("❌ Failed to close test position");
                }
            }
        }
        else
        {
            Print("❌ Position was not created (may have been rejected)");
        }
    }
    else
    {
        Print("❌ Failed to open test position");
        exampleLib.PrintTradeResult();
    }
}

//+------------------------------------------------------------------+
//| Test utility functions                                           |
//+------------------------------------------------------------------+
void TestUtilityFunctions()
{
    Print("\n🛠️ Testing Utility Functions...");

    // Test time string function
    string timeStr = exampleLib.GetTimeString();
    Print("Current time string: ", timeStr);

    // Test new bar detection
    bool isNewBar = exampleLib.IsNewBar();
    Print("Is new bar: ", isNewBar ? "Yes" : "No");

    // Test profit calculation
    double totalProfit = exampleLib.GetTotalProfit();
    Print("Total profit from open positions: ", totalProfit);

    Print("✅ Utility function tests completed");
}

//+------------------------------------------------------------------+
//| Test environment setup                                           |
//+------------------------------------------------------------------+
void TestEnvironmentSetup()
{
    Print("\n🌍 Testing Environment Setup...");

    // Check if this script compiled successfully
    Print("✅ Script compilation: SUCCESS");

    // Check symbol availability
    if (SymbolSelect(TestSymbol, true))
    {
        Print("✅ Symbol ", TestSymbol, " is available");

        // Print symbol information
        double bid = SymbolInfoDouble(TestSymbol, SYMBOL_BID);
        double ask = SymbolInfoDouble(TestSymbol, SYMBOL_ASK);
        double spread = ask - bid;
        int digits = (int)SymbolInfoInteger(TestSymbol, SYMBOL_DIGITS);

        Print("  Bid: ", DoubleToString(bid, digits));
        Print("  Ask: ", DoubleToString(ask, digits));
        Print("  Spread: ", DoubleToString(spread, digits));
    }
    else
    {
        Print("❌ Symbol ", TestSymbol, " is not available");
    }

    // Check account information
    Print("Account information:");
    Print("  Balance: ", AccountInfoDouble(ACCOUNT_BALANCE));
    Print("  Equity: ", AccountInfoDouble(ACCOUNT_EQUITY));
    Print("  Margin Level: ", AccountInfoDouble(ACCOUNT_MARGIN_LEVEL), "%");
    Print("  Trade Allowed: ", AccountInfoInteger(ACCOUNT_TRADE_ALLOWED) ? "Yes" : "No");

    // Check terminal information
    Print("Terminal information:");
    Print("  Terminal Company: ", TerminalInfoString(TERMINAL_COMPANY));
    Print("  Terminal Name: ", TerminalInfoString(TERMINAL_NAME));
    Print("  Terminal Path: ", TerminalInfoString(TERMINAL_PATH));
    Print("  Expert Allowed: ", TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) ? "Yes" : "No");

    Print("✅ Environment verification completed");
}

//+------------------------------------------------------------------+
//| Helper function to demonstrate error handling                    |
//+------------------------------------------------------------------+
void DemonstrateErrorHandling()
{
    Print("\n🔍 Demonstrating Error Handling...");

    // Try to access a non-existent symbol
    string invalidSymbol = "INVALIDSYMBOL";
    if (!SymbolSelect(invalidSymbol, true))
    {
        int error = GetLastError();
        Print("Expected error when accessing invalid symbol: ", error, " - ", ErrorDescription(error));
        ResetLastError();
    }

    // Try to get data for a non-existent bar
    double invalidPrice = iClose(TestSymbol, PERIOD_M1, 10000);
    if (invalidPrice == 0)
    {
        int error = GetLastError();
        Print("Expected error when accessing invalid bar: ", error, " - ", ErrorDescription(error));
        ResetLastError();
    }

    Print("✅ Error handling demonstration completed");
}

//+------------------------------------------------------------------+
//| Get error description                                            |
//+------------------------------------------------------------------+
string ErrorDescription(int error_code)
{
    switch(error_code)
    {
        case ERR_SUCCESS: return "Success";
        case ERR_INVALID_PARAMETER: return "Invalid parameter";
        case ERR_NO_MEMORY: return "No memory";
        case ERR_NOT_ENOUGH_MEMORY: return "Not enough memory";
        case ERR_INVALID_PARAMETER_VALUE: return "Invalid parameter value";
        case ERR_MARKET_CLOSED: return "Market is closed";
        case ERR_NO_CONNECTION: return "No connection";
        default: return "Unknown error";
    }
}
