#' Get data from the CDW
#'
#' @param query A SQL query. This can be either the text of the query, the name
#' of a file that contains the query, or a valid connection that contains the
#' text of the query.
#' @param dsn The name of the connection, as it appears in your \code{tnsnames}
#' @param uid Your username (see details)
#' @param pwd Your password (see details)
#' @param stringsAsFactors TRUE/FALSE. Whether strings should be returned as factors. FALSE by default
#' @param ... Other arguments passed on to \code{sqlQuery} in package \code{RODBC}
#'
#' @details Returns a data.frame if the query is successful, otherwise an error.
#' If you don't enter a username/password, \code{get_cdw} will check the global
#' environment for these values. The first time you run a query against a given
#' \code{dsn}, you will be prompted for your credentials. These will be saved in
#' your .Renviron file, so that you won't be prompted for them again in the future.
#' @importFrom assertthat assert_that is.string
#' @import RODBC
#' @importFrom dplyr tbl_df
#' @export
get_cdw <- function(query, dsn = "CDW2", uid = NULL, pwd = NULL,
                    stringsAsFactors = FALSE, ...) {
    UseMethod("get_cdw")
}

#' @export
get_cdw.connection <- function(query, dsn = "CDW2", uid = NULL, pwd = NULL,
                               stringsAsFactors = FALSE, ...) {
    query <- sql_from_con(query)
    get_cdw(query, dsn, uid, pwd, stringsAsFactors, ...)
}

#' @export
get_cdw.character <- function(query, dsn = "CDW2", uid = NULL, pwd = NULL,
                              stringsAsFactors = FALSE, ...) {
    if (file.exists(query)) {
        query <- sql_from_con(file(query))
    }

    assert_that(is.string(query))
    if (is.null(uid)) uid <- cred(dsn, "UID", force = FALSE, remember = TRUE)
    if (is.null(pwd)) pwd <- cred(dsn, "PWD", force = FALSE, remember = TRUE)

    # open a connection
    ch <- RODBC::odbcConnect(dsn = dsn, uid = uid, pwd = pwd)

    # be sure to clean up, even on errors
    on.exit(close(ch))

    #run query
    outp <- RODBC::sqlQuery(ch, query,
                            stringsAsFactors = stringsAsFactors, ...)

    # attempt to give back informative sql error messages if errors
    if (!is.data.frame(outp)) {
        errmsg <- regexpr("ORA-[0-9]+:.*$", outp)
        err <- regmatches(outp, errmsg)
        stop(err, call. = FALSE)
    }

    # convert column names to lower-case, and add tbl_df class for
    # convenient printing
    names(outp) <- tolower(names(outp))
    dplyr::tbl_df(outp)
}

#' Run a preview query
#'
#' Run a query but only return the first 10 rows of results. Useful for testing
#' queries that might run slowly.
#'
#' @inheritParams get_cdw
#' @export
preview_cdw <- function(query, dsn = "CDW2", uid = NULL, pwd = NULL,
                        stringsAsFactors = FALSE, ...) {

    get_cdw(query, dsn, uid, pwd, stringsAsFactors, max = 10, ...)

}
