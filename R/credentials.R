save_env <- function(varname, value) {
    path <- normalizePath("~/")
    filename <- file.path(path, ".Renviron")
    if (!file.exists(filename)) file.create(filename)
    cat(varname, "='", value, "'\n", sep = "", file = filename, append = TRUE)
}

cred <- function(dsn, type, force = FALSE, remember = TRUE) {
    varname <- paste(toupper(dsn), type, sep = "_")
    env <- Sys.getenv(varname)
    if (!identical(env, "") && !force) return(env)

    if (!interactive()) {
        stop("Please set environment variables for ", dsn,
             call. = FALSE)
    }

    message("Please enter your ", type, " for connection ", dsn, " and press enter:")
    var <- readline(": ")

    if (identical(var, "")) {
        stop("Invalid", call. = FALSE)
    }

    do.call(Sys.setenv, structure(list(var), names = varname))
    if (remember) save_env(varname, var)
    var
}

#' Set/reset credentials
#'
#' @param dsn The name of the connection, as it appears in your tnsnames
#'
#' @description If run in an interactive session, you will be prompted for your UID (user ID)
#' and PWD (password). Your entries will be stored in an environment variable,
#' as well as saved in your .Renviron file. You can also manually edit the .Renviron
#' file to set/change credentials.
#' @export
reset_credentials <- function(dsn) {
    if (!interactive())
        stop("Set environment variables or edit your .Renviron")
    cred(dsn, type = "UID", force = TRUE, remember = TRUE)
    cred(dsn, type = "PWD", force = TRUE, remember = TRUE)
}
