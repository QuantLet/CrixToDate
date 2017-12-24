require(jsonlite)
require(zoo)
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)

#volatility of logreturns (monthly aggregated standard deviation)
ret.table <- data.frame("date"=crix$date[-1], "returns"=diff(log(crix$price)))
ret.table$MY <- as.yearmon(ret.table$date, "%y-%m")
aggr.month.returns <- aggregate(returns ~ MY ,ret.table ,sd)
plot(aggr.month.returns, type = "l", col = "red", lwd = 3, xlab = "Date", 
     ylab = "Monthly aggregated returns volatility")
