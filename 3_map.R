## Map data

# Colour palettes
pal_qld <- colorNumeric(palette = "Reds", domain = qld_lga_map_data$total, na.color = "#d4d4d4")
pal_nsw <- colorNumeric(palette = "Blues", domain = nsw_map_data$Cases, na.color = "#d4d4d4")
pal_vic <- colorNumeric(palette = "Purples", domain = vic_map_data$Cases, na.color = "#d4d4d4")
pal_nat <- colorNumeric(palette = "Oranges", domain = state_shapes_data$cases, na.color = "#d4d4d4")
# pal_qld <- colorBin(palette = "Reds", domain = qld_lga_map_data$total, na.color = "#d4d4d4", 6, pretty = T)
# pal_nsw <- colorBin(palette = "Blues", domain = nsw_map_data$Cases, na.color = "#d4d4d4", 6, pretty = T)
# pal_vic <- colorBin(palette = "Purples", domain = vic_map_data$Cases, na.color = "#d4d4d4", 6, pretty = T)
# pal_nat <- colorBin(palette = "Oranges", domain = state_shapes_data$cases, na.color = "#d4d4d4", 6, pretty = T)

# Hover labels
labels_qld <- sprintf(
  "<strong>%s</strong><br/>%g cases",
  qld_lga_map_data$LGA_NAME19, qld_lga_map_data$total
) %>% lapply(htmltools::HTML)

labels_nsw <- sprintf(
  "<strong>%s</strong><br/>%g cases",
  nsw_map_data$LGA_NAME19, nsw_map_data$Cases
) %>% lapply(htmltools::HTML)

labels_vic <- sprintf(
  "<strong>%s</strong><br/>%g cases",
  vic_map_data$LGA_NAME19, vic_map_data$Cases
) %>% lapply(htmltools::HTML)

labels_nat <- sprintf(
  "<strong>%s</strong><br/>%g cases",
  state_shapes_data$STE_NAME16, state_shapes_data$cases
) %>% lapply(htmltools::HTML)


# Create map
leaflet_map <-
  leaflet(elementId = "leaflet-map", options = leafletOptions(preferCanvas = T)) %>%
  addProviderTiles("Stamen.TonerLite", options = providerTileOptions(updateWhenIdle = TRUE)) %>%
  # Add QLD
  addPolygons(
    data = qld_lga_map_data,
    # Sets fill colour and properties
    fillColor = ~ pal_qld(total),
    fillOpacity = 0.7,
    # Sets outline properties
    weight = 2,
    opacity = 1,
    color = "#cccccc",
    highlight = highlightOptions(
      weight = 5,
      color = "#909090",
      fillOpacity = 0.7,
      bringToFront = T
    ),
    # Labelling
    label = labels_qld,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    )
  ) %>%
  # Add NSW
  addPolygons(
    data = nsw_map_data,
    # Fill colour and properties
    fillColor = ~ pal_nsw(Cases),
    fillOpacity = 0.7,
    # Sets outline properties
    weight = 2,
    opacity = 1,
    color = "#cccccc",
    highlight = highlightOptions(
      weight = 5,
      color = "#909090",
      fillOpacity = 0.7,
      bringToFront = T
    ),
    # Labelling
    label = labels_nsw,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    )
  ) %>%
  # Add VIC
  addPolygons(
    data = vic_map_data,
    # Fill colour and properties
    fillColor = ~ pal_vic(Cases),
    fillOpacity = 0.7,
    # Sets outline properties
    weight = 2,
    opacity = 1,
    color = "#cccccc",
    highlight = highlightOptions(
      weight = 5,
      color = "#909090",
      fillOpacity = 0.7,
      bringToFront = T
    ),
    # Labelling
    label = labels_vic,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    )
  ) %>% 
  # Add other states
  addPolygons(
    data = state_shapes_data,
    # Fill colour and properties
    fillColor = ~ pal_nat(cases),
    fillOpacity = 0.7,
    # Sets outline properties
    weight = 2,
    opacity = 1,
    color = "#cccccc",
    highlight = highlightOptions(
      weight = 5,
      color = "#909090",
      fillOpacity = 0.7,
      bringToFront = T
    ),
    # Labelling
    label = labels_nat,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto"
    )
  )