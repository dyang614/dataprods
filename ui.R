shinyUI(pageWithSidebar(  
  headerPanel("CO2 Emissions of cars"),  
  sidebarPanel(
    checkboxGroupInput('classes', label=h3("Vehicle Classes"), 
                       choices = list("Two-Seaters" = "Two-Seaters", 
                         "Minicompact Cars" = "Minicompact Cars", 
                         "Compact Cars" = "Compact Cars", 
                         "Midsize Cars" = "Midsize Cars", 
                         "Large Cars" = "Large Cars"),
                       selected = c("Compact Cars", "Midsize Cars")),
    uiOutput('makes'),
    actionButton('addMake', "Add to plot"),
    uiOutput('checkedMakes'),
    actionButton('removeMake', 'Remove checked')
  ), 
  mainPanel(    
    htmlOutput("instructions"),
    htmlOutput("plotHeading"),
    plotOutput('co2emissions')
  )
))