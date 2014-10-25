options(scipen = 10)
library(lubridate)
library(shiny)
library(xts)
library(forecast)

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
## Convert to Time-Series and ensure the correct index is monthly.,
dfXts <- to.monthly(dfXts)
timeSeries <- as.ts(dfXts[, 4], start = c(2009))
## Fit the Automatic Arima model
fit <- auto.arima(timeSeries)
## Predict the forecast
fcast <- forecast(fit)

## Calculating the predicted Hash Rate (assumes forcastng has
## been done "fcast") in a data frame.
## since fcast is it's own object, extract the date in a 
## manipulatable foramt for lubridate.
tmp <- as.data.frame(fcast)
## Unfortunately the dates are as factors
d <- as.data.frame(lapply(row.names(tmp), as.character),
                   stringsAsFactors = FALSE) ##date as character
## Create the final index of dates
iDates <- mdy(d)

## Perform the same as above to extract the index of forecasted hasrates.
iForecast <- as.numeric(tmp[, 1])

## Create a nicely formated vector os the Dates as character
cDates <- as.character(d)

## Create the initial output Table
##oTable <- data.frame(col1 = character(),
##                    col2 = numeric(),
##                    col3 = numeric(),
##                    col4 = numeric(),
##                    stringsAsFactors = FALSE)
##names(oTable) <- c("Date", "Difficulty Forecast",
##                  "Estimated Btc/Month",
##                  "Total Accumulated Btc")

btcCalc <- function(x, i) {
        result <- 25/(iForecast[i] * 2^32/x/86400) * days_in_month(iDates[i])[[1]]
        return(result)
}

## The following code takes the input from the UI.r to display the prediction
shinyServer(
        function(input, output) {
                xData <- reactive({
                        if (input$prefix == "kH/s") {
                                x <- as.numeric(input$hrate * 1000)
                        } else if (input$prefix == "MH/s") {
                                x <- as.numeric(input$hrate * 1000000)
                        } else if (input$prefix == "GH/s") {
                                x <- as.numeric(input$hrate * 1000000000)
                        } else if (input$prefix == "TH/s") {
                                x <- as.numeric(input$hrate * 1000000000000)
                        }
                        x
                })
                output$Table <- renderDataTable({
                        xData <- 0
                        ##btc <- as.integer(25/(iForecast * 2^32/xData()/86400)) * (as.numeric(days_in_month(iDates[[1]])))
                        btc <- (25/iForecast * 2^32/xData()/86400) * 30
                        
                        ## Return the Table
                        as.data.frame(cbind(cDates, iForecast, btc))
                        })
                output$Fcast <- renderDataTable({
                        Fcast <- as.data.frame(fcast)
                        Fcast
                })
                output$plot <- renderPlot({
                        plot(fcast)
                })
        }
        
        
        )