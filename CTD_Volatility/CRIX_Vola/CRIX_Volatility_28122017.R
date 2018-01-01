# 1. plot of CRIX

require(jsonlite)
require(zoo)
crix <- read.csv("crixdata.csv", header=TRUE, sep=";")
crix$date = as.Date(crix$date)

returns= data.frame(date = as.yearmon(crix$date[-1], "%y-%m"), returns = diff(log(crix$price)))
agg.month= aggregate(returns ~ date, returns, sd)
agg.days = aggregate(returns ~ date, returns, length)
agg.month$days=agg.days$returns
agg.month$date=as.Date(agg.month$date)
colnames(agg.month)=c("date", "month.std", "days")
agg.month$monthlyvola=sqrt(agg.month$days)*agg.month$month.std*100

plot(agg.month$date, agg.month$monthlyvola, type = "l", col = "red",lwd = 2, xlab = "Date",
     ylab = "Monthly aggregated returns volatility", cex.lab = 1.5)
axis(1,at=agg.month$date,labels=format(agg.month$date,"%Y-%m"),las=1)

