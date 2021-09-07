#' Obtaining monthly information of accidents
#' 
#' This function takes a vector of years as an argument and provides a list, each
#' element of the list is a data frame (corresponding to one element in the vector) 
#' with two columns, the \code{year} and \code{MONTH} that correspond to each accident
#' 
#' @param years This is a numeric vector of the years for which the user is interested
#'  in deriving information from
#' 
#' @importFrom magrittr %>% 
#' @importFrom dplyr mutate select
#' 
#' @examples 
#' \dontrun{fars_read_years(c(2013,2014))}
#' 
#' @note This function intends to return a list of tipple (with two columns, 
#'  the \code{year} and \code{MONTH}) for the provided years. The function returns 
#'  a list of \code{NULL} values with a warning message.

#' 
#' @return This function return a list of tibbles (with two columns, the \code{year}
#'  and \code{MONTH}) for each of the provided years
#'
#' @export

fars_read_years <- function(years){
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(.data$MONTH, .data$year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}