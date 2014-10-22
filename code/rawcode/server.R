library(shiny)
library(ggplot2)
library(xts)
library(forecast)
library(lubridate)

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

## The following code takes the input from the UI.r to display the prediction
shinyServer(
        function(input, output) {
                
        }
        
        )
