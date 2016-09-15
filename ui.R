shinyUI(pageWithSidebar(  
  headerPanel("Average CO2 emissions by make and year"),  
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
    plotOutput('co2emissions')
  )
))