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
#' \dontrun{fars_read(my_data) #define my_data as the name of the file you wish to read as
#'  an R dataframe}
#' \dontrun{fars_read("accident_2013.csv.bz2")}
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
  tibble::as_tibble(data)
}
