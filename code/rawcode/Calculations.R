### Calculating the predicted Hash Rate of (assumes forcastng has been done "fcast")
df_fcast <- as.data.frame(fcast)

## Assess whether or not it's possible to create an XTS or ZOO data frame for date
## manupiuation since the resultant forcast has the first row as character data.
## It is important to get the string data into date format to determine what number
## of days in a month as the hasrate is output is in seconds and covnerted to days.
## to see the irst row strings/characters:
row.names(df_fcast)

## Use zoo() or yearmon() [or even some funciton in ts()] to convert the format.
## Also look at monthdays(time) to get the no. of days. NOTE that this is POSIXt 
## format.





## build a data frame of the input hash rate to the predicted dfficulty using a function
## (output = difficulty * 2^32 / Hashrate)
## Output is in seconds, so to calculate the in 24 hours:
## 86400 seconds per day / ( difficulty * 2^32 /hashrate)
## NOTE: Don't forgtet to accrue the total for each month




## Append the next set of rows, accruing the total for the month + previous months