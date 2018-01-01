# Graph 24h CRIX

require(jsonlite)
require(curl)
json_file <- "http://crix.hu-berlin.de/data/crix_hf.json"
crix <- fromJSON(json_file)


crix$date <- as.POSIXct(crix$date, format="%Y-%m-%d  %H:%M:%S")

plot(crix$date, crix$price/1000, xaxt='n', pch=20, las=1, 
     xlab='24th to 25th of December 2017', ylab='CRIX Price/1000')
axis.POSIXct(1, crix$date, format="%H:%M:%S")
