library(spotifyr)
library(tidyverse)

purrr::walk(list.files("../R/", full.names = TRUE), source)

user_id <- "hrkp"

playlist_names <- paste0("top songs - ", c("short", "medium", "long"))

playlists_uris <- get_user_playlists(user_id) %>%  
  filter(name %in% playlist_names) %>% 
  transmute(name,
            uri = str_extract(uri, "\\w+$")) %>% 
  deframe()


# Check if any of the top playlists don't exist and create them if they don't
missing_playlists <- playlist_names[!playlist_names %in% names(playlists_uris)]

if (missing_playlists) {
  purrr::walk(missing_playlists, ~create_playlist(user_id, .x))
  
  # Update URIs
  playlists_uris <- get_user_playlists(user_id) %>%  
    filter(name %in% playlist_names) %>% 
    transmute(name,
              uri = str_extract(uri, "\\w+$")) %>% 
    deframe()
}

purrr::walk(c("short", "medium", "long"),
            update_top_song_playlist,
            playlists_uris)


