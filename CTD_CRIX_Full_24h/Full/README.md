[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **CrixToDate** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet:  CrixToDate
 
Published in:      ""
  
Description:       Produces full and 24h ts plots based on historical hf CRIX data (CRIX Plot)
 
Keywords:          CRIX, plot, time-series, financial, crypto, graphical representation, data visualization

See also :         crix, econ_arima, econ_crix, econ_garch, econ_vola

Author:            Alisa Kolesnikova, Raphael Reule
  
Submitted:         Wed, December 23 2017 by Raphael Reule
  
Datafile:          data sourced from online CRIX json files and historic data provided


  

```

### R Code
```r

# Graph CRIX from CRIX.berlin (website)

# install and load packages
libraries = c("jsonlite", "curl", "zoo")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)
       
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
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

crix <- read.csv("crixdata.csv", header=TRUE, sep=";")
crix$date = as.Date(crix$date)
plot(crix, type = "l", col = "blue3", lwd = 2, xlab = "Date", ylab = "Performance of CRIX", cex.lab = 2)


```

automatically created on 2018-09-04