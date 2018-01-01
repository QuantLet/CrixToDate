setwd("~/Documents/PythiaR/GARCH")

rm(list=ls(all=TRUE))
graphics.off()


# install and load packages
libraries = c("readxl", "xtable", "igraph", "zoo", "igraph", 
              "xts", "moments", "tseries", "forecast", "fGarch")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

## Load data Traditional assts
TRAD_ASSETS            = data.frame(read_excel("20171108Traditional_assets_indices_20130101_20171101.xlsx", sheet = "Sheet3"))
row.names(TRAD_ASSETS) = as.Date(TRAD_ASSETS$Date, origin = "1899-12-30")
TRAD_ASSETS$Date       = NULL
# CC prices, capitalization and volume
CAP                    = read.delim("CC_CAP_20140101_20161231.txt", sep = ";")
PRICE                  = read.delim("CC_PRICE_20140101_20161231.txt", sep = ";")
VOLUME                 = read.delim("CC_VOLUME_20140101_20161231.txt", sep = ";")
CAP$Date               = as.Date(CAP$date, origin = "1899-12-30")
CAP                    = CAP[order(CAP$Date), -1]
row.names(CAP)         = CAP$Date
CAP$Date               = NULL
CAP                    = CAP[row.names(CAP) > as.Date("2013-12-31") & row.names(CAP) < 
                         as.Date("2017-01-01"), ]
PRICE$Date             = as.Date(PRICE$date, origin = "1899-12-30")
PRICE = PRICE[order(PRICE$Date), -1]
row.names(PRICE) = PRICE$Date
PRICE$Date = NULL
VOLUME$Date = as.Date(VOLUME$date, origin = "1899-12-30")
VOLUME = VOLUME[order(VOLUME$Date), -1]
PRICE = PRICE[row.names(PRICE) > as.Date("2013-12-31") & row.names(PRICE) < 
                as.Date("2017-01-01"), ]
colnames(PRICE) = toupper(colnames(PRICE))
colnames(CAP) = toupper(colnames(CAP))
years = unique(format(as.Date(rownames(PRICE)), "%Y"))

# Build annual prices TS
CC_data = list()

for (year in years) {
    CC_data$PRICE[[year]]  = PRICE[format(as.Date(rownames(PRICE)), "%Y") == year, ]
    CC_data$CAP[[year]]    = CAP[format(as.Date(rownames(CAP)), "%Y") == year, ]
    CC_data$VOLUME[[year]] = VOLUME[format(as.Date(rownames(PRICE)), "%Y") == year, ]
    CC_data$max_cc[[year]] = tail(sort(apply(CC_data$CAP[[year]], 2, mean, na.rm = T)), 10)
    CC_data$CC_PRICE_max[[year]] = subset(CC_data$PRICE[[year]], 
                                          select = names(CC_data$max_cc[[year]]))
    CC_data$TRAD_CC_PRICE_max[[year]] = merge(CC_data$CC_PRICE_max[[year]], 
                                              TRAD_ASSETS[format(as.Date(rownames(TRAD_ASSETS)), 
                                             "%Y") == year, ], by = "row.names")[, -1]
    CC_data$PRICE_max_without_na[[year]] = na.locf(CC_data$TRAD_CC_PRICE_max[[year]])
    CC_data$PRICE_max_xts[[year]] = xts(CC_data$PRICE_max_without_na[[year]], 
                                       order.by = as.Date(row.names(CC_data$PRICE[[year]])))
    CC_data$RET_max_xts[[year]] = diff(log(CC_data$PRICE_max_xts[[year]]), 
                                      na.pad = TRUE)
    CC_data$COR_MAT[[year]] = data.frame(cor(CC_data$RET_max_xts[[year]]
                              [, c(1:10, 14, 22)], use = "pairwise.complete.obs"))
    COR_MAT_graph = CC_data$COR_MAT[[year]]
    COR_MAT_graph[abs(CC_data$COR_MAT[[year]]) < 0.5] = 0
    diag(COR_MAT_graph) = 0
    CC_data$COR_MAT_graph[[year]] = COR_MAT_graph
}

# For whole time period
max_cryptos       = apply(CAP, 2, mean, na.rm = T)
max_cryptos       = tail(sort(max_cryptos), 10)
PRICE_max         = subset(PRICE, select = names(max_cryptos))
TRAD_CC_PRICE_max = merge(PRICE_max, TRAD_ASSETS, by = "row.names")[, -1]
                                                                    
# Cleaning NaN
PRICE_without_na     = na.locf(PRICE)
PRICE_max_without_na = na.locf(TRAD_CC_PRICE_max)

# XTS creation
PRICE_xts     = xts(PRICE_without_na, order.by = as.Date(row.names(PRICE)))
PRICE_max_xts = xts(PRICE_max_without_na, order.by = as.Date(row.names(PRICE_max)))

# Returns
RET_xts     = diff(log(PRICE_xts), na.pad = TRUE)
RET_max_xts = diff(log(PRICE_max_xts), na.pad = TRUE)


## GARCH
##grep("ETH", colnames(RET_max_xts))
res = na.omit(RET_max_xts[,6])
res2 = res^2
fg11 = garchFit(data = res, data ~ garch(1, 1))
summary(fg11)
fg12 = garchFit(data = res, data ~ garch(1, 2))
summary(fg12)
fg21 = garchFit(data = res, data ~ garch(2, 1))
summary(fg21)
fg22 = garchFit(data = res, data ~ garch(2, 2))
summary(fg22)

plot(fg11, which="ask")


# Save data
save.image(file = "CC_MAX_GARCH.RData")
