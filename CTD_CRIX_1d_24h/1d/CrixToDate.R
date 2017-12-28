# Graph CRIX

require(jsonlite)
require(zoo)
crix <- read.csv("crixdata.csv", header=TRUE, sep=";")
crix$date = as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 2, xlab = "Date", ylab = "Performance of CRIX", cex.lab = 2)


##require(jsonlite)
##require(curl)
##json_file <- "http://crix.hu-berlin.de/data/crix.json"
##crix <- fromJSON(json_file)
##crix$date <- as.Date(crix$date)
##plot(crix, type = "l", col = "blue3", lwd = 3, xlab = "Date", ylab = "Performance of CRIX")
