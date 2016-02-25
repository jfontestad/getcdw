sql_from_con <- function(con) {
    query <- readLines(con)
    query <- paste(query, collapse = "\n")
    query
}

sql_from_file <- function(f) {
    con <- file(f, open = "rt")
    on.exit(close(con))
    sql_from_con(con)
}
