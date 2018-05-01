#install.packages("shinydashboard") 

# functions defined

extractMinMaxMaturity = function(country) {
  countrydf=read.csv(paste0(country,'.csv'), stringsAsFactors = F)
  #extract the minimum and maximum maturity for the x axis of the plot
  #maturity=c(as.Date(min(countrydf$Maturity),"%m/%d/%Y"),as.Date(max(countrydf$Maturity),"%m/%d/%Y"))
  maturity=c(as.Date(countrydf$Maturity[1],"%m/%d/%Y"),as.Date(tail(countrydf$Maturity,n=1),"%m/%d/%Y"))
  return(maturity)
}

generateInput=function(country) {
  # countrydf=read.csv(paste0('/Users/olgayangol/Documents/R/OY_Shiny_project/',country,'.csv'))
  countrydf=read.csv(paste0(country,'.csv'), stringsAsFactors = F)
  countrydf=countrydf[countrydf$Maturity..Years.from.Today.>1,]
  curveparams = list(method="ExponentialSplinesFitting",
                     origDate = Sys.Date())
  marketQuotes=countrydf$Ask.Price
  lengths=countrydf$Maturity..Years.from.Today.
  coupons=countrydf$Cpn/100
  dateparams = list(settlementDays=countrydf$Days.to.Settle[[1]], period="Semiannual",
                    dayCounter="Thirty360",
                    businessDayConvention ="Following") 

  curveinput=list(curveparams=curveparams,lengths=lengths,coupons=coupons,
                  marketQuotes=marketQuotes,dateparams=dateparams)
  return(curveinput)
}

generateMetrics=function(country,CBrates) {
  countrydf=read.csv(paste0(country,'.csv'),stringsAsFactors = F)
  carry=round(countrydf$Yld.to.Mty..Ask.-CBrates[,country],2)
  metricstable=cbind(ISIN=countrydf$ISIN, Ticker=countrydf$Ticker,Coupon=countrydf$Cpn,
                     Maturity=countrydf$Maturity,Yield=round(countrydf$Yld.to.Mty..Ask.,2),
                     Duration=round(countrydf$Modified.Duration..Ask.,2),Carry=carry)
  metricstable=as.data.frame(metricstable)
  metricstable$Coupon = as.numeric(as.character(metricstable$Coupon))
  metricstable$Yield = as.numeric(as.character(metricstable$Yield))
  metricstable$Carry = as.numeric(as.character(metricstable$Carry))
  #metricstable$Maturity = as.numeric(as.character(metricstable$Maturity))
  return (metricstable)
}

returnCurve=function(input, minMaxVector) {
  curveparams = input$curveparams
  lengths = input$lengths
  coupons = input$coupons
  marketQuotes = input$marketQuotes
  dateparams = input$dateparams
  curve = FittedBondCurve(curveparams, lengths, coupons, marketQuotes, dateparams)
  result = curve$table
  result = result %>% filter(.,date<=minMaxVector[2]) %>% filter(.,date>=minMaxVector[1])
  return (result)
}

### Core R Shiny
function(input,output) {

  # Get min max maturity
  minMaxMaturity = reactive({extractMinMaxMaturity(input$countrySelected)})
  
  # Get Zero Curve Data
  curveData = reactive({returnCurve(generateInput(input$countrySelected),minMaxMaturity())})
  
  # Zero Curve Plot
  output$curveZero = renderPlot({
    ggplot(curveData(),aes(x=date,y=zeroRates))+geom_line(colour='red',size=1)
  })
  
  # Metric Table
  output$showData <- DT::renderDataTable({
    datatable(generateMetrics(input$countrySelected, CBrates), rownames=FALSE) %>% 
      formatStyle(input$metricSelected,  
                  background="skyblue", fontWeight='bold')
  })
  
  # Box calculation
  output$maxBox <- renderInfoBox({
    max_value <-round(max(generateMetrics(input$countrySelected, CBrates)[,'Carry']),2)
    max_state <- 'Max Carry'
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  output$minBox <- renderInfoBox({
    min_value <- round(min(generateMetrics(input$countrySelected, CBrates)[,'Carry']),2)
    min_state <- 'Min Carry'
    infoBox(min_state, min_value, icon = icon("hand-o-down"))
  })
  output$avgBox <- renderInfoBox({
    avg_value <-round(mean(generateMetrics(input$countrySelected, CBrates)[,'Carry']),2)
    avg_state <- 'Avg. Carry'
    infoBox(avg_state, avg_value, icon = icon("calculator"))
  })
  output$maxBox2 <- renderInfoBox({
    max_value <- round(max(generateMetrics(input$countrySelected, CBrates)[,'Yield']),2)
    max_state <- 'Max Yield'
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  output$minBox2 <- renderInfoBox({
    min_value <- round(min(generateMetrics(input$countrySelected, CBrates)[,'Yield']),2)
    min_state <- 'Min Yield'
    infoBox(min_state, min_value, icon = icon("hand-o-down"))
  })
  output$avgBox2 <- renderInfoBox({
    avg_value <- round(mean(generateMetrics(input$countrySelected, CBrates)[,'Yield']),2)
    avg_state <- 'Avg. Yield'
    infoBox(avg_state, avg_value, icon = icon("calculator"))
  })
}