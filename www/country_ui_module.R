source('./www/ui_map.R')

countryUI <- function(id){
  ns <- NS(id)
  
  tagList(
    
    div(
      div(
        selectizeInput(ns(unique('countries_1')), NULL, choices=NULL, options = list(maxOptions = 300, placeholder = 'Countries')),
        class="justify_c_"
      ),
      div(
        selectizeInput(ns(unique('type_1')), label=NULL, choices=NULL, options = list(placeholder = 'Select Type')),
        class="justify_c_"
      ),
      div(
        selectizeInput(ns(unique('vN_1')), label=NULL, choices=NULL, options = list(placeholder = 'Select a Vernacular Name')),
        class="justify_c_"
      ),
      class="justify_c_1"
    ),
    
    div(
      div(
        selectizeInput(ns(unique('sN_1')), NULL, choices = NULL, options = list(placeholder = 'Select a Scientific Name')),
        class="justify_c_"
      ),
      div(
        selectizeInput(ns('dateEvent_year_1'), label=NULL, choices=NULL, options = list(placeholder = 'Select a Year')),
        class="justify_c_"
      ),
      div(
        selectizeInput(ns('dateEvent_month_1'), label=NULL, choices=NULL, options = list(placeholder = 'Select a Month')),
        class="justify_c_"
      ),
      class="justify_c_1"
    ),
    
    div(
      div(
        div(p("Observing Occurrences of Species")),
        mapUI(ns("map_2")),
        class="mapbox1"
      ),
      # div(
      #   div(p("Timeline")),
      #   timelineUI(ns("timeline_2")),
      #   class="mapbox2"
      # ),
      
      class="mapbox"
    ),
    
  )
}


countryServer <- function(id, countries_1){
  moduleServer(
    id,
    function(input, output, session){
      print("Ctry1")
  
      liste_countries <- countries_1["country"]
      
      updateSelectizeInput(session, unique('countries_1'), choices = c(liste_countries), selected = "Poland", server=FALSE)
      
      choice_countries_1 <- reactive({
        input$countries_1
      })
      
      
      #Observe events on selected countries data 
      #By default it's Poland
      observeEvent(input$countries_1, {
        if(input$countries_1 == ""){
          
        }
        else{
          
          print("in country")
          print(choice_countries_1())
          #Load Data
          #folder <- "./resource/"
          mydata_1 <- read.csv(paste(input$countries_1,".csv", sep=""), header = TRUE, sep = ",") 
          
          liste_date <- mydata_1["eventDate"]
          liste_y <- liste_date[[1]]
          liste_y <- format(as.Date(liste_y), "%Y")
          
          liste_m <- liste_date[[1]]
          liste_m <- format(as.Date(liste_m), "%m")
          
          #Converting Data into Table + Column Months and years
          mydata_1 <- data.frame(mydata_1, liste_y, liste_m)
          
          
          #Type selectize input
          liste_type_1 <- unique(mydata_1["taxonRank"])
          
          
          updateSelectizeInput(session, unique('type_1'), choices = c(liste_type_1),selected = character(0), server=FALSE)
          
          
          
          #Reactive Functions
          choice_countries_1 <- reactive({
            input$countries_1
          })
          choice_type_1 <- reactive({
            input$type_1
          })
          
          choice_vN_1 <- reactive({
            input$vN_1
          })
          
          choice_sN_1 <- reactive({
            input$sN_1
          })
          
          choice_date_y_1 <- reactive({
            input$dateEvent_year_1
          })
          
          choice_date_m_1 <- reactive({
            input$dateEvent_month_1
          })
          
          
          #Type observe Event
          observeEvent(input$type_1, {
            
            mydata2_1 <- mydata_1%>%filter(taxonRank == choice_type_1())
            
            liste_vN_1 <- unique(mydata2_1["vernacularName"])
            liste_sN_1 <- unique(mydata2_1["scientificName"])
            
            updateSelectizeInput(session, unique('vN_1'), choices = c(liste_vN_1), selected = character(0), server=FALSE)
            
            updateSelectizeInput(session, unique('sN_1'), choices = c(liste_sN_1), selected = character(0), server=FALSE)
            
          })
          
          #reactives to help make queries with respect to selectize inputs
          pos_1 <- reactiveValues(i = 0)
          choice_fN_1 <- reactiveValues(i = "LM")
          
          #controller 
          ctrl <- reactiveValues(a=0, b=0, pa=0, pb=0)
          
          #vN observe event
          observeEvent(input$vN_1, {
            mydata2 <- mydata_1 %>% filter(taxonRank == choice_type_1())
            liste_sN <- unique(mydata2["scientificName"])
            updateSelectizeInput(session, unique('sN'), choices = c(liste_sN), selected = character(0), server=FALSE)
            
            ctrl$a <- ctrl$a + 1
            #Date Fields
            mydata2 <- mydata_1%>%filter(taxonRank == choice_type_1() & vernacularName == choice_vN_1())
            
            liste_date <- unique(mydata2["eventDate"])
            liste_y <- liste_date[[1]]
            liste_y <- format(as.Date(liste_y), "%Y")
            
            liste_m <- liste_date[[1]]
            liste_m <- format(as.Date(liste_m), "%m")
            
            
            updateSelectizeInput(session, 'dateEvent_year_1', choices = c(liste_y[order(liste_y)]), selected=character(0), server=FALSE)
            
            updateSelectizeInput(session, 'dateEvent_month_1', choices = c(liste_m[order(liste_m)]), selected=character(0), server=FALSE)
            
            
            if(input$vN_1 != "" & input$dateEvent_year_1 == "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 1
              choice_fN_1$i <- input$vN_1
            }
            if(input$vN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 3
              choice_fN_1$i <- input$vN_1
            }
            if(input$vN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 != ""){
              pos_1$i <- 4
              choice_fN_1$i <- input$vN_1
            }
          })
          
          #sN observe event
          observeEvent(input$sN_1, {
            #Date Fields
            print(choice_sN_1())
            #Date Fields
            mydata2 <- mydata_1 %>% filter(taxonRank == choice_type_1())
            
            #Names Fields
            liste_vN <- unique(mydata2["vernacularName"])
            
            updateSelectizeInput(session, unique('vN'), choices = c(liste_vN), selected = character(0), server=FALSE)
            
            ctrl$b <- ctrl$b + 1
            
            mydata2 <- mydata_1%>%filter(taxonRank == choice_type_1() & scientificName == choice_sN_1())
            
            liste_date <- unique(mydata2["eventDate"])
            liste_y <- liste_date[[1]]
            liste_y <- format(as.Date(liste_y), "%Y")
            
            liste_m <- liste_date[[1]]
            liste_m <- format(as.Date(liste_m), "%m")
            
            
            updateSelectizeInput(session, 'dateEvent_year_1', choices = c(liste_y[order(liste_y)]), selected=character(0), server=FALSE)
            
            updateSelectizeInput(session, 'dateEvent_month_1', choices = c(liste_m[order(liste_m)]), selected=character(0), server=FALSE)
            
            if(input$sN_1 != "" & input$dateEvent_year_1 == "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 2
              choice_fN_1$i <- input$sN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 5
              choice_fN_1$i <- input$sN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 != ""){
              pos_1$i <- 6
              choice_fN_1$i <- input$sN_1
            }
          })
          
          #data_year observe event
          observeEvent(input$dateEvent_year_1, {
            if(input$vN_1 != "" & input$dateEvent_year_1 == "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 1
              choice_fN_1$i <- input$vN_1
            }
            if(input$vN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 3
              choice_fN_1$i <- input$vN_1
            }
            if(input$vN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 != ""){
              pos_1$i <- 4
              choice_fN_1$i <- input$vN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 == "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 2
              choice_fN_1$i <- input$sN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 5
              choice_fN_1$i <- input$sN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 != ""){
              pos_1$i <- 6
              choice_fN_1$i <- input$sN_1
            }
          })
          
          #date month observe event
          observeEvent(input$dateEvent_month_1, {
            if(input$vN_1 != "" & input$dateEvent_year_1 == "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 1
              choice_fN_1$i <- input$vN_1
            }
            if(input$vN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 3
              choice_fN_1$i <- input$vN_1
            }
            if(input$vN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 != ""){
              pos_1$i <- 4
              choice_fN_1$i <- input$vN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 == "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 2
              choice_fN_1$i <- input$sN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 == ""){
              pos_1$i <- 5
              choice_fN_1$i <- input$sN_1
            }
            if(input$sN_1 != "" & input$dateEvent_year_1 != "" & input$dateEvent_month_1 != ""){
              pos_1$i <- 6
              choice_fN_1$i <- input$sN_1
            }
          })
          
          #query processing reactive function
          result1_1 <- reactive({
            if(pos_1$i == 1){
              res <- mydata_1%>%filter(vernacularName == choice_fN_1$i)%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 2){
              res <- mydata_1%>%filter(scientificName == choice_fN_1$i)%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            #With date
            else if(pos_1$i == 3){
              res <- mydata_1%>%filter(vernacularName == choice_fN_1$i & liste_y == choice_date_y_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 4){
              res <- mydata_1%>%filter(vernacularName == choice_fN_1$i & liste_y == choice_date_y_1() & liste_m == choice_date_m_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 5){
              res <- mydata_1%>%filter(scientificName == choice_fN_1$i & liste_y == choice_date_y_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 6){
              res <- mydata_1%>%filter(scientificName == choice_fN_1$i & liste_y == choice_date_y_1() & liste_m == choice_date_m_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 7){
              res <- mydata_1%>%filter(vernacularName == choice_fN_1$i & liste_countries == choice_countries_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 8){
              res <- mydata_1%>%filter(vernacularName == choice_fN_1$i & liste_y == choice_date_y_1() & liste_countries==choice_countries_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            else if(pos_1$i == 9){
              res <- mydata_1%>%filter(vernacularName == choice_fN_1$i & liste_y == choice_date_y_1() & liste_m == choice_date_m_1() & liste_countries==choice_countries_1())%>%select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
            }
            
            res 
          }) 

          
          #Timeline
          #timelineServer("timeline_2", reactive(pos_1$i), reactive(result1_1()))
          
          #Map
          mapServer("map_2", reactive(pos_1$i), reactive(result1_1()), mydata_1, reactive(choice_type_1()),2)
        }
      })
    }
  )
}