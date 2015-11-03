#' Get data from the CDW
#'
#' @param query A SQL query, as a string of plain-text.
#' @param dsn The name of the connection, as it appears in your \code{tnsnames}
#' @param uid Your username
#' @param pwd Your password
#' @param stringsAsFactors TRUE/FALSE. Whether strings should be returned as factors. FALSE by default
#' @param ... Other arguments passed on to \code{sqlQuery} in package \code{RODBC}
#'
#' @details Returns a data.frame (unless)
#' @importFrom assertthat assert_that is.string
#' @import RODBC
#' @export
get_cdw <- function(query, dsn = "CDW2", uid, pwd,
                    stringsAsFactors = FALSE, ...) {

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
        stop(err)
    }

    # convert column names to lower-case, and add tbl_df class for
    # convenient printing
    names(outp) <- tolower(names(outp))
    dplyr::tbl_df(outp)
}
