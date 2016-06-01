#' Find codes in the tms table
#'
#' @description Use regular expression matching to look for terms in different
#' code tables. For instance, \code{find_codes("astronomy")} will return major,
#' minor, department, etc. codes.
#'
#' @param search_term A search term (can be an Oracle SQL regular expression)
#' @param table_name TMS table name (or regular expression)
#' @param ... Any parameters passed on to \code{get_cdw}
#'
#' @details Either \code{search_term} or \code{table_name} can be \code{NULL}
#' @export
find_codes <- function(search_term = NULL, table_name = NULL, ...) {
    validate_search_term(search_term)

    select_part <- "select tms_type_code as code, tms_type_desc as description,
    tms_table_name as table_name, tms_view_name as view_name
    from cdw.d_tms_type_mv"

    where_part <- "where tms_type_code is not null"

    if (!is.null(search_term))
        search_part <- paste("and regexp_like(tms_type_desc, '",
                             search_term, "', 'i')", sep = "")
    else search_part <- ""

    if (!is.null(table_name))
        table_part <- paste("and regexp_like(tms_table_name, '",
                            table_name, "', 'i')", sep = "")
    else table_part <- ""

    order_part <- "order by tms_table_name, tms_type_desc"

    query <- paste(select_part, where_part, search_part,
                   table_part, order_part, sep = "\n")

    get_cdw(query, ...)
}
