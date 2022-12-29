mapUI <- function(id){
  ns <- NS(id)
  
  tagList(
    div(
      leafletOutput(ns("mymap")),
    )
  )
}

mapServer <- function(id, pos, result1, mydata, choice_type, dist){
  moduleServer(  
    id,
    function(input, output, session){
      #map Render
      bins <- c(0, 10, 20, 50, 100, 200, 500, Inf)
      output$mymap <- renderLeaflet({
        if(pos() == 0){
          result <- mydata %>% select(longitudeDecimal, latitudeDecimal, individualCount, locality, eventDate, eventTime, scientificName, vernacularName)
          
          pal <- colorFactor(palette = c('orange', 'red'), domain = result$indidualCount)
          leaflet(result) %>%
            leaflet::addProviderTiles(providers$Esri.WorldGrayCanvas, #CartoDB.Positron
                                    options = providerTileOptions(noWrap = TRUE)
            ) %>%
            leaflet::addCircleMarkers(
              lng = ~longitudeDecimal,
              lat = ~latitudeDecimal,
              radius = ~8,
              color = ~pal(individualCount),
              stroke = FALSE, fillOpacity = 0.5,
              popup = ~paste(paste("Locality: ", locality), paste("Individual Count: ", individualCount), paste("Event Date: ", eventDate), sep = "<br>"),
              label = ~sprintf("Locality: %s <br>Individual Count: %s <br>Event Date: %s ", locality, individualCount, eventDate)%>%lapply(htmltools::HTML)
            ) %>% 
            leaflet::addLegend(pal = colorBin(c('orange', 'red'), domain = ~individualCount, bins = bins), values = ~individualCount, opacity = 0.7, title = NULL, position = "bottomright")
        }
        
        else{
          pal <- colorFactor(palette = c('orange', 'red'), domain = result1()$indidualCount)
          leaflet(result1()) %>%
            leaflet::addProviderTiles(providers$Esri.WorldGrayCanvas, #CartoDB.Positron
                                      options = providerTileOptions(noWrap = TRUE)
            ) %>%
            leaflet::addCircleMarkers(
              lng = ~longitudeDecimal,
              lat = ~latitudeDecimal,
              radius = ~8,
              color = ~pal(individualCount),
              stroke = FALSE, fillOpacity = 0.5,
              popup = ~paste(paste("Locality: ", locality), paste("Individual Count: ", individualCount), paste("Event Date: ", eventDate), sep = "<br>"),
              #label = ~sprintf("Locality: %s <br>Individual Count: %s <br>Event Date: %s ", locality, individualCount, eventDate)%>%lapply(htmltools::HTML)
            ) %>% 
            leaflet::addLegend(pal = colorBin(c('orange', 'red'), domain = ~individualCount, bins = bins), values = ~individualCount, opacity = 0.7, title = NULL, position = "bottomright")
          # if(dist ==1){
          #   
          # }
          # else{
          #   pal <- colorFactor(palette = c('orange', 'red'), domain = result1()$indidualCount)
          #   leaflet(result1()) %>%
          #     leaflet::addProviderTiles(providers$Esri.WorldGrayCanvas, #CartoDB.Positron
          #                      options = providerTileOptions(noWrap = TRUE)
          #     ) %>%
          #     leaflet::addCircleMarkers(
          #       lng = ~longitudeDecimal,
          #       lat = ~latitudeDecimal,
          #       radius = ~8,
          #       color = ~pal(individualCount),
          #       stroke = FALSE, fillOpacity = 0.5,
          #       popup = ~paste(paste("Locality: ", locality), paste("Individual Count: ", individualCount), paste("Event Date: ", eventDate), sep = "<br>"),
          #       label = ~sprintf("Locality: %s <br>Individual Count: %s <br>Event Date: %s ", locality, individualCount, eventDate)%>%lapply(htmltools::HTML)
          #     ) %>% 
          #     leaflet::addLegend(pal = colorBin(c('orange', 'red'), domain = ~individualCount, bins = bins), values = ~individualCount, opacity = 0.7, title = NULL, position = "bottomright")
          # }
        }  
      })
    }
  )
}