#' @importFrom assertthat assert_that is.string
validate_table_name <- function(table_name) {

    # table_name is either null or a single element (not a vector of strings)
    assert_that(is.string(table_name) | is.null(table_name))
    if (is.null(table_name)) return(TRUE)

    # all table names have this form, might as well check for them
    check <- grepl("^[A-Za-z_]+$", table_name)
    if (check) return(TRUE)

    # in case of error
    stop("bad table name")
}

#' @importFrom assertthat assert_that is.string
validate_search_term <- function(search_term) {
    # this can be any valid regular expression accepted by Oracle's regex
    # implementation, but i don't know how to check for that
    assert_that(is.string(search_term) | is.null(search_term))
}
