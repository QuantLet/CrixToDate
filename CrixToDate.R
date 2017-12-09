rm(list=ls(all=TRUE))
graphics.off()


# please change your working directory
setwd("~/CrixToDate")

require(jsonlite)
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 3, xlab = "Date", ylab = "Performance of CRIX")  