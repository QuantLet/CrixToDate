rm(list=ls(all=TRUE))
graphics.off()


# please change your working directory
setwd("~/CrixToDate")



require(jsonlite)
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 3, xlab = "Date", ylab = "Performance of CRIX")  



#now to volatility: two ways to go here: volatility of index or volatility of RETURNS on index
#volatility of index(monthly aggregated standard deviation)
require(zoo)
crix$MY <- as.yearmon(crix$date, "%y-%m")
aggr.std <- aggregate(crix ~ Date ,ret ,sd)
#deletingfirst  entry as there is just one July  entry
crix <- crix[-1,]
aggr.month <- aggregate(price ~ MY ,crix ,sd)
plot(aggr.month, type = "l", col = "green", lwd = 3, xlab = "Date", ylab = "Monthly aggregated volatility")



#volatility of logreturns (monthly aggregated standard deviation)
crix$returns <- diff(log(crix$price))
ret.table <- data.frame("date"=crix$date[-1], "returns"=diff(log(crix$price)))
ret.table$MY <- as.yearmon(ret.table$date, "%y-%m")
aggr.month.returns <- aggregate(returns ~ MY ,ret.table ,sd)
plot(aggr.month.returns, type = "l", col = "red", lwd = 3, xlab = "Date",  ylab = "Monthly aggregated returns volatility")
     
     
     