.onLoad <- function(libname, pkgname) {
    requireNamespace("ROracle", quietly = TRUE)
}

.onUnload <- function(libpath) {
    ## close any open connections
    connection_center("closeout")
}
