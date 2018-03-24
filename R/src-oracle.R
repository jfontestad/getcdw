#' @importFrom dbplyr db_collect
#' @export
db_collect.OraConnection <- function(con, sql, n = -1, warn_incomplete = TRUE, ...) {
    # res <- ROracle::dbSendQuery(con, sql)
    # tryCatch({
    #     out <- ROracle::fetch(res, n = n)
    #     if (warn_incomplete) {
    #         dbplyr:::res_warn_incomplete(res, "n = Inf")
    #     }
    # }, finally = {
    #     ROracle::dbClearResult(res)
    # })
    # names(out) <- tolower(names(out))
    # out
    res <- dbplyr:::db_collect.DBIConnection(con = con,
                                             sql = sql,
                                             n = n,
                                             warn_incomplete = warn_incomplete,
                                             ...)
    names(res) <- tolower(names(res))
    res
}

#' @importFrom dplyr sql_escape_ident
#' @export
sql_escape_ident.OraConnection <- function(con, x) x

#' @importFrom dplyr db_query_fields
#' @export
db_query_fields.OraConnection <- function(con, sql, ...) {
    tolower(dbplyr:::db_query_fields.DBIConnection(con, sql, ...))
}
