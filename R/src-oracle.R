src_oracle <- function(dsn = config("default_dsn"),
                       uid = NULL, pwd = NULL) {
    stop("dplyr compatibility has been temporarily disabled")
}

#' #' @export
#' src_oracle <- function(dsn = config("default_dsn"), uid = NULL, pwd = NULL) {
#'     if (is.null(uid) || is.null(pwd)) {
#'         credential <- credential(dsn)
#'         uid <- credential$UID
#'         pwd <- credential$PWD
#'     }
#'
#'     con <- connect(dsn, uid, pwd)
#'     info <- ROracle::dbGetInfo(con)
#'     dbplyr::src_sql("oracle", con = con, dsn = dsn, info = info)
#' }
#'
#'
#' #' @export
#' db_desc.src_oracle <- function(con) {
#'     info <- con$info
#'     paste0("oracle ", info$serverVersion, " [", info$username, "@",
#'            info$dbname, "]")
#' }
#'

#' #' @importFrom dplyr sql_escape_ident
#' #' @export
#' sql_escape_ident.OraConnection <- function(con, x) x
#'
#'
#' #' @importFrom dplyr tbl
#' #' @export
#' tbl.src_oracle <- function(src, from, ...) {
#'     dbplyr::tbl_sql("oracle", src = src, from = from, ...)
#' }
#'
#'
#' #' @importFrom dplyr sql_translate_env
#' #' @export
#' sql_translate_env.OraConnection <- function(x) {
#'     dbplyr::sql_variant(
#'         base_scalar,
#'         dbplyr::sql_translator(
#'             .parent = base_agg,
#'             n = function() dbplyr::sql("count(*)"),
#'             cor = dbplyr::sql_prefix("corr"),
#'             cov = dbplyr::sql_prefix("covar_samp"),
#'             sd =  dbplyr::sql_prefix("stddev_samp"),
#'             var = dbplyr::sql_prefix("var_samp")
#'         ),
#'         dbplyr::base_win
#'     )
#' }
#'
#' #' @importFrom dplyr db_query_fields
#' #' @export
#' db_query_fields.OraConnection <- function(con, sql, ...) {
#'     fields <- dbplyr::build_sql("SELECT * FROM (", sql, ") WHERE 0=1", con = con)
#'
#'     qry <- ROracle::dbSendQuery(con, fields)
#'     on.exit(ROracle::dbClearResult(qry))
#'
#'     tolower(ROracle::dbGetInfo(qry)$fields$name)
#' }
#'
#' #' @importFrom utils head
#' #' @export
#' head.tbl_oracle <- function(x, n = 6L, ...) {
#'     assert_that(length(n) == 1, n > 0L)
#'     dbplyr::db_collect(x, ..., n = n, warn_incomplete = FALSE)
#' }
#'
#' #' @importFrom dplyr collect
#' #' @export
#' collect.tbl_oracle <- function(x, ..., n = 1e+05, warn_incomplete = TRUE) {
#'     res <- dbplyr::db_collect(x, ..., n = n, warn_incomplete = warn_incomplete)
#'     names(res) <- tolower(names(res))
#'     res
#' }
