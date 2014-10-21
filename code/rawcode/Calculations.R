### Calculating the predicted Hash Rate (assumes forcastng has
### been done "fcast") in a data frame.
## since fcast is it's own object, extract the date in a 
## manipulatable foramt for lubridate.
tmp <- as.data.frame(fcast)
d <- as.data.frame(lapply(row.names(tmp), as.character),
                   stringsAsFactors = FALSE) ##date as character
dates <- mdy(d)

## the following will be used later as the index length
dim(tmp)[1] ## Height of the data forecast dataframe
length(dates) ## height of the dates index




