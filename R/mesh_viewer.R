#' @title interactive meshcode check
#' @description Shiny gadgets for jpmesh.
#' @param ... other parameters
#' @importFrom shiny dialogViewer runGadget selectInput textInput
#' @importFrom miniUI gadgetTitleBar miniContentPanel miniTabstripPanel
#' miniTabPanel miniPage
#' @importFrom leaflet addTiles addPolygons leaflet leafletOutput renderLeaflet
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
                           shiny::textInput("lng", "Longitude: ", value = 141.3438), # nolint
                           shiny::textInput("lat", "Latitude: ", value = 43.0625), # nolint
                           shiny::selectInput("mesh_size",
                                              label = "Select Mesh Size",
                                              choices = units::drop_units(mesh_units), # nolint
                                              selected = 1),
                           miniUI::miniContentPanel(padding = 0,
                                                    leaflet::leafletOutput("my_map", height = "100%") # nolint
                           ))))
  # Server ------------------------------------------------------------------
  server <- function(input, output, session) {
    output$my_map <- leaflet::renderLeaflet({
      d <- coords_to_mesh(as.numeric(input$lng),
                          as.numeric(input$lat),
                          mesh_size = as.numeric(input$mesh_size)) %>%
        export_meshes()
      leaflet::leaflet() %>%
        leaflet::addTiles() %>%
        leaflet::addPolygons(data = d)
    })
  }
  shiny::runGadget(ui,
                   server,
                   viewer = shiny::dialogViewer("mesh_viewer",
                                                width = 650,
                                                height = 500))
  # nocov end
}
