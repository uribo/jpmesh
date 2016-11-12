#' @title interactive meshcode check
#' 
#' @description Shiny gadgets for jpmesh.
#' @param ... other parameters
#' @import shiny
#' @import miniUI
#' @import leaflet
#' @importFrom dplyr mutate
#' @importFrom tibble rownames_to_column
#' @examples 
#' \dontrun{
#' mesh_viewer()
#' }
#' @export
mesh_viewer <-  function(...) {
  
  # UI ----------------------------------------------------------------------
  ui <- miniPage(
    gadgetTitleBar("Mesh Viewer"),
    miniTabstripPanel(
      miniTabPanel("Map", icon = icon("map-o"),
                   textInput("lat", "Latitude: ", value = 43.0625),
                   textInput("lon", "Longitude: ", value = 141.3438),
                   sliderInput("order", "mesh_scale_order", min = 1, max = 3, value = 3),
                   miniContentPanel(padding = 0,
                                    leafletOutput("my.map", height = "100%")
                   )
      )
      )
    )
  
  # Server ------------------------------------------------------------------
  server <- function(input, output, session) {
    
    output$my.map <- renderLeaflet({
      
      d <- latlong_to_meshcode(as.numeric(input$lat), as.numeric(input$lon), order = as.numeric(input$order)) %>% 
        meshcode_to_latlon() %>% 
        bundle_mesh_vars()
      
      leaflet() %>% addTiles() %>% addRectangles(data = d, 
                                                 lng1 = d$lng1, 
                                                 lat1 = d$lat1, 
                                                 lng2 = d$lng2, 
                                                 lat2 = d$lat2)
        
    })
  }
  
  runGadget(ui, server, viewer = dialogViewer("mesh_viewer", width = 650, height = 500))
}

