[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **CrixToDate** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet:  CrixToDate
 
Published in:      ""
  
Description:       Produces full and 24h ts plots based on historical hf CRIX data (CRIX Plot)
 
Keywords:          CRIX, plot, time-series, financial, crypto, graphical representation, data visualization

See also :         crix, econ_arima, econ_crix, econ_garch, econ_vola

Author:            Raphael Reule
  
Submitted:         Thu, December 13 2018 by Raphael Reule
  
Datafile:          data sourced from online CRIX json files and historic data provided


  

```

### R Code
```r

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

# Log Returns Crix
plot(crix$date[-1], diff(log(crix$price)), type = "l", col = "steelblue", lwd = 2, xlab = "Date", ylab = "", cex.lab = 2, xaxt = "n")
axis.Date(1,at = seq(min(crix$date),max(crix$date),by = "6 mon"), format = "%m-%Y")
title(ylab = "Log returns of CRIX", line = 2, cex.lab = 2)






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
```

automatically created on 2019-02-20