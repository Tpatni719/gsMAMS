design_output<-design_ord(prob = c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166), or = 3.06,
           or0 = 1.32, alpha = 0.05, beta = 0.1, k = 4, frac = c(1/3, 2/3, 1))


test_that("returns a list containing 3 elements and sample size are greater than 0", {
  expect_equal(
    length(names(design_output)),3
  )


  expect_true(all(c(design_output$`Sample size`,design_output$`Maximum total sample size for the trial`) > 0))

})

