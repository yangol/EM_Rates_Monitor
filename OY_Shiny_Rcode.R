library(RQuantLib)
library(termstrc)
# data(govbonds)


generateinput=function(country) {
  countrydf=read.csv(paste0('/Users/olgayangol/Documents/R/OY_Shiny_project/',country,'.csv'))
  countrydf=countrydf[countrydf$Maturity..Years.from.Today.>1,]
  curveparams = list(method="ExponentialSplinesFitting",
                     origDate = Sys.Date())
  marketQuotes=countrydf$Ask.Price
  lengths=countrydf$Maturity..Years.from.Today.
  coupons=countrydf$Cpn/100
  dateparams = list(settlementDays=countrydf$Days.to.Settle[[1]], period="Semiannual",
                    dayCounter="Thirty360",
                    businessDayConvention ="Following") 
  curveinput=list(curveparams=curveparams,lengths=lengths,coupons=coupons,marketQuotes=marketQuotes,dateparams=dateparams)
  return(curveinput)
  #return(countrydf)
}

Russiainput=generateinput("Russia")
#Brazilinput=generateinput("Brazil")
Mexicoinput=generateinput('Mexico')
South_Africainput=generateinput('South_Africa')
Turkeyinput=generateinput('Turkey')
Polandinput=generateinput('Poland')
Indonesiainput=generateinput('Indonesia')

returnCurve=function(input) {
  curveparams = input$curveparams
  lengths = input$lengths
  coupons = input$coupons
  marketQuotes = input$marketQuotes
  dateparams = input$dateparams
  curve = FittedBondCurve(curveparams, lengths, coupons, marketQuotes, dateparams)
  z <- zoo::zoo(curve$table$zeroRates, order.by=curve$table$date)
  plot(z)
  return (curve)
}

returnCurve(Polandinput)

Indonesia_rawdata=returnCurve(Indonesiainput)

Indonesiadf=Indonesia_rawdata$table
Indonesiadf[30,]

