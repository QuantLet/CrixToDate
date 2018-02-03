# Graph CRIX from CRIX.berlin (website)

# install and load packages
libraries = c("curl", "jsonlite", "zoo")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
       
json_file <- "http://crix.hu-berlin.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 3, xlab = "Date", ylab = "Performance of CRIX", cex.lab = 2)




################################ Alternative
# Graph CRIX from CRIXdata.csv (file)

# install and load packages
libraries = c("curl", "zoo")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})

crix <- read.csv("crixdata.csv", header=TRUE, sep=";")
crix$date = as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 2, xlab = "Date", ylab = "Performance of CRIX", cex.lab = 2)

