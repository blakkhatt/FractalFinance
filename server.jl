using HTTP, JSON, CSV, DataFrames, Plots
include("main.jl")

# Set headless
ENV["GKSwstype"] = "nul"

function handler(req)
    if req.target == "/"
        html = """
        <!DOCTYPE html>
        <html>
        <head><title>Fractal Finance Analyzer</title></head>
        <body>
            <h1>Fractal Analysis for Stock Prediction</h1>
            <form action="/analyze" method="post">
                <label>Stock Symbol: <input type="text" name="symbol" value="AAPL"></label><br>
                <label>API Key: <input type="text" name="api_key" placeholder="YOUR_ALPHA_VANTAGE_KEY"></label><br>
                <button type="submit">Analyze</button>
            </form>
            <p>Use DEMO for sample data</p>
        </body>
        </html>
        """
        return HTTP.Response(200, ["Content-Type" => "text/html"], html)
    elseif req.target == "/analyze" && req.method == "POST"
        body = String(req.body)
        params = Dict()
        for pair in split(body, '&')
            kv = split(pair, '=')
            if length(kv) == 2
                params[HTTP.unescapeuri(kv[1])] = HTTP.unescapeuri(kv[2])
            end
        end
        
        symbol = get(params, "symbol", "AAPL")
        api_key = get(params, "api_key", "DEMO")
        
        output = ""
        try
            hurst, pred = analyze_stock(symbol, api_key)
            output = "Hurst Exponent: $hurst<br>Prediction: $pred<br><img src='/$symbol.png' alt='Plot'>"
        catch e
            output = "Error: $e"
        end
        
        html = """
        <h2>Analysis for $symbol</h2>
        <p>$output</p>
        <a href='/'>Back</a>
        """
        return HTTP.Response(200, ["Content-Type" => "text/html"], html)
    elseif endswith(req.target, ".png")
        file = replace(req.target, "/" => "")
        if isfile(file)
            return HTTP.Response(200, ["Content-Type" => "image/png"], read(file))
        else
            return HTTP.Response(404, "Image not found")
        end
    else
        return HTTP.Response(404, "Not found")
    end
end

println("Fractal Finance Server running at http://127.0.0.1:8080")
HTTP.serve(handler, "127.0.0.1", 8080)