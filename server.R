options(scipen = 10)
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
                output$Table <- renderDataTable({
                        ## Input hashrate
                        x <- input$hrate
                        ## convert the input to hashes/s
                        if (input$prefix == "kH/s") {
                                x <- x * 1000
                        } else if (input$hrate == "MH/s") {
                                x <- x * 1000000
                        } else if (input$hrate == "GH/s") {
                                x <- x * 1000000000
                        } else {
                                x <- x * 1000000000000
                        }
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
                        iForecast <- tmp[, 1]
                        
                        ## Create the output Table
                        Table <- data.frame(Date = as.Date(character()),
                                            Difficulty = numeric(),
                                            Btc = numeric(),
                                            Total = numeric(),
                                            stringsAsFactors = FALSE)
                        names(Table) <- c("Date", "Difficulty Forecast",
                                          "Estimated Btc/Month",
                                          "Total Accumulated Btc")
                        ## Populate the first row of the Table
                        Table[1, 1] <- iDates[1]
                        Table[1, 2] <- iForecast[1]
                        Table[1, 3] <- 25/(iForecast[1] * 2^32/x/86400) * days_in_month(Table[1,1])[[1]]
                        Table[1, 4] <- Table[1, 3]
                        
                        ## Apply the above format into a loop
                        for (i in 2:length(iForecast)) {
                                Table[i, 1] <- iDates[i]
                                Table[i, 2] <- iForecast[i]
                                Table[i, 3] <- 25/(iForecast[i] * 2^32/x/86400) * days_in_month(Table[i, 1])[[1]]
                                Table[i, 4] <- Table[i, 3] + Table[i-1, 4]
                        }
                        ## Return the Table
                        Table
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