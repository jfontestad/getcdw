context("find_tables")

test_that("find_tables finds tables with standard input", {
    x <- find_tables("activity")
    expect_true("d_bio_student_activity_mv" %in% x$table_name)

    x <- find_tables("ACTIVITY")
    expect_true("d_bio_student_activity_mv" %in% x$table_name)

    x <- find_tables("deg")
    expect_true("d_bio_degrees_mv" %in% x$table_name)
})

test_that("find_tables works with no input", {
    x <- find_tables()
    expect_is(x, "data.frame")
})

test_that("find_tables does not accept multiple input", {
    expect_error(find_tables(c("activity", "degree")))

})
