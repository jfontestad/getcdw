#' @export
config <- function(key) {
    default_dsn <- "URELUAT"

    get(key, inherits = FALSE)
}
