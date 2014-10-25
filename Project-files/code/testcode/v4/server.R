options(scipen = 10)
require(lubridate)
require(shiny)
require(xts)
require(forecast)

## The following code will execute as the app launches
## Pull the data straight from the website
dt <- read.table("http://blockexplorer.com/q/nethash", header = FALSE,
                 sep = ",", skip = 15)
## Extract and convert the Date (in UTC) and Difficulty Value
df <- as.data.frame(as.POSIXct(dt[, 2], origin = '1970-01-01'),
                    format = "%Y/%m/%d")
df[, 2] <- dt[, 5]
names(df) <- c("Date", "Difficulty")
df$Date <- as.Date(as.character(df$Date, format = "%Y-%m-%d"))
## Remove duplicate values 
df <- unique(df)
## Create a new xts data.frame
dfXts <- xts(df$Difficulty, df$Date)
## Convert to Time-Series and ensure the correct index is monthly.
dfXts <- to.monthly(dfXts)
timeSeries <- as.ts(dfXts[, 4], start = c(2009))
## Fit the Automatic Arima model
fit <- auto.arima(timeSeries)
## Predict the forecast
fcast <- forecast(fit)

## Calculating the predicted Hash Rate
tmp <- as.data.frame(fcast)
## Unfortunately the dates are as factors
d <- as.data.frame(lapply(row.names(tmp), as.character),
                   stringsAsFactors = FALSE) ##date as character

## Perform the same as above to extract the index of forecasted hasrates.
iForecast <- as.numeric(tmp[, 1])

## Create a nicely formated vector os the Dates as character
cDates <- as.character(d)

## Pre-load output
Fcast <- as.data.frame(fcast)

## The following code takes the input from the ui.R to display the results
shinyServer(
        function(input, output) {
                xData <- reactive({
                        if (input$prefix == "kH/s") {
                                x <- input$hrate * 1000
                        } else if (input$prefix == "MH/s") {
                                x <- input$hrate * 1000000
                        } else if (input$prefix == "GH/s") {
                                x <- input$hrate * 1000000000
                        } else if (input$prefix == "TH/s") {
                                x <- input$hrate * 1000000000000
                        }
                        x
                })
                ## Render the calculation results table
                output$Table <- renderDataTable({
                        xData <- 0
                        btc <- (25/iForecast * 2^32/xData()/86400) * 30
                        ## Return the Table
                        data.frame(cbind(Date = cDates, Forecast = iForecast, BTC = btc))
                        })
                ## Render the forecast result table
                output$Fcast <- renderDataTable({
                        Fcast
                })
                ## Render the forecast plot
                output$plot <- renderPlot({
                        plot(fcast)
                })
        }
)