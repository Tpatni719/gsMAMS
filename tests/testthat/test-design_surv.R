design_output<-design_surv(m0 = 20, hr0 = 1, hr1 = 0.67032, ta = 40,
                           tf = 20, alpha = 0.05, beta = 0.1, k = 4,
                           kappa = 1, eta = 0, frac = c(0.5, 1))



test_that("returns a list containing 4 elements and sample size are greater than 0", {
  expect_equal(
    length(names(design_output)),4
  )


  expect_true(all(c(design_output$`Sample size`,design_output$`Maximum total sample size for the trial`) > 0))

})

