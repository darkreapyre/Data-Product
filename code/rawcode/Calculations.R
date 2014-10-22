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
x <- 4.363 ##sample hashrate TH/s
## Convert to kH/s
x <- x * 1000000000000
Table <- data.frame(Date = as.Date(character()),
                    Difficulty = numeric(),
                    Btc = numeric(),
                    Total = numeric(),
                    stringsAsFactors = FALSE)
names(Table) <- c("Date", "Difficulty Forecast", "Estimated Btc/Month",
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


## the following will be used later as the index length
dim(tmp)[1] ## Height of the data forecast dataframe
length(iDates) ## height of the dates index
options(scipen = 10) ## get rid of expoential format




