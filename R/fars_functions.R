#' Reads a dataframe
#' 
#' This function takes a file name as an argument and checks if it 
#' exists before reading it as an R dataframe
#' 
#' @param filename A character. This is the name of the file which the user wishes to 
#'  read as an R dataframe
#' 
#' @note This function may result in a warning message because the \code{tbl_df()} 
#'  function in dplyr 1.0.0 was deprecated.
#' 
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#' 
#' @examples 
#' fars_read(my_data) #define my_data as the name of the file you wish to read as
#'  an R dataframe
#' fars_read("accident_2013.csv")
#' 
#' @return This function returns an R tibble for the provided file
#' 
#' @export


fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

########################################################################

#' Specify the file name
#' 
#' This function takes as an argument the year for which the user wishes to 
#' acquire data and accordingly creates the associated file name
#' 
#' @param year This is the year for which the user wishes to obtain data from
#' 
#' @examples 
#' make_filename(2013)
#' make_filename(2014)
#' 
#' @return It returns the file name (a character) for the year specified, that is, 
#'  \code{sprintf("accident_%d.csv.bz2", year)}, e.g. for \code{2013}, 
#'  it returns \code{accident_2013.csv.bz2}
#' 
#' @export



make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}
########################################################################

#' Obtaining monthly information of accidents
#' 
#' This function takes a vector of years as an argument and provides a list, each
#' element of the list is a data frame (corresponding to one element in the vector) 
#' with two columns, the \code{year} and \code{MONTH} that correspond to each accident
#' 
#' @param years This is a numeric vector of the years for which the user is interested
#'  in deriving information from
#' 
#' @importFrom dplyr %>% 
#' @importFrom dplyr mutate select
#' 
#' @examples 
#' fars_read_years(c(2013,2014))
#' 
#' @note This function intends to return a list of tipple (with two columns, 
#'  the \code{year} and \code{MONTH}) for the provided years. The function returns 
#'  a list of \code{NULL} values with a warning message.

#' 
#' @return This function return a list of tibbles (with two columns, the \code{year}
#'  and \code{MONTH}) for each of the provided years
#'
#' @export

fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>% 
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

########################################################################
#' Summarizes number of accidents 
#' 
#' This function takes a vector of specific years as an argument and returns a 
#' summary of the count (e.g. fatal injuries in motor vehicle traffic crashes) per 
#' month within the years provided
#' 
#' @inheritParams  fars_read_years
#' 
#' @note This function's code runs the \code{\link{fars_read_years}} function, 
#'  so any errors or warnings in \code{\link{fars_read_years}} will affect the 
#'  performance of this function
#' 
#' @importFrom dplyr  %>% 
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#' 
#' @examples 
#' fars_summarize_years(c(2013,2014))
#' 
#' @return Returns a tibble, which is a summary table of the count of accidents (e.g. fatal injuries 
#'  suffered in motor vehicle traffic crashes) per month for the years provided.


fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>% 
    dplyr::group_by(year, MONTH) %>% 
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}


########################################################################
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