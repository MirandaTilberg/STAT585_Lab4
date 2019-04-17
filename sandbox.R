library(magrittr)
df <- jsonlite::read_json("https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story") %>% purrr::map_df(~ dplyr::as_tibble(as.list(unlist(.x, use.names = T))))
