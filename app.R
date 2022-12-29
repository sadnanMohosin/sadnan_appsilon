library(shiny)
library(shinydashboard)
library(shinyjs)
library(plotly)

library(leaflet)
library(leaflet.extras)
library(leaflet.providers)

library(readxl)
library(dplyr) 
library(tidyverse) 
library(DT)

#source('./www/national_ui_module_lm23.R')
source('./www/country_ui_module.R')

ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = "Biodiversity Project"),
                    
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Map View", tabName="Map", icon=icon("map"))
                        #menuItem("Data", tabName = "plan", icon = icon("book-open"))
                      )
                    ),
                    
                    dashboardBody(
                      fluidRow(
                        tags$head(
                          tags$link(rel = "stylesheet", type = "text/css", href = "style1_1.css"),
                          tags$link(rel = "stylesheet", type = "text/css", href = "style2_4.css")
                        ),
                        
                        tabItems(
                          tabItem(tabName="Map", 
                                  div(
                                    countryUI("nat_1"),
                                    style="width: 100%; height: 93% !important; overflow-y: scroll; padding-top: 5vh; padding-bottom: 1vh !important; background-color: white; display: flex; flex-direction: column;" 
                                  )
                          ),
                          
                          
                          tabItem(tabName="plan",
                                  div(
                                    div(
                                      dataTableOutput("table1_1"),
                                    ),
                                    style="width: 100%; padding: 0px 20px; padding-top: 0px; padding-bottom: 15px; margin-top: 20px; height: 93%; overflow: scroll;"
                                  )
                          )
                      )
              )
      )
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  #National View
  mydata <- read.csv("./out2.csv", header = TRUE, sep = ",") 
  #Converting Data into Table + Column Year and Months
  # liste_date <- mydata["eventDate"]
  # liste_y <- liste_date[[1]]
  # liste_y <- format(as.Date(liste_y), "%Y")
  # 
  # liste_m <- liste_date[[1]]
  # liste_m <- format(as.Date(liste_m), "%m")
  # 
  # #DF
  # mydata <- data.frame(mydata, liste_y, liste_m)

  countryServer("nat_1", mydata)
  
  # output$table1_1 <- DT::renderDataTable({
  #   mydata
  # })
}

shinyApp(ui = ui, server = server)
