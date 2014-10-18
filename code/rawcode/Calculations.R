### Calculating the predicted Hash Rate of (assumes forcastng has been done "fcast")
df_fcast <- as.data.frame(fcast)
## build a data frame of the input hash rate to the predicted dfficulty using a function
## (output = difficulty * 2^32 / Hashrate)
## Output is in seconds, so to calculate the in 24 hours:
## 86400 seconds per day / ( difficulty * 2^32 /hashrate)
## NOTE: Don't forgtet to accrue the total for each month



### Build the first row of an output data frame
## use zoo and yearmon() to convert the date from a string
## This will be used to used to calsulate the number of days in as month


## First row strings
row.names(df_fcast)

## Append the next set of rows, accruing the total for the month + previous months