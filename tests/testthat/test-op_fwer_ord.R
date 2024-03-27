op_output<-op_fwer_ord(alpha = 0.05,beta = 0.1,p = 4, frac = c(0.5, 1),or0 = 1.32,or = 3.06, nsim = 15,prob = c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166),
                       seed = 13)





test_that("Family wise error rate is not greater than 1 and average sample size is greater than 0", {
  expect_true(
    op_output$FWER<1
  )


  expect_true(op_output$`Average sample size used per arm under null`> 0)

})
