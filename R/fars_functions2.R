#' Specify the file name
#' 
#' This function takes as an argument the year for which the user wishes to 
#' acquire data and accordingly creates the associated file name
#' 
#' @param year This is the year for which the user wishes to obtain data from
#' 
#' @examples 
#' \dontrun{make_filename(2013)}
#' \dontrun{make_filename(2014)}
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
