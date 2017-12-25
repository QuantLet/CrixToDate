# Graph CRIX

require(jsonlite)
require(curl)
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 3, xlab = "Date", ylab = "Performance of CRIX")

###if you need different color or different axis name, you can change it in respective parameters
