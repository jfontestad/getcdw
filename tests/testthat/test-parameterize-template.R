context("parameterize template")

test_that("repeated occurrence of a template variable only leads to one function argument", {
    f <- parameterize_template("my name is ##name##. Once again, that is ##name##")
    expect_identical(parameters(f), "name")
})
