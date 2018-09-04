[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SHA256_Rcode** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet:  SHA256_Rcode
 
Published in:      ""
  
Description:       SHA 256 R Code
 
Keywords:          hash, algorithm

See also :         crix, econ_arima, econ_crix, econ_garch, econ_vola

Author:            Raphael Reule
  
Submitted:         Wed, December 23 2017 by Raphael Reule
  
Datafile:          R Script


  

```

### R Code
```r

library("digest")

digest("Hello CRIX", "sha256")
digest("Hallo CRIX", "sha256")
digest("Hello CRIX!", "sha256")


```

automatically created on 2018-09-04