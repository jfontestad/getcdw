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
