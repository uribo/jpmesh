#' @title interactive meshcode check
#' 
#' @description Shiny gadgets for jpmesh.
#' @param ... other parameters
#' @import shiny
#' @import miniUI
#' @import leaflet
#' @importFrom purrr pmap
#' @importFrom sf st_sf
#' @examples 
#' \dontrun{
#' mesh_viewer()
#' }
#' @export

mesh_viewer <- function(...) {
  
  # nocov start
  # UI ----------------------------------------------------------------------
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Mesh Viewer"),
    miniUI::miniTabstripPanel(
      miniUI::miniTabPanel("Map", icon = shiny::icon("map-o"),
                   shiny::textInput("lng", "Longitude: ", value = 141.3438),
                   shiny::textInput("lat", "Latitude: ", value = 43.0625),
                   shiny::selectInput("mesh_size", label = "Select Mesh Size",
                                      choices = c("80km", "10km", "1km", "500m", "250m", "125m"),
                                      selected = "1km"),
                   miniUI::miniContentPanel(padding = 0,
                                    leaflet::leafletOutput("my.map", height = "100%")
                   )
      )
      )
    )
  
  # Server ------------------------------------------------------------------
  server <- function(input, output, session) {
    
    output$my.map <- leaflet::renderLeaflet({
      
      d <- coords_to_mesh(as.numeric(input$lng), 
                          as.numeric(input$lat), 
                          mesh_size = input$mesh_size) %>% 
        export_meshes()
      
      leaflet::leaflet() %>% 
        leaflet::addTiles() %>% 
        leaflet::addPolygons(data = d)
        
    })
  }
  
  shiny::runGadget(ui, 
                   server, 
                   viewer = shiny::dialogViewer("mesh_viewer", width = 650, height = 500))
  # nocov end 
}
