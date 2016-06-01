context("find_columns")

test_that("find_columns finds tables with standard input", {
    x <- find_columns("activity")
    expect_true("activity_code" %in% x$column_name)

    x <- find_columns("ACTIVITY")
    expect_true("activity_code" %in% x$column_name)

    x <- find_columns("pledged")
    expect_true("pledged_basis_flg" %in% x$column_name)

    x <- find_columns("activity", "student_activity")
    expect_false("d_bio_activity_mv" %in% x$table_name)
    expect_false("activity_code" %in% x$column_name)

    x <- find_columns(table_name = "student_activity")
    expect_true("d_bio_student_activity_mv" %in% x$table_name)
    expect_true(all(c("student_activity_desc", "student_activity_code") %in% x$column_name))
    expect_false("d_bio_activity_mv" %in% x$table_name)
})

test_that("find_columns works with no input", {
    x <- find_columns()
    expect_is(x, "data.frame")
})

test_that("find_columns does not accept multiple input", {
    expect_error(find_columns(c("activity", "degree")))
})
