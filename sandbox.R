raw_df <- purrr::map_df(jsonlite::read_json("https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story"), ~ dplyr::as_tibble(as.list(unlist(.x, use.names = T))))
names(raw_df)


library(tidyverse)
library(magrittr)
library(lubridate)
df <- raw_df %>% mutate(date = ymd_hms(date),
                        longitude = as.numeric(store_location.coordinates1),
                        latitude = as.numeric(store_location.coordinates2)) %>%
  filter(!is.na(latitude)) %>%
  filter(!is.na(longitude))


zipmap <- leaflet::leaflet(data = df) %>% leaflet::addTiles() %>%
  leaflet::addCircleMarkers(~longitude, ~latitude, popup = ~name, label = ~name)
zipmap


# Playing around with sorting by type of booze
cats <- df$category_name %>% unique %>% tolower(); cats
booze <- c("vodka", "whisk", "schnapps", "rum", "brand")

sapply(booze, function(x) {grepl(x, cats)})





# NOT USING THIS.
#
# df <- raw_df %>%
#   mutate_at(vars(bottle_volume_ml, pack, starts_with("store_location.coordinates"),
#                  starts_with("sale"), starts_with("state")), as.numeric) %>%
#   mutate(date = date(ymd_hms(date)),
#          category_type = case_when(
#            str_detect(category_name, "WHISKIES") ~ "WHISKIES",
#            str_detect(category_name, "SCHNAPPS") ~ "SCHNAPPS",
#            str_detect(category_name, "CORDIALS") ~ "CORDIALS",
#            str_detect(category_name, "LIQUEURS") ~ "LIQUEURS",
#            str_detect(category_name, "VODKA") ~ "VODKA",
#            str_detect(category_name, "GINS") ~ "GINS",
#            str_detect(category_name, "RUM") ~ "RUM",
#            str_detect(category_name, "AMARETTO") ~ "AMARETTO",
#            str_detect(category_name, "TEQUILA") ~ "TEQUILA",
#            T ~ "Others"
#          )) %>%
#   select(item = im_desc, category_name, category_type, date,
#          longitude = store_location.coordinates1, latitude = store_location.coordinates2, everything()) %>%
#   select(-name, -city, -county, -zipcode, -address, everything()) %>%
#   select(-category, -county_number, -invoice_line_no, -itemno, -sale_gallons,
#          -starts_with("store"), -starts_with("vendor")) %>%
#   filter_at(vars(date, longitude, latitude), ~ !is.na(.)) %>%
#   arrange(date)



