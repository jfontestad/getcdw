context("find_codes")

test_that("find_codes finds tables with standard input", {
    x <- find_codes("peace corps")
    expect_true("PCBRA" %in% x$code)

    x <- find_codes("PEACE CO")
    expect_true("PCBRA" %in% x$code)

    x <- find_codes("peace co", "affiliation")
    expect_false("PCBRA" %in% x$code)
    expect_true("X17" %in% x$code)

    x <- find_codes(table_name = "office")
    expect_true(all(c("BB", "LS", "QB") %in% x$code))
})

test_that("find_columns works with no input", {
    x <- find_codes()
    expect_is(x, "data.frame")
})

test_that("find_codes does not accept multiple input", {
    expect_error(find_codes(c("activity", "degree")))
})
