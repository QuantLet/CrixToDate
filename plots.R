# Graph 1 (CRIX)

require(jsonlite)
require(curl)
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 3, xlab = "Date", ylab = "Performance of CRIX")

###if you need different color or different axis name, you can change it in respective parameters

# Graph 2 (index components)
# volatility of logreturns of CRIX (monthly aggregated standard deviation)

require(zoo)
#getting returns
ret.table = data.frame(date = crix$date[-1], returns = diff(log(crix$price)))
ret.table$MY = as.yearmon(ret.table$date, "%y-%m")
aggr.month.returns = aggregate(returns ~ MY, ret.table, sd)
aggr.month.returns$returns=aggr.month.returns$returns-mean(aggr.month.returns$returns)
aggr.month.returns$MY=as.Date(aggr.month.returns$MY)

plot(aggr.month.returns, type = "l", col = "grey", xaxt="n", lwd = 3, xlab = "Date", 
     ylab = "Monthly aggregated returns volatility")
axis(1,at=aggr.month.returns$MY,labels=format(aggr.month.returns$MY,"%Y-%m"),las=1)
abline(h = 0)
