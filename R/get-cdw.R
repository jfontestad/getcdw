#' Get data from the CDW
#'
#' @param query A SQL query. This can be either the text of the query, the name
#' of a file that contains the query, or a valid connection that contains the
#' text of the query.
#' @param dsn The name of the connection, as it appears in your \code{tnsnames}
#' @param uid Your username (see details)
#' @param pwd Your password (see details)
#' @param ... Other arguments passed on to \code{dbSendQuery} in package \code{ROracle}
#'
#' @details Returns a data.frame if the query is successful, otherwise an error.
#' If you don't enter a username/password, \code{get_cdw} will check the global
#' environment for these values. The first time you run a query against a given
#' \code{dsn}, you will be prompted for your credentials. These will be saved in
#' an encrypted database in your home directory, so that you won't be prompted
#' for them again in the future. If you need to reset your credentials, use the
#' function \code{\link{reset_credentials}}.
#' @importFrom assertthat assert_that is.string
#' @importFrom dplyr tbl_df
#' @export
get_cdw <- function(query, dsn = config("default_dsn"), uid = NULL, pwd = NULL, ...) {
    UseMethod("get_cdw")
}

#' @export
get_cdw.connection <- function(query, dsn = config("default_dsn"),
                               uid = NULL, pwd = NULL, ...) {
    query <- sql_from_con(query)
    get_cdw(query, dsn, uid, pwd, ...)
}

# sends the query and retrieves results as a data frame
run_qry <- function(query, dsn, uid, pwd, n = -1L, ...) {

    # open a connection
    ch <- connect(dsn, uid, pwd)

    # be sure to clean up, even on errors
    on.exit(disconnect(ch))

    #send query, attempt to give back informative sql error messages if needed
    res <- send_qry(connection = ch, query = query)

    # fetch results
    res <- ROracle::fetch(res, n = n)

    # convert column names to lower-case, and add tbl_df class for
    # convenient printing
    prep_output(res)
}

connect <- function(dsn, uid, pwd) {
    # without loading the library, DBI can't find Oracle driver,
    # can't figure out why or how else to fix it.
    library(ROracle)

    driver <- DBI::dbDriver("Oracle")
    ROracle::dbConnect(driver, uid, pwd, dbname = dsn)
}

disconnect <- function(connection) {
    ROracle::dbDisconnect(connection)
}

prep_output <- function(res) {
    names(res) <- tolower(names(res))
    dplyr::tbl_df(res)
}

send_qry <- function(connection, query, ...) {
    tryCatch(ROracle::dbSendQuery(connection, query, ...),
             error = function(e) {
                 errmsg <- regexpr("ORA-[0-9]+:.*\n", e$message)
                 stop(regmatches(e$message, errmsg), call. = FALSE)
             })
}

mrun_qry <- memoise::memoise(run_qry)

#' Reset cache
#'
#' getcdw caches query results for better performance. Use \code{reset_cdw}
#' to empty the cache
#'
#' @export
reset_cdw <- function() memoise::forget(msend_qry)

#' @export
get_cdw.character <- function(query, dsn = config("default_dsn"), uid = NULL, pwd = NULL,
                              ...) {
    if (file.exists(query)) {
        query <- sql_from_file(query)
    }

    assert_that(is.string(query))
    if (is.null(uid) || is.null(pwd)) {
        credential <- credential(dsn)
        uid <- credential$UID
        pwd <- credential$PWD
    }

    # use msend to send the query, which will return already known results
    # in the case of a repeated query
    mrun_qry(query = query, dsn = dsn, uid = uid, pwd = pwd, ...)
}

#' Run a preview query
#'
#' Run a query but only return the first n rows of results. Useful for testing
#' queries that might run slowly.
#'
#' @inheritParams get_cdw
#' @param n The maximum number of rows to return
#' @export
preview_cdw <- function(query, n = 10, dsn = config("default_dsn"), uid = NULL, pwd = NULL,
                        ...) {

    get_cdw(query, dsn, uid, pwd, n = n, ...)
}
