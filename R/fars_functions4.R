
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
#' @importFrom magrittr  %>% 
#' @importFrom dplyr bind_rows group_by summarize n
#' @importFrom tidyr spread
#' @importFrom rlang .data

#' 
#' @examples 
#' \dontrun{fars_summarize_years(c(2013,2014))}
#' 
#' @return Returns a tibble, which is a summary table of the count of accidents (e.g. fatal injuries 
#'  suffered in motor vehicle traffic crashes) per month for the years provided.
#' @export


fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>% 
    dplyr::group_by(year, MONTH) %>% 
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}