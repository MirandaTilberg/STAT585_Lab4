raw_df <- purrr::map_df(jsonlite::read_json("https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story"), ~ dplyr::as_tibble(as.list(unlist(.x, use.names = T))))
names(raw_df)


library(tidyverse)
library(magrittr)
library(lubridate)
df <- raw_df %>% mutate(date = ymd_hms(date),
                        longitude = as.numeric(store_location.coordinates1),
                        latitude = as.numeric(store_location.coordinates2),)


zipmap <- leaflet::leaflet(data = df) %>% leaflet::addTiles() %>%
  leaflet::addCircleMarkers(~as.numeric(store_location.coordinates1), 
                            ~as.numeric(store_location.coordinates2), 
                            popup = ~name, label = ~name)
