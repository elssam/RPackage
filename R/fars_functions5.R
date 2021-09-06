#' Plot a map of accidents
#' 
#' This function plots a map of accidents' locations which occurred within a 
#' specified year in a given state.
#' 
#' @param state.num The state number (character) for which the user wishes to plot a map of accidents
#' @param year The year (numeric) for which the user wishes to plot a map of accidents
#' 
#' @importFrom dplyr  filter
#' @importFrom graphics points
#' @importFrom maps map
#' 
#' @examples 
#' fars_map_state('34',2013)
#' 
#' @return Returns a plot, which is a map of the specified state (i.e. \code{state.num}) showing the 
#'  geographic locations of accidents during the specified \code{year}



fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)
  print(unique(data$STATE))
  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}