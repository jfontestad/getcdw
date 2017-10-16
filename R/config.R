#' @export
config <- function(key) {
    if (Sys.getenv("GETCDW_DEFAULT_DSN") != "")
        default_dsn <- Sys.getenv("GETCDW_DEFAULT_DSN")
    else default_dsn <- "URELUAT"

    get(key, inherits = FALSE)
}
