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

returns= data.frame(date = as.yearmon(crix$date[-1], "%y-%m"), returns = diff(log(crix$price)))
agg.month= aggregate(returns ~ MY, ret.table, sd)
agg.days = aggregate(returns ~ MY, ret.table, length)
agg.month$days=days$returns
agg.month$MY=as.Date(agg.month$MY)
colnames(agg.month)=c("date", "month.std", "days")
agg.month$monthlyvola=sqrt(agg.month$days)*agg.month$month.std*100

plot(agg.month$date, agg.month$monthlyvola, type = "l", col = "grey",lwd = 3, xlab = "Date", 
ylab = "Monthly aggregated returns volatility")
axis(1,at=agg.month$date,labels=format(agg.month$date,"%Y-%m"),las=1)
