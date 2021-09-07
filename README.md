# Building an R Package: Assignment 4

<!-- badges: start -->
[![R-CMD-check](https://github.com/elssam/RPackage/workflows/R-CMD-check/badge.svg)](https://github.com/elssam/RPackage/actions)
<!-- badges: end -->

This package consists of a set of functions that explore a files containing counts of accidents information monthly, and yearly.
 
# Setup

```{r setup}
library(tidyr)
library(readr)
library(maps)
library(graphics)
library(magrittr)
library(dplyr)
```

# Load all 
Load all if you clone the package with `devtools::load_all()` or install the package from
devtools (see Readme file for more details.)
You will need to load knitr with `library(knitr)`.

# Reading files
The following This function takes a file name as an argument and checks if it exists before reading it as an R dataframe

```{r eval = FALSE}
fars_read("accident_2013.csv")
```

# Reading files
The following function takes a file name as an argument and checks if it exists before reading it as an R dataframe

```{r eval = FALSE}
fars_read("accident_2013.csv")
```

# Specify the file name
The following function takes as an argument the year for which the user wishes to acquire data and accordingly creates the associated file name

```{r eval = FALSE}
make_filename(2013)
```

# Obtaining monthly information of accidents
This function takes a vector of years as an argument and provides a list, each element of the list is a data frame (corresponding to one element in the vector) with two columns, the \code{year} and \code{MONTH} that correspond to each accident

```{r eval = FALSE}
fars_read_years(c(2013,2014))
```


# Summarizes number of accidents 
The following function takes a vector of specific years as an argument and returns a summary of the count (e.g. fatal injuries in motor vehicle traffic crashes) per month within the years provided

```{r eval = FALSE}
fars_summarize_years(c(2013,2014))
```


# Plot a map of accidents

This function plots a map of accidents' locations which occurred within a specified year in a given state.

```{r eval = FALSE}
fars_map_state('34',2013)
```
