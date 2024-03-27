design_output <- design_cont(
  delta0 = 0.178,
  delta1 = 0.545,
  alpha = 0.05,
  beta = 0.1,
  k = 4,
  frac = c(1 / 2, 1)
)

test_that("returns a list containing 3 elements and sample size are greater than 0", {
  expect_equal(
    length(names(design_output)),3
  )


  expect_true(all(c(design_output$`Sample size`,design_output$`Maximum total sample size for the trial`) > 0))

})


