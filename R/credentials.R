credential <- function(dsn) {
    # first check the global environment
    dsncredential <- get_credentials_from_env(dsn)
    if (!is.null(dsncredential)) {
        store(dsn, dsncredential)
        return(dsncredential)
    }

    # otherwise see if the creds are in the encrypted db
    all_credentials <- load_db()
    dsncredential <- get_credential(all_credentials, dsn)
    if (!is.null(dsncredential)) {
        varname <- function(type)
            paste(toupper(dsn), type, sep = "_")
        do.call(Sys.setenv, structure(list(dsncredential$UID, dsncredential$PWD),
                                      names = c(varname("UID"), varname("PWD"))))
        return(dsncredential)
    }

    # finally, prompt user for input
    get_credentials_from_user(dsn)
}

get_credentials_from_user <- function(dsn) {
    ask_for_type <- function(type) {
        varname <- paste(toupper(dsn), type, sep = "_")
        msg <- paste("Please enter your ", type, " for connection ", dsn, " and press enter:", sep = "")
        if (type != "PWD") {
            message(msg)
            var <- readline(": ")
        } else {
            var <- .rs.askForPassword(msg)
        }

        if (identical(var, "")) {
            stop("Invalid", call. = FALSE)
        }

        do.call(Sys.setenv, structure(list(var), names = varname))
        var
    }
    UID <- ask_for_type("UID")
    PWD <- ask_for_type("PWD")

    res <- list(UID = UID, PWD = PWD)
    store(dsn, res)
    invisible(res)
}

get_credentials_from_env <- function(dsn) {
    varname <- function(type)
        paste(toupper(dsn), type, sep = "_")
    uid <- Sys.getenv(varname("UID"))
    pwd <- Sys.getenv(varname("PWD"))

    if (!identical(uid, "") && !identical(pwd, ""))
        return(list(UID = uid, PWD = pwd))
    else return(NULL)
}

db_filename <- function() {
    path <- normalizePath("~/")
    file.path(path, ".getcdw")
}

load_db <- function() {
    filename <- db_filename()
    if (file.exists(filename)) credentials <- readRDS(filename)
    else credentials <- credential_db()
    credentials
}



store <- function(dsn, dsncredential) {
    credentials <- load_db()
    UID <- dsncredential$UID
    PWD <- dsncredential$PWD
    set_credential(credentials, dsn, uid = UID, pwd = PWD)
    saveRDS(credentials, db_filename())
}

#' Set/reset credentials
#'
#' @param dsn The name of the connection, as it appears in your tnsnames
#'
#' @description If run in an interactive session, you will be prompted for your UID (user ID)
#' and PWD (password). Your entries will be stored in an environment variable,
#' as well as saved in the encrypted database called ".getcdw" in your home
#' direcotry.
#' @export
reset_credentials <- function(dsn) {
    get_credentials_from_user(dsn)
}
