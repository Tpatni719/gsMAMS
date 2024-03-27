op_output<-op_fwer_cont(alpha = 0.05, beta = 0.1, p = 3, frac = c(0.5, 1), delta0 = 0.178, delta1 = 0.545, nsim = 10, seed = 10)


test_that("Family wise error rate is not greater than 1 and average sample size is greater than 0", {
  expect_true(
    op_output$FWER<1
  )


  expect_true(op_output$`Average sample size used per arm under null`> 0)

})

