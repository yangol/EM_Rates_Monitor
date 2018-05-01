shinyUI(dashboardPage(
  dashboardHeader(title = "Emerging Markets"),
  dashboardSidebar(
    # Header
    sidebarUserPanel("Olga Yangol",
                     subtitle = "Portfolio Manager" ,
                     image =  "OlgaYangol.png"),
    
    # Select country
    selectizeInput("countrySelected",  "Select a country", choice = countryChoices, select = 'Russia'),
    
    # Select metric
    selectizeInput("metricSelected",  "Select a metric to highlight", choice = metricChoices, select = 'coupon'),
    
    # Result
    sidebarMenu(
      menuItem("Result", tabName = "result", icon = icon("database")))
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "result",
              # gvisGeoChart
              fluidRow(infoBoxOutput("maxBox"),
                       infoBoxOutput("minBox"),
                       infoBoxOutput("avgBox")),
              fluidRow(infoBoxOutput("maxBox2"),
                       infoBoxOutput("minBox2"),
                       infoBoxOutput("avgBox2")),
              fluidRow(plotOutput('curveZero')),
              fluidRow(box(DT::dataTableOutput("showData"),width = 12))
              )
      
    )
  )
))