#' @export
tbl_cdw <- function(query, dsn = NULL, uid = NULL, pwd = NULL) UseMethod("tbl_cdw")

#' @export
tbl_cdw.character <- function(query, dsn = NULL, uid = NULL, pwd = NULL) {
    if (is.null(dsn)) dsn <- config("default_dsn")

    assert_that(is.string(query))

    if (is.null(uid) || is.null(pwd)) {
        credential <- credential(dsn)
        uid <- credential$UID
        pwd <- credential$PWD
    }

    if (file.exists(query)) {
        query <- sql_from_file(query)
    }

    con <- connect(dsn, uid = uid, pwd = pwd)
    dplyr::tbl(con, query)
}

#' @export
tbl_cdw.connection <- function(query, dsn = NULL, uid = NULL, pwd = NULL) {
    query <- sql_from_con(query)
    tbl_cdw(query, dsn, uid, pwd)
}
