## global.R ##

# load library

library(rsconnect)
library(shinydashboard)
library(DT)
library(shinydashboard)
library(googleVis)
library(ggplot2)
library(dplyr)
library(RQuantLib)

# Country list and metric list
countryChoices = c('Brazil', 'Indonesia', 'Mexico', 'Poland', 'Russia', 'South_Africa', 'Turkey')
metricChoices = c('ISIN','Ticker','Coupon','Maturity','Yield','Duration','Carry' )
CBrates=read.csv("CB_rates.csv", stringsAsFactors = F)


