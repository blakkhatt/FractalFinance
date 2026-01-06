# Fractals in Finance

Using fractal analysis for stock price prediction and market analysis.

## Overview

This project demonstrates how to apply fractal mathematics to financial data analysis. It calculates the Hurst exponent to determine if a stock price series exhibits persistent trends, mean reversion, or random walk behavior, which can inform trading strategies.

## Features

- **Hurst Exponent Calculation**: Measures fractal dimension of price series
- **Trend Prediction**: Classifies market behavior based on Hurst value
- **Data Visualization**: Plots price series with Hurst analysis
- **API Integration**: Fetches real-time stock data

## Data Sources

### Alpha Vantage API
- **Type**: Free financial data API
- **URL**: https://www.alphavantage.co/
- **Features**: Daily stock prices, forex, crypto
- **Limits**: 5 calls/minute, 500 calls/day (free tier)
- **How to Use**:
  1. Sign up at https://www.alphavantage.co/support/#api-key
  2. Get your free API key
  3. Use in code: `api_key = "YOUR_KEY"`

### Alternative Open-Source APIs

#### Yahoo Finance (yfinance Python library alternative)
- Use `HTTP.jl` to fetch from Yahoo Finance endpoints
- Example: `https://query1.finance.yahoo.com/v7/finance/download/AAPL?period1=0&period2=9999999999&interval=1d&events=history`

#### Polygon.io
- **URL**: https://polygon.io/
- **Features**: Stocks, options, forex, crypto
- Free tier: 5 calls/minute

#### Financial Modeling Prep
- **URL**: https://financialmodelingprep.com/
- Free tier available

#### IEX Cloud
- **URL**: https://iexcloud.io/
- Free tier for limited data

## Installation

1. Clone repo: `git clone https://github.com/blakkhatt/FractalFinance.git`
2. Activate Julia environment: `cd FractalFinance && julia --project`

## Usage

1. Get API key from Alpha Vantage
2. Edit `main.jl` and set your `api_key`
3. Run analysis:
   ```julia
   julia --project
   include("main.jl")
   hurst, pred = analyze_stock("AAPL", api_key)
   ```

## Hurst Exponent Interpretation

- **H > 0.6**: Persistent (trending) - likely to continue in same direction
- **0.5 < H < 0.6**: Weak persistence
- **H ≈ 0.5**: Random walk
- **0.4 < H < 0.5**: Weak mean reversion
- **H < 0.4**: Anti-persistent (mean-reverting) - likely to reverse

## Code Explanation

### fetch_stock_data()
- Uses HTTP.jl to query Alpha Vantage API
- Parses JSON response into DataFrame
- Returns historical daily close prices

### hurst_exponent()
- Implements R/S analysis for Hurst calculation
- Fits log-log regression to estimate fractal dimension
- Returns Hurst value between 0 and 1

### predict_trend()
- Classifies market behavior based on Hurst value
- Provides trading insights

### analyze_stock()
- Orchestrates data fetching, analysis, and visualization
- Saves plot as PNG file

## Applications

- **Trend Following**: Use high Hurst for momentum strategies
- **Mean Reversion**: Use low Hurst for contrarian strategies
- **Risk Assessment**: Hurst indicates market efficiency
- **Portfolio Optimization**: Allocate based on fractal properties

## Contributing

Add more fractal indicators, prediction models, or data sources!

## Disclaimer

This is educational only. Not financial advice. Past performance ≠ future results.