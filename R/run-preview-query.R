#' Run a preview query
#'
#' In RStudio, use this as an add-in to interactively run a preview query
#' against the data warehouse. Returns the first 10 rows. Bind a keyboard
#' shortcut through the RStudio "Addins | Browse Addins | Keyboard shortcuts"
#' menu. RStudio also has syntax highlighting/indenting for SQL files (adjust
#' the file type in the bottom right corner of the text editor window).
#'
#' @export
runPreviewQuery <- function() {
    context <- rstudioapi::getActiveDocumentContext()
    qry <- context$selection[[1]]$text
    if (qry == "") stop("No text selected", call. = FALSE)
    message("Retrieving results...")
    getcdw::preview_cdw(qry)
}
