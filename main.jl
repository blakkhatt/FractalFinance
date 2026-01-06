using HTTP, JSON, CSV, DataFrames, Plots

# Function to fetch stock data from Alpha Vantage (free API)
function fetch_stock_data(symbol::String, api_key::String)
    url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$api_key&outputsize=full"
    response = HTTP.get(url)
    data = JSON.parse(String(response.body))
    
    if haskey(data, "Error Message")
        error("API Error: $(data["Error Message"])")
    end
    
    time_series = data["Time Series (Daily)"]
    dates = sort(collect(keys(time_series)))
    prices = [parse(Float64, time_series[date]["4. close"]) for date in dates]
    
    df = DataFrame(Date=dates, Close=prices)
    return df
end

# Function to calculate Hurst exponent (fractal dimension indicator)
function hurst_exponent(prices::Vector{Float64})
    n = length(prices)
    if n < 10
        return 0.5  # Random walk default
    end
    
    # R/S analysis
    max_lag = min(100, n ÷ 2)
    rs_values = Float64[]
    
    for lag in 2:max_lag
        rs = 0.0
        num_segments = n ÷ lag
        
        for i in 1:num_segments
            segment = prices[(i-1)*lag+1:i*lag]
            mean_val = sum(segment) / length(segment)
            cum_dev = cumsum(segment .- mean_val)
            r = maximum(cum_dev) - minimum(cum_dev)
            s = std(segment)
            if s > 0
                rs += r / s
            end
        end
        
        push!(rs_values, rs / num_segments)
    end
    
    # Fit line to log-log plot
    lags = 2:max_lag
    log_lags = log.(lags)
    log_rs = log.(rs_values)
    
    # Linear regression
    n_points = length(log_lags)
    sum_x = sum(log_lags)
    sum_y = sum(log_rs)
    sum_xy = sum(log_lags .* log_rs)
    sum_x2 = sum(log_lags .^ 2)
    
    slope = (n_points * sum_xy - sum_x * sum_y) / (n_points * sum_x2 - sum_x^2)
    
    return slope
end

# Function to predict trend based on Hurst
function predict_trend(hurst::Float64)
    if hurst > 0.6
        return "Strong uptrend (persistent)"
    elseif hurst > 0.55
        return "Weak uptrend"
    elseif hurst < 0.45
        return "Weak downtrend (mean-reverting)"
    elseif hurst < 0.4
        return "Strong downtrend (anti-persistent)"
    else
        return "Random walk (no clear trend)"
    end
end

# Main function
function analyze_stock(symbol::String, api_key::String)
    println("Fetching data for $symbol...")
    df = fetch_stock_data(symbol, api_key)
    
    prices = df.Close
    hurst = hurst_exponent(prices)
    
    println("Hurst Exponent: $hurst")
    prediction = predict_trend(hurst)
    println("Prediction: $prediction")
    
    # Plot price series
    plot(df.Close, label="Close Price", title="$symbol Price Series (Hurst: $(round(hurst, digits=3)))")
    savefig("$symbol.png")
    println("Plot saved as $symbol.png")
    
    return hurst, prediction
end

# Example usage
# Replace with your Alpha Vantage API key
# api_key = "YOUR_API_KEY"
# hurst, pred = analyze_stock("AAPL", api_key)