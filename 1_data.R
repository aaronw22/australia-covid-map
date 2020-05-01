## Import raw data in its various forms

## NSW individual case data

# Download spreadsheet with data
# download.file(
#   url = "https://data.nsw.gov.au/data/dataset/aefcde60-3b0c-4bc0-9af1-6fe652944ec2/resource/21304414-1ff1-4243-a5d2-f52778048b29/download/covid-19-cases-by-notification-date-and-postcode-local-health-district-and-local-government-area.csv",
#   destfile = "./Data/nsw_case_data.csv"
# )

# Load data
# nsw_data_raw <- fread("./Data/nsw_case_data.csv")
nsw_data_raw <- geojson_sf("https://opendata.arcgis.com/datasets/05a9ef0b191b499283cc505e8f992ed2_0.geojson")

## Victorian data

# Download geoJSON with data
vic_data_raw <- geojson_sf("https://opendata.arcgis.com/datasets/172fec44be524ac29465587cef130363_0.geojson")

## Queensland data

# Download website with data
qld_html <- read_html("https://www.qld.gov.au/health/conditions/health-alerts/coronavirus-covid-19/current-status/statistics")

# Extract table with the data
qld_data_raw <-
  qld_html %>%
  html_node("#LGA") %>%
  html_table()

## Data for rest of Australia
aus_data_raw <- 
  jsonlite::fromJSON("https://interactive.guim.co.uk/docsdata/1q5gdePANXci8enuiS4oHUJxcxC13d6bjMRSicakychE.json") %>% 
  unlist(recursive = F)

## Load LGA shapefiles
lga_shapes <- st_read("./Data/abs_lga_2019_shp/LGA_2019_AUST.shp")
state_shapes <- st_read("./Data/abs_ste_2016_shp/STE_2016_AUST.shp")

# Convert sf columns to sensible types
lga_shapes <-
  lga_shapes %>% 
  mutate(LGA_CODE19 = as.numeric(as.character(LGA_CODE19))) %>% 
  mutate(STE_CODE16 = as.numeric(as.character(STE_CODE16))) %>% 
  mutate(LGA_NAME19 = as.character(LGA_NAME19)) %>% 
  mutate(STE_NAME16 = as.character(STE_NAME16))

state_shapes <- 
  state_shapes %>% 
  mutate(STE_CODE16 = as.numeric(as.character(STE_CODE16))) %>% 
  mutate(STE_NAME16 = as.character(STE_NAME16))
