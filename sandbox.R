library(httr)
library(magrittr)
endpt <- "https://data.iowa.gov/resource/m3tr-qhgy.json?county=Story"
data <- jsonlite::read_json(endpt)
samp <- data[[1]]

new.distinct.names <- data %>% 
  purrr::map(.x, .f=~names(rbind.data.frame(rlist::list.flatten(.x),0)))

unlisted <- data %>% 
  purrr::map(.f = ~rbind.data.frame(unlist(.x, recursive=T, use.names=T)))

unlisted.info <- purrr::map2(unlisted, new.distinct.names,
                             .f= ~purrr::set_names(.x, .y))

data_df <- do.call(plyr::rbind.fill, unlisted.info)
