.driver <- function() {
    drv <- NULL

    function() {
        if (!is.null(drv)) return(drv)
        else {
            drv <<- DBI::dbDriver("odbc")
            return(drv)
        }
    }
}

driver <- .driver()

new_connection_center <- function() {
    connections <- new.env(parent = emptyenv())

    closeout <- function() {
        all_cons <- ls(connections)
        stopifnot(all(
                vapply(
                    all_cons,
                    function(ch) disconnect(connections[[ch]]),
                    logical(1)
                ))
        )
    }

    checkout <- function(dsn, uid, pwd) {
        key <- paste0(dsn, uid)
        con <- connections[[key]]

        if (!is.null(con)) return(con)
        else return(set(dsn, uid, pwd))
    }

    set <- function(dsn, uid, pwd) {
        key <- paste0(dsn, uid)
        con <- odbc::dbConnect(odbc::odbc(), dsn = dsn, uid = uid, pwd = pwd)
        assign(key, con, pos = connections)
        return(con)

    }

    function(action)
        switch(action,
               closeout = closeout(),
               checkout = function(dsn, uid, pwd) checkout(dsn, uid, pwd),
               reset = function(dsn, uid, pwd) set(dsn, uid, pwd),
               show_all = ls.str(connections)
        )
}

connection_center <- new_connection_center()

#' Connect to a database instance
#'
#' When running \code{\link{get_cdw}} and related functions, the connection to
#' the database is opened silently in the background, but this function might
#' be useful if you need to create a connection without immediately querying
#' the database. For instance, \url{http://rmarkdown.rstudio.com/authoring_knitr_engines.html#sql}.
#'
#' @param dsn The dsn name, as it appears in your \code{tnsnames.ora}
#' @param uid User ID - if NULL, it will be looked up in the getcdw encrypted credential databse
#' @param pwd Password - if NULL, it will be looked up in the getcdw encrypted credential databse
#' @export
connect <- function(dsn, uid = NULL, pwd = NULL) {
    if (is.null(uid) || is.null(pwd)) {
        credential <- credential(dsn)
        uid <- credential$UID
        pwd <- credential$PWD
    }

    # check out the connection from the connection center
    # haven't yet checked that the connection is operational,
    # though it had to be created successfully
    check_out(dsn, uid, pwd)
}

check_out <- connection_center("checkout")
reset <- connection_center("reset")

disconnect <- function(connection) {
    tryCatch(
        odbc::dbDisconnect(connection),
        error = function(e) {
            if (grepl("invalid connection", e$message, ignore.case = TRUE))
                return(TRUE)
            else stop(e)
        }
    )
}
