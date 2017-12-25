require(jsonlite)
require(curl)
require(zoo)
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)

#volatility of logreturns (monthly aggregated standard deviation)
returns= data.frame(date = as.yearmon(crix$date[-1], "%y-%m"), returns = diff(log(crix$price)))
agg.month= aggregate(returns ~ date, returns, sd)
agg.days = aggregate(returns ~ date, returns, length)
agg.month$days=agg.days$returns
agg.month$date=as.Date(agg.month$date)
colnames(agg.month)=c("date", "month.std", "days")
agg.month$monthlyvola=sqrt(agg.month$days)*agg.month$month.std*100

plot(agg.month$date, agg.month$monthlyvola, type = "l", col = "grey",lwd = 3, xlab = "Date", 
     ylab = "Monthly aggregated returns volatility")
axis(1,at=agg.month$date,labels=format(agg.month$date,"%Y-%m"),las=1)
