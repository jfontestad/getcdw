#' Create a template with parameters
#'
#' @param tmpl a template, where parameters are ##highlighted## with double-octothorpes
#'
#' @examples
#' greeting_template <- "my name is ##name##, and I am ##age## years old"
#' greeter <- parameterize_template(greeting_template)
#' greeter(name = "tarak", age = 36)
#' @export
parameterize_template <- function(tmpl) {
    tmpl <- as.character(tmpl)
    if (file.exists(tmpl)) tmpl <- sql_from_file(tmpl)

    if (length(tmpl) > 1)
        stop("functionalize only works with one template at a time")
    if (is.na(tmpl))
        stop("Unable to process template")
    keys <- stringr::str_match_all(tmpl, "##([^#]+)##")[[1]][,2]
    if (length(keys) < 1L)
        warning("No parameters were identified in your template")

    structure(
        function(...) {
            entry <- list(...)
            entered <- names(entry)

            # if there's only one parameter, then you don't need
            # to name it
            if (length(keys) == 1L && length(entry) == 1L &&
                length(entered) < 1L) entered <- keys

            entered_not_recognized <- setdiff(entered, keys)
            expected_not_entered <- setdiff(keys, entered)

            if (length(entered_not_recognized) > 0)
                stop("invalid arguments:\n",
                     paste0(entered_not_recognized, collapse = "; "))

            if (length(expected_not_entered) > 0)
                stop("missing arguments:\n",
                     paste0(expected_not_entered, collapse = "; "))

            replacer <- function(to_replace, replacement) {
                stringr::str_replace(tmpl, to_replace, replacement)
            }

            to_replace <- paste0("##", entered, "##")
            replacement <- as.character(entry)
            out <- tmpl
            for (word in seq_along(to_replace)) {
                out <- stringr::str_replace_all(out, to_replace[word],
                                                replacement[word])
            }
            out
        },
        class = "parameterized_template",
        parameters = keys)
}

#' @export
print.parameterized_template <- function(f) {
    cat("A parameterized template with parameters: ",
        paste(attr(f, "parameters"), collapse = ", "))
    invisible(f)
}
