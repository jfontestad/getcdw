#' Search a database schema for tables
#'
#' @param search_term Pattern of the table(s) you are looking for, e.g. 'committee'
#' @param schema In case you're searching through something other than the CDW, e.g. 'advance'
#' @param ... Passed on to \code{get_cdw}
#'
#' @export
find_tables <- function(search_term = NULL, schema = "CDW", ...) {
    validate_search_term(search_term)
    query <- paste("select lower(table_name) as table_name from all_tables where owner = '",
                   schema, "'", sep = "")

    if (!is.null(search_term))
        search_part <- paste(" and regexp_like(table_name, '", search_term,
                             "', 'i')", sep = "")
    else search_part = ""

    query <- paste(query, search_part, sep = "")
    get_cdw(query, ...)
}
