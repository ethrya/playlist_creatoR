

#' Replace the songs in a playlist with new songs.
#' 
#' Note: This deletes (permanently?) the original songs in the playlist.
#'
#' @param playlist_id (chr) Playlist URI to replace
#' @param track_ids (chr) vector of track URIs to add 
#'
#' @return NULL
#'
replace_playlist_with_tracks <- function(playlist_id, track_ids) {
  current_tracks <- get_playlist_tracks(playlist_id)
  
  remove_tracks_from_playlist(playlist_id, current_tracks$track.uri)
  
  add_tracks_to_playlist(playlist_id, track_ids)
  return(NULL)
}


#' Get Spotify's top songs for the current user and update relevant playlist
#'
#' @param type length of time the soptify should use to get top songs ¿(short,
#'   medium, long)
#' @param playlist_ids Named vector of playlist uris to be updated. Updated
#'   playlist is selected from this vector according to the "type" value
#' @return
#' @export
#'
#' @examples
update_top_song_playlist <- function(type, playlist_ids){
  
  top <- get_my_top_artists_or_tracks(type = "tracks",
                                      limit = 50,
                                      time_range = paste0(type, "_term"))
  
  replace_playlist_with_tracks(playlist_ids[paste0("top songs - ", type)],
                               str_extract(top$uri, "[0-9A-z]+$"))
}