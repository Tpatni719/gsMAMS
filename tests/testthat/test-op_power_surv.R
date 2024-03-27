op_output<-op_power_surv(m0=20, alpha=0.05, beta=0.1, p=4, frac=c(1 / 2, 1), hr0=1, hr1=0.75, nsim=100, ta=40, tf=20, kappa=1, eta=0, seed=12)



test_that("Power is not greater than 1 and average sample size is greater than 0", {
  expect_true(
    op_output$Power<=1
  )


  expect_true(op_output$`Average number of events happened per arm under alternative`> 0)

})
