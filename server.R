library(UsingR)
library(ggplot2)
library(plyr)

# load US vehicle data
vehicles <- csv.get('vehicles.csv')
makes <- unique(vehicles$make)

filterVehicles <- function(makes, classes) {
  interesting <- subset(vehicles, select=c("co2", "make", "year", "VClass"), year >= 2013 &
                        make %in% makes & VClass %in% classes)
  if (nrow(interesting) > 0) {
    grouped <- aggregate(interesting$co2, by=list(interesting$make, interesting$year), FUN=mean)
    rename(grouped, c("Group.1"="make", "Group.2"="year", "x" = "co2"))
  }
}

shinyServer(  
  function(input, output, session) {
    # Initialize with the top selling brands in US
    selectedMakes <- c("Toyota", "Honda", "Nissan", "Ford", "Hyundai", "Chevrolet")
  
    # Add make to the comparision
    observeEvent(input$addMake, {
      selectedMakes <<- c(selectedMakes, input$makes)
    })
    
    # Remove make(s) from comparision
    observeEvent(input$removeMake, {
      print(input$checkedMakes)
      selectedMakes <<- Filter(function(x) !(x %in% input$checkedMakes), selectedMakes)
    })
    
    
    # Output plot of co2 emissions, separate each make by color
    observeEvent({ input$removeMake; input$addMake; input$classes; }, 
      output$co2emissions <- renderPlot({ 
        grouped <- filterVehicles(selectedMakes, input$classes)
        qplot(data=grouped, x=year, y=co2, color=make) + geom_line()
    }))
    
    # output list of all makes
    output$makes <- renderUI({
      makeInputs <- as.list(makes)
      names(makeInputs) <- makes
      selectInput("makes", label = h3("All Makes"), 
                  choices = makeInputs)
    })
    
    # update checkbox list of makes
    observeEvent({ input$removeMake; input$addMake; input$classes; }, {
      output$checkedMakes <- renderUI({
        makes <- selectedMakes
        makeInputs <- as.list(makes)
        names(makeInputs) <- makes
        checkboxGroupInput("checkedMakes", h3("Selected makes"), choices=makeInputs)
      })
    })
    output$instructions <- renderText("<h3>Instructions</h3><p>This app plots the average CO2 emission for the selected vehicles classes and makes. Makes are shown in different colours and the values are averaged yearly.</p><p>You can select interesting vehicle classes from the checkboxes. You can add makes to the comparision with 'Add to plot' and remove them with by checking them and then clicking 'Remove checked'.</p><p>Source data is from here: http://www.fueleconomy.gov/feg/ws/index.shtml</p>")
    output$plotHeading <- renderText("<h3>CO2 Emission plot</h3>")
  }
  
)