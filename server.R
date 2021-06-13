################################ Server ################################
# dataFrame <- data.frame(pointName = namePoints[1:10], xAxis = sample(x = 1:100, size = 10, replace = F), yAxis = sample(x = 1:100, size = 10, replace = F))

namePoints <<- c(LETTERS[seq(from = 1, to = 26)],paste0(LETTERS[seq(from = 1, to = 26)],LETTERS[seq(from = 1, to = 26)]))

fitnessFunction <<- function(distMatrix, tour){
  tour <- c(tour, tour[1])
  route <- embed(tour, 2)[,2:1]
  fitness = -sum(distMatrix[route])
  return(fitness)
}

server <- function(input, output, session){
  
  # Declaring the values to update:
  updatedValues <- reactiveValues(plot = ggplot(), pointPositions = 0)
  
  # Plotting the city:
  updatedValues$plot <- ggplot(data = expand.grid(xAxis = seq(from = 1, to = 100, by = 5), yAxis = seq(from = 1, to = 100, by = 5))) +
    geom_point(aes(x = xAxis, y = yAxis), size = 0.1, color = "white")+
    theme_minimal()+
    xlab("Direction X")+
    ylab("Direction Y")+
    theme_void()+
    theme(panel.background = element_rect("#006272"))
  
  output$city <- renderPlot(updatedValues$plot)
  
  output$info <- renderText({
    xy_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    paste0(
      "Current Cursor Position: ", xy_str(input$ipHover)
    )
  })
  
  
  
  # On click of a point in the graph, record the coordinates of the point and highlight the point on graph
  observeEvent(eventExpr = input$ipPosition,{
    if(!is.data.frame(updatedValues$pointPositions)){
      updatedValues$pointPositions <- data.frame(pointName = namePoints[1], xAxis = round(input$ipPosition$x,2), yAxis = round(input$ipPosition$y,2))
    }else(
      updatedValues$pointPositions <-  rbind(updatedValues$pointPositions,data.frame(pointName = namePoints[nrow(updatedValues$pointPositions)+1], xAxis = round(input$ipPosition$x,2), yAxis = round(input$ipPosition$y,2)))
    )
    # print(updatedValues$pointPositions)
    updatedValues$plot <- updatedValues$plot +
      geom_point(data = updatedValues$pointPositions, aes(x = xAxis, y = yAxis), size = 3.6, color = "gold") +
      geom_text(data = updatedValues$pointPositions, aes(x = xAxis, y = yAxis, label = pointName), hjust = -1.25, vjust = -1.25, color = "gold")
  })
  
  
  
  
  # On click of find shortest route button, run GA and find shortest route, populate path on graph
  observeEvent(input$execGA, {
    req(nrow(updatedValues$pointPositions)>2)
    
    updatedValues$plot <- ggplot(data = expand.grid(xAxis = seq(from = 1, to = 100, by = 5), yAxis = seq(from = 1, to = 100, by = 5))) +
      geom_point(aes(x = xAxis, y = yAxis), size = 0.1, color = "white")+
      theme_minimal()+
      xlab("Direction X")+
      ylab("Direction Y")+
      theme_void()+
      theme(panel.background = element_rect("#006272")) +
      geom_point(data = updatedValues$pointPositions, aes(x = xAxis, y = yAxis), size = 3.6, color = "gold") +
      geom_text(data = updatedValues$pointPositions, aes(x = xAxis, y = yAxis, label = pointName), hjust = -1.25, vjust = -1.25, color = "gold")
    
    distMatrix <- dist(x = updatedValues$pointPositions[,2:3], upper = T, method = "euclidean", diag = T)
    distMatrix <- as.matrix(distMatrix)
    show_modal_spinner(spin = "fading-circle", color = "#006272", text = "Executing Genetic Algorithm Search For Optimal Path") # show the modal window
    gaOutput <- ga(type = "permutation", crossover = "gaperm_pbxCrossover", fitness = fitnessFunction, distMatrix = distMatrix, lower = 1, upper = nrow(updatedValues$pointPositions), popSize = 50, maxiter = 5000, run = 500, pmutation = 0.2)
    routeAssigned <- as.vector(gaOutput@solution[1,])
    routeAssigned <- c(routeAssigned,routeAssigned[1])
    n <- length(routeAssigned)
    updatedValues$plot <- updatedValues$plot +
      geom_segment(data = updatedValues$pointPositions, aes(x = xAxis[routeAssigned[-n]], y = yAxis[routeAssigned[-n]], xend = xAxis[routeAssigned[-1]], yend = yAxis[routeAssigned[-1]]), color = "orange", arrow = arrow())
    remove_modal_spinner() # remove it when done
  })
  
  
  
  
  # On click of clear graph button, restart the graph:
  observeEvent(eventExpr = input$clearCity, {
    # Reset graph
    updatedValues$plot <- ggplot(data = expand.grid(xAxis = seq(from = 1, to = 100, by = 5), yAxis = seq(from = 1, to = 100, by = 5))) +
      geom_point(aes(x = xAxis, y = yAxis), size = 0.1, color = "white")+
      theme_minimal()+
      xlab("Direction X")+
      ylab("Direction Y")+
      theme_void()+
      theme(panel.background = element_rect("#006272"))
    
    # Reset the coordinates
    updatedValues$pointPositions <- 0
  })
}

