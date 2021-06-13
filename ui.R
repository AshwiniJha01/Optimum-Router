library(dplyr)
library(ggplot2)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)
library(GA)
library(shinybusy)

## Building the ui.R -----------------------------------------------------------

## 1. Header ----------------------------------------------

header <- dashboardHeader(
  tags$li(class = "dropdown",
          tags$style(".main-header {max-height: 20px;font-size:20px;font-weight:bold;line-height:20px;"),
          tags$style(".navbar {min-height:1px !important;font-weight:bold;")), title ="Optimum Router",
  tags$li(a(img(src = 'nameLogo.png'),href='https://www.linkedin.com/in/ashwini-jha-009646125/',
            style = "padding-top:4px; padding-bottom:1px;"),class = "dropdown"),titleWidth = 200)


## 3. Body --------------------------------
bodyD <- dashboardBody(
  
  ## 3.0 Setting skin color, icon sizes, etc. ------------
  
  ## modify the dashboard's skin color
  tags$style(HTML('
                       /* logo */
                       .skin-blue .main-header .logo {
                       background-color: #006272;
                       }
                       /* logo when hovered */
                       .skin-blue .main-header .logo:hover {
                       background-color: #006272;
                       }
                       /* navbar (rest of the header) */
                       .skin-blue .main-header .navbar {
                       background-color: #006272;
                       }
                       label {
                       display: inline-block; max-width: 100%; margin-top: 15px; font-weight: 700; color: white;}
                       pre.shiny-text-output {word-wrap: normal; background-color: black; color: white; border: none;}
                  ')
  ),
  
  ## modify icon size in the sub side bar menu
  tags$style(HTML('
                       /* change size of icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview-menu>li>a>.fa {
                      font-size: 15px;
                      }
                      .sidebar .sidebar-menu .treeview-menu>li>a>.glyphicon {
                      font-size: 13px;
                      }
                      /* Hide icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview>a>.fa-angle-left {
                      display: none;
                      }
                      '
  )) ,
    
  ## making background black
  setBackgroundColor(
    color = "black",
    gradient = "radial",
    shinydashboard = T
  ),
  
  
  ## 3.1 Dashboard body --------------
  fluidRow(column(align = "center",
                  width = 6,
                  offest = 3,
                  h2("Mark positions on the grid",style = "background-color:#000000; color:#FFFFFF; text-align: center;"))),
  
  fluidRow(column(
    width = 6,
    offset = 3,
    align = "center",
    plotOutput("city", click = "ipPosition", hover = "ipHover",),
    verbatimTextOutput(outputId = "info")
    )
    ),
  
  fluidRow(
    column(
      width = 4,
      offset = 4,
      align = "center",
      actionButton(inputId = "execGA", "Find Shortest Route", icon = icon("arrow-alt-circle-right"),
                   width = "50%",
                   style="color: #fff; background-color: #006272; border-color: #006272;margin-top: 23px"),
      actionButton(inputId = "clearCity", "Clear Graph", icon = icon("arrow-alt-circle-right"),
                   width = "50%",
                   style="color: #fff; background-color: #006272; border-color: #006272;margin-top: 23px")
    ))

)# dashboardBody closes here

## put UI together --------------------
ui <-  dashboardPage(header, dashboardSidebar(disable = T), bodyD)


