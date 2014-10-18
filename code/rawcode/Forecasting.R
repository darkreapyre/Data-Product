library(shiny)
library(ggplot2)
library(xts)
library(forecast)


###Option 1:
##Download the .csv and Read the file into R
df <- read.csv("~/R/Data-Product/data/coindesk-xbtminingdifficulty.csv")

### Option 2: (requires RCurlk Package)
## Pull the data straight from the website
dt <- read.table("http://blockexplorer.com/q/nethash", header = FALSE,
                 sep = ",", skip = 15)

## Extract and convert the Date (in UTC) and Difficulty Value
df <- as.data.frame(as.POSIXct(dt[, 2], origin = '1970-01-01'), format = "%Y/%m/%d")
df[, 2] <- dt[, 5]
names(df) <- c("Date", "Difficulty")
df$Date <- as.Date(as.character(df$Date, format = "%Y-%m-%d"))
plot(df)

## Time Series manipulation options 
## require xts; ggplot2; forecast
 Difficulty <- xts(df$Difficulty, df$Date)
## Create same plot as the rest of the web sites
plot(Difficulty) ## This is a Good Plot

## Using zoo
ser <- with(df, zoo(Difficulty, Date))
plot(ser) ## Produces nice graph!

### The following is a decent ARIMA forecast with Plot
## 
xTS <- xts(df$Difficulty, df$Date)
## Remove duplicates
xTS <- unique(xTS)
TS <- ts(y)
fit <- auto.arima(TS)
FCAST <- forecast(FIT)
plot(FCAST)


##############################################################################################
## Remove duplicate values 
df <- unique(df)
## Create a new xts data.frame
df_xts <- xts(df$Difficulty, df$Date)
## If necessary subset the data from 2013-01-01 to present
x <- df_xts['2013-01-01/']
## Extract the last week's data
y <- last(df_xts, '1 week')
## Change the periodicity to months
z <- to.period(df_xts, 'months')
## change the index from the date to whole months (useful for monthly forecasting)
a <- to.monthly(df_xts)

## Convert to Time-Series and ensure the correct index is yearly, capture only the close
df_xts <- to.monthly(df_xts)
timeSeries <- as.ts(df_xts[, 4], start = c(2009))
fit <- auto.arima(timeSeries)
fcast <- forecast(fit)
plot(fcast)

