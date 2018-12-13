# General File Preperation

# Reset Workspace
rm(list = ls(all = TRUE))

# Load Necessary Packages
libraries = c("jsonlite", "curl", "zoo")
lapply(libraries, function(x)
  if (!(x %in% installed.packages())) {
    install.packages(x)
  }
)
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

#-------------------------------------------------------------------------------

# Graph CRIX - based on website

# Get Data
json_file <- "http://data.thecrix.de/data/crix.json"
crix <- fromJSON(json_file)
crix$date <- as.Date(crix$date)

# Regular Crix
plot(crix, type = "l", col = "steelblue", lwd = 3, xlab = "Date", ylab = "", cex.lab = 1.5, xaxt = "n")
axis.Date(1,at = seq(min(crix$date),max(crix$date),by = "6 mon"), format = "%m-%Y")
title(ylab = "Performance of CRIX", line = 2, cex.lab = 2)

# Log(Crix)
plot(crix$date, log(crix$price), type = "l", col = "steelblue", lwd = 2, xlab = "Date", ylab = "", cex.lab = 2, xaxt = "n")
axis.Date(1,at = seq(min(crix$date),max(crix$date),by = "6 mon"), format = "%m-%Y")
title(ylab = "Performance of log(CRIX)", line = 2, cex.lab = 2)




#-------------------------------------------------------------------------------

### Alternative
# Graph CRIX - based on stored csv (not up-to-date)

# Get Data
crix <- read.csv("crixdata.csv", header=TRUE, sep=";")
crix$date = as.Date(crix$date)

# Regular Crix
plot(crix, type = "l", col = "steelblue", lwd = 2, xlab = "Date", ylab = "", cex.lab = 2, xaxt = "n")
axis.Date(1,at = seq(min(crix$date),max(crix$date),by = "6 mon"), format = "%m-%Y")
title(ylab = "Performance of CRIX", line = 2, cex.lab = 2)

# Log Log(Crix)
plot(crix$date, log(crix$price), type = "l", col = "steelblue", lwd = 2, xlab = "Date", ylab = "", cex.lab = 2, xaxt = "n")
axis.Date(1,at = seq(min(crix$date),max(crix$date),by = "6 mon"), format = "%m-%Y")
title(ylab = "Performance of log(CRIX)", line = 2, cex.lab = 2)
