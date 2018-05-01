CBrates=read.csv("/Users/olgayangol/Documents/R/OY_Shiny_project/CB_rates.csv")
Russiadf=read.csv("/Users/olgayangol/Documents/R/OY_Shiny_project/Russia.csv",stringsAsFactors = F)


CBrates=read.csv("CB_rates.csv")
Russiadf=read.csv("Russia.csv",stringsAsFactors = F)

carry=round(Russiadf$Yld.to.Mty..Ask.-CBrates$"Russia",2)
metricstable=cbind(ISIN=Russiadf$ISIN, Ticker=Russiadf$Ticker,Coupon=Russiadf$Cpn,
                   Maturity=Russiadf$Maturity,Yield=Russiadf$Yld.to.Mty..Ask.,
                   Duration=round(Russiadf$Modified.Duration..Ask.,2),Carry=carry)
head(metricstable)


#Trying to write the above as a function

generateMetrics=function(country) {
# CBrates=read.csv("/Users/olgayangol/Documents/R/OY_Shiny_project/CB_rates.csv")
CBrates=read.csv("CB_rates.csv")
countrydf=read.csv(paste0('/Users/olgayangol/Documents/R/OY_Shiny_project/',country,'.csv'),stringsAsFactors = F)
carry=round(countrydf$Yld.to.Mty..Ask.-CBrates$country,2)
metricstable=cbind(ISIN=countrydf$ISIN, Ticker=countrydf$Ticker,Coupon=countrydf$Cpn,
                   Maturity=countrydf$Maturity,Yield=countrydf$Yld.to.Mty..Ask.,
                   Duration=round(countrydf$Modified.Duration..Ask.,2),Carry=carry)
return (metricstable)
}
  

  