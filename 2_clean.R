## Clean data

##=================##
## New South Wales ##
##=================##

# # Summarise data by LGA and remove NAs
# nsw_data <- copy(nsw_data_raw)
# nsw_data[, case := 1]
# nsw_data <- nsw_data[, .(cases = sum(case)), by = lga_code19]
# nsw_data <- nsw_data[complete.cases(nsw_data)]
# 
# # Filter LGA shapefile to NSW only
# nsw_lga_map_data <- lga_shapes
# nsw_lga_map_data <-
#   nsw_lga_map_data %>% 
#   filter(STE_CODE16 == 1)
# 
# # Match with geographic boundaries
# nsw_lga_map_data <- 
#   nsw_lga_map_data %>% 
#   left_join(nsw_data, by = c("LGA_CODE19" = "lga_code19"))

# NSW data are already in a sf object
# Tidy columns and column types

nsw_map_data <- copy(nsw_data_raw)

nsw_map_data <-
  nsw_map_data %>% 
  select(-c("LastUpdated", "Shape__Area", "Shape__Length", "OBJECTID", "Cases_Str")) %>% 
  mutate(Cases = as.numeric(Cases)) %>% 
  mutate(LGA_CODE19 = as.numeric(LGA_CODE19)) %>% 
  st_transform("+proj=longlat +datum=WGS84 +no_defs")


##==========##
## Victoria ##
##==========##

# Victorian data are already in a sf object
# Tidy columns and column types

vic_map_data <- copy(vic_data_raw)

vic_map_data <-
  vic_map_data %>% 
  select(-c("LastUpdated", "Shape__Area", "Shape__Length", "OBJECTID", "Cases_Str")) %>% 
  mutate(Cases = as.numeric(Cases)) %>% 
  mutate(LGA_CODE19 = as.numeric(LGA_CODE19)) %>% 
  st_transform("+proj=longlat +datum=WGS84 +no_defs")

##============##
## Queensland ##
##============##

qld_data <- copy(qld_data_raw)

# Tidy column names
setDT(qld_data) %>% setnames(c("LGA_NAME19", "overseas_acquired", "local_known", "local_unknown", "interstate", "investigating", "total"))

# Change LGA names to title case
qld_data[, LGA_NAME19 := toTitleCase(tolower(LGA_NAME19))]

# Change LGA types to correspond with ABS types
qld_data[, LGA_NAME19 := str_replace(LGA_NAME19, "\\(c\\)", "\\(C\\)")]
qld_data[, LGA_NAME19 := str_replace(LGA_NAME19, "\\(s\\)", "\\(S\\)")]
qld_data[, LGA_NAME19 := str_replace(LGA_NAME19, "\\(Rc\\)", "\\(R\\)")]

# Convert total column to numeric
qld_data[, total := as.numeric(total)]

# Remove total row
qld_data <- qld_data[LGA_NAME19 != "Total", ]

# Keep total column only
cols <- c("LGA_NAME19", "total")
qld_data <- qld_data[, setdiff(names(qld_data), cols) := NULL]

# Prepare shapefile
qld_lga_map_data <- lga_shapes
qld_lga_map_data <-
  qld_lga_map_data %>% 
  filter(STE_NAME16 == "Queensland")

# Match with shapefile
qld_lga_map_data <- 
  qld_lga_map_data %>% 
  left_join(qld_data, by = "LGA_NAME19") %>% 
  st_transform("+proj=longlat +datum=WGS84 +no_defs")

# Remove empty geometries
qld_lga_map_data <- qld_lga_map_data[!st_is_empty(qld_lga_map_data),,drop=FALSE]

##===========##
## Australia ##
##===========##

aus_data <- copy(aus_data_raw)

# Keep latest totals only
aus_data <- aus_data[["sheets.latest totals"]]

# Drop QLD, NSW, VIC
aus_data <- setDT(aus_data)[!(`State or territory` %in% c("QLD", "NSW", "VIC")), ]

# Drop all columns except total cases and state name
cols <- c("Long name", "Confirmed cases (cumulative)")
aus_data[, setdiff(names(aus_data), cols) := NULL]
setnames(aus_data, c("state", "cases"))

aus_data[, cases := as.numeric(cases)]

# Merge with state geometries
state_shapes_data <- copy(state_shapes)

state_shapes_data <-
  state_shapes_data %>% 
  left_join(aus_data, by = c("STE_NAME16" = "state")) %>% 
  st_transform("+proj=longlat +datum=WGS84 +no_defs") %>% 
  drop_na()