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

