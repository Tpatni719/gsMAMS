---
title: 'gsMAMS: an R package for Desinging Multi-Arm Multi-Stage Clinical Trials'
tags:
  - R
  - Clinical trial
  - Stopping boundaries 
  - Operating Characteristics 
  - Computational time
authors:
  - name: Tushar Patni
    orcid: 0000-0003-1605-7207
    affiliation: "1"
  - name: Yimei Li
    orcid: 0000-0002-7046-4316
    affiliation: "1"
  - name: Jianrong Wu
    orcid: 0000-0002-3519-5894
    affiliation: "2"
    
affiliations:
 - name: St. Jude Children's Research Hospital
   index: 1
 - name: University of New Mexico Comprehensive Cancer Center
   index: 2
   
date:  9 January 2024
bibliography: paper.bib
---

# Summary
A multi-arm trial allows simultaneous comparison of multiple experimental treatments with a common control and provides a substantial efficiency advantage compared to conventional randomized controlled trial. A multi-stage trial allows multiple interim looks at the trial outcome so that the ineffective arm can be stopped early. In the current R ecosystem, `MAMS` @Jaki2019 is one of the few packages that can handle multiple stages, multiple treatment arms and different types of endpoints but the computational effort of obtaining sample size and sequential stopping boundaries is very high when the number of stages exceeds 3. More importantly, their method may lead to under powered study when the endpoint is time to event data. Therefore, we introduce the R package `gsMAMS` for designing group sequential multi-arm multi-satge (MAMS) trials with continuous, ordinal and survival outcomes which is computationally very efficient even for number of stages greater than 3. We also discuss the applications of the package.          



# Statement of Need
Traditional two-arm randomized control trials are not an optimal choice when multiple experimental arms are available for testing efficacy. In such situations, a multiple-arm trial should be preferred, which allows simultaneous comparison of multiple experimental arms with a common control and provides substantial efficiency advantage. In multi-arm trials, several arms are monitored in a group sequential fashion, with ineffective arms being dropped out of the study. 

Some packages that are available in R have limitations either in the number of treatment arms that can be incorporated in the package, the number of interim analyses that can be implemented in the package, or the different kinds of outcomes that the package can handle, but the `MAMS` package works well both for multiple treatment arms and multiple stages. It also works for continuous, ordinal, and survival outcomes. But the computational effort of obtaining stopping boundaries is very high when the number of stages exceeds 3. This is the major hurdle of using `MAMS` package.

This paper introduces the R package `gsMAMS` available at https://cran.r-project.org/web/packages/gsMAMS/ which provides functions to obtain sample size, and efficacy and futility boundaries for multiple stages and multiple experimental arms. It also provides functions that generate operating characteristics for designing the trials of continuous, ordinal, and survival outcomes. It is computationally very fast compared to the `MAMS` package, even for number of stages greater than 3.

# Compuational Aspects
The computational complexity of this package is very low. The family wise error rate(FWER) is controlled by Dunnett correction, which entails finding the root of an integral of a multivariate normal distribution. The multivariate normal densities are evaluated using the package `mvtnorm`. The package is efficient for any number of treatment arms and stages, but it has a limitation that it is only configured for 10 stages. In practice, a study rarely needs to have more than 10 interim looks planned. To give an example, the computational time of `MAMS` package to obtain stopping boundaries and sample size of a multi-arm trial for continuous outcome with four experimental arms and three stages is around 7 minutes and for four stages is around 4.5 hours. But for `gsMAMS` package with same trial configuration, the computational time to obtain stopping boundaries and sample size for three stages and four stages design is around 0.06 seconds for both the cases.
The operating characteristics for continuous and ordinal outcomes require less computational effort than the survival outcomes. The computational burden of sample size and sequential conditional probability ratio test(SCPRT) boundary calculation for continuous, ordinal and survival outcomes is minimal because there are only two critical components of algorithm which are the roots of FWER and power i.e., critical value and samples size.    
 
# Application
In this section, we will demonstrate the use of `gsMAMS` package and provide a separate example for each type of outcome.

## Continuous outcome
For the continuous outcome, we will consider TAILoR trial, which is a phase II trial, and it compares three doses of telmisartan (20, 40, 80mg) with no intervention (control) for the reduction of insulin resistance in human immunodeficiency virus-positive patients receiving combination antiretroviral therapy. The primary outcome measure is a reduction in mean homeostasis model assessment of insulin resistance (HOMA-IR) score at 24 weeks. The standardized desirable and minimal effect sizes for efficacy are set as $\delta^{(1)}$ = 0.545 for 80mg group and $\delta^{(0)}$ = 0.178 for 20 and 40 mg groups, respectively, for the trial design. 
The sample size calculation is based on a one-sided type I error of 5\% and a power of 90\%. Based on the trial characteristics, we will design the trial for a two-stage design.
The design parameters of the trial can be calculated using the design_cont function and the arguments in the function correspond to standardized effect size in ineffective arm(delta0} and effective arm(delta1), type I error(alpha), type II error(beta), total number of treatment arms(K) and the information time (0.5, 1) is denoted by frac argument in the function.

```R
#Installing the package from CRAN
install.packages("gsMAMS")
#Loading the library
library(gsMAMS)
```



```R
set.seed(1234)
design_cont(delta0 = 0.178, delta1 = 0.545, alpha = 0.05, beta = 0.1, K = 3, frac = c(0.5, 1))
```

For FWER and Stagewise FWER:

The operating characteristics of the trial can be generated using the op_power_cont and op_fwer_cont functions for power under alternative hypothesis and FWER under global null hypothesis respectively. Most of the arguments in the function are similar to size and SCPRT functions with the exception of number of simulations(nsim) and seed number(seed).

```R
op_fwer_cont(alpha = 0.05, beta = 0.1, K = 3, frac = c(0.5, 1), delta0 = 0.178, delta1 = 0.545, nsim = 10000, seed = 10)
``` 

For Power and Stagewise Power:
```R
op_power_cont(alpha = 0.05, beta = 0.1, K = 3, frac = c(0.5, 1), delta0 = 0.178, delta1 = 0.545, nsim = 10000, seed = 10)
```

## Ordinal Outcome
For ordinal outcome, we will consider ASCLEPIOS trial, a phase II trial for patients with stroke. The primary outcome response is the patient's Barthel index assessed 90 days after randomization. This is an ordered categorical score ranging from 0 (vegetative state) to 100 (complete recovery) in steps of 5, and relates to activities of daily living that the patient is able to undertake. Following the ASCLEPIOS study, we group the outcome categories of the score into six larger categories. We will consider the treatment worthwhile if the odds ratio between the effective and control arms is 3.06 and we set the null odds ratio to be 1.32 which is the odds ratio between the ineffective and control arms.   
The sample size calculation is based on a one-sided FWER of 5\% and a power of 90\%. Based on the trial characteristics, we will design the trial for a three-stage design. The design parameters for a five-arm (K = 4) trial can be calculated using design_ord function and the arguments in the function correspond to probability of outcomes in control group(prob), odds ratio of ineffective treatment group vs control(or0), odds ratio of effective treatment group vs control(or) and the remaining arguments are similar to the design_cont function for continuous outcome.

```R
design_ord(prob = c(0.075, 0.182, 0.319, 0.243, 0.015, 0.166), or = 3.06, or0 = 1.32, alpha = 0.05, beta = 0.1, K = 4, frac = c(1/3, 2/3, 1))
```
The operating characteristics can be generated using the functions op_fwer_ord and op_power_ord which are similar to that of continuous outcome.

## Survival Outcome
For survival outcome, we will consider a MAMS trial with five arms (four treatment arms and a control arm, K=4) and two interim looks with balanced information time (0.5, 1). The null hazards ratio is 1 and the alternative hazards ratio is 0.65. The median survival time of control group is 20 months and the survival distribution is exponential without loss to follow-up. The sample size calculation is based on a one-sided type I error of 5\% and a power of 90\%. 

The design parameters for a two-stage design can be calculated using the design_surv function and the arguments in the function correspond to median survival time of the control group(m0), hazard ratio of ineffective treatment vs control(HR0), hazard ratio of effective treatment vs control(HR1), accrual time(ta), follow-up time(tf), shape parameter of Weibull distribution(kappa), rate of loss to follow-up(eta)(assumed loss to follow-up follows an exponential distribution with rate parameter eta). 

```R
design_surv(m0 = 20, HR0 = 1, HR1 = 0.67032, ta = 40, tf = 20, alpha = 0.05, beta = 0.1, K = 4, kappa = 1, eta = 0, frac = c(0.5, 1))
```

The operating characteristics of the trial can be generated using the op_power_surv and op_fwer_surv function.

For FWER and Stagewise FWER:
```R
op_fwer_surv(m0 = 20, alpha = 0.05, beta = 0.1, K = 4, frac = c(1/2, 1), HR0 = 1, HR1 = 0.6703, nsim = 10000, ta = 40, tf = 20, kappa = 1, eta = 0, seed = 12)
```
For Power and Stagewise Power :
```R
op_power_surv(m0 = 20, alpha = 0.05, beta = 0.1, K = 4, frac = c(1/2, 1), HR0 = 1, HR = 0.6703, nsim = 10000, ta = 40, tf = 20, kappa = 1, eta = 0, seed = 12)
```
 
# Acknowledgements
Dr. Wu's research was supported by the University of new Mexico Comprehensive Cancer Center Support Grant National Cancer Institute (NCI) P30CA118100 and 
Dr. Li's research was supported by the Comprehensive Cancer Center at St. Jude Children's Research Hospital and American Lebanese Syrian Associated Charities (ALSAC).

# References
