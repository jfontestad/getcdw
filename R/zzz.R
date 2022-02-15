.onLoad <- function(libname, pkgname) {
    requireNamespace("odbc", quietly = TRUE)
}

.onUnload <- function(libpath) {
    ## close any open connections
    connection_center("closeout")
}
