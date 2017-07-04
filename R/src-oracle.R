#' @export
db_desc.OraConnection <- function(con) {
    info <- ROracle::dbGetInfo(con)
    paste0("oracle ", info$serverVersion, " [", info$username, "@",
           info$dbname, "]")
}


#' @importFrom dbplyr db_collect
#' @export
db_collect.OraConnection <- function(con, sql, n = -1, warn_incomplete = TRUE, ...) {
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

#' @importFrom dplyr sql_select
# @export
sql_select.OraConnection <- dbplyr:::sql_select.Oracle

#' @importFrom dplyr sql_translate_env
#' @export
sql_translate_env.OraConnection <- dbplyr:::sql_translate_env.Oracle

#' @importFrom dplyr db_query_fields
#' @export
db_query_fields.OraConnection <- function(con, sql, ...) {
    fields <- dbplyr::build_sql("SELECT * FROM (", sql, ") WHERE 0=1", con = con)

    qry <- ROracle::dbSendQuery(con, fields)
    on.exit(ROracle::dbClearResult(qry))

    tolower(ROracle::dbGetInfo(qry)$fields$name)
}

#' @importFrom dplyr sql_subquery
#' @export
sql_subquery.OraConnection <- dbplyr:::sql_subquery.Oracle

#' @importFrom dplyr db_analyze
#' @export
db_analyze.OraConnection <- dbplyr:::db_analyze.Oracle
