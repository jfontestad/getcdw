sql_from_con <- function(con) {
    query <- readLines(con)
    query <- paste(query, collapse = "\n")
    query
}
