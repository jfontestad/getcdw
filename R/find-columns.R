#' Search a database schema for column names
#'
#' @param search_term Pattern of the column(s) you are looking for, e.g. 'class_campaign' or 'household'
#' @param table_name Name (or partial name) of the table (optional)
#' @param schema In case you're searching through something other than the CDW, e.g. 'advance'
#' @param ... Passed on to \code{get_cdw}
#'
#' @export
find_columns <- function(search_term = NULL, table_name = NULL, schema = "CDW",
                         ...) {
    validate_search_term(table_name)
    validate_search_term(search_term)

    if (!is.null(table_name))
        table_part <- paste("and regexp_like(table_name, '",
                            table_name, "', 'i') ", sep = "")
    else table_part <- ""

    schema_part <- paste("where owner = '", schema, "'", sep = "")
    fields <- c("lower(table_name) as table_name",
                "lower(column_name) as column_name",
                "data_type", "data_length")
    select_part <- paste(fields, collapse = ", ")
    main_part <- paste("select ", select_part,
                       " from all_tab_columns ",
                       sep = "")

    if (!is.null(search_term))
        column_part <- paste("and regexp_like(column_name, '",
                             search_term, "', 'i') ", sep = "")
    else column_part <- ""

    query <- paste(main_part, schema_part, column_part, table_part, sep = "")
    get_cdw(query, ...)
}
