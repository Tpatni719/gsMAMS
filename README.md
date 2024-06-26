
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gsMAMS

<!-- badges: start -->

[![CRAN](http://www.r-pkg.org/badges/version/gsMAMS)](http://cran.rstudio.com/package=gsMAMS)
[![Downloads](http://cranlogs.r-pkg.org/badges/gsMAMS?color=brightgreen)](http://www.r-pkg.org/pkg/gsMAMS)
<!-- badges: end -->

Traditional two-arm randomized control trials are not an optimal choice
when multiple experimental arms are available for testing efficacy. In
such situations, a multiple-arm trial should be preferred, which allows
simultaneous comparison of multiple experimental arms with a common
control and provides substantial efficiency advantage. In multi-arm
trials, several arms are monitored in a group sequential fashion, with
ineffective arms being dropped out of the study. **gsMAMS** R package
provides a good platform for designing and planning phase-II drug
trials(e.g. TAILoR trial (continuous outcome), ASCLEPIOS trial(ordinal
outcome)) with multiple treatment arms. The package provides
functionality for designing trials with continuous, ordinal and survival
outcomes which offers great flexibility and makes it a comprehensive
toolkit to handle different kinds of trials. It provides functions to
obtain sample size, and efficacy and futility boundaries for multiple
stages and multiple experimental arms. It also provides functions that
generate operating characteristics for designing the trials of
continuous, ordinal, and survival outcomes.

# Installation

## Install from CRAN

The stable version of **gsMAMS**, v0.7.2, is available on CRAN:

``` r
# install.packages("gsMAMS")
set.seed(1234)
library(gsMAMS)
```

## Usage

For the continuous outcome, we will consider TAILoR trial, which is a
phase II trial, and it compares three doses of telmisartan (20, 40,
80mg) with no intervention (control) for the reduction of insulin
resistance in human immunodeficiency virus-positive patients receiving
combination antiretroviral therapy. The primary outcome measure is a
reduction in mean homeostasis model assessment of insulin resistance
(HOMA-IR) score at 24 weeks. The standardized desirable and minimal
effect sizes for efficacy are set as δ(1) = 0.545 for 80mg group and
δ(0) = 0.178 for 20 and 40 mg groups, respectively, for the trial
design. The sample size calculation is based on a one-sided type I error
of 5% and a power of 90%. Based on the trial characteristics, we will
design the trial for a two-stage design.

``` r
#For designing a trial with continuous outcome.
design_cont(delta0 = 0.178, 
            delta1 = 0.545, 
            alpha = 0.05, 
            beta = 0.1, 
            k = 3, 
            frac = c(0.5, 1))
#> $`Sample size`
#>                                            Stage 1 Stage 2
#> Cumulative sample size for treatment group      40      79
#> Cumulative sample size for control group        40      79
#> 
#> $`Maximum total sample size for the trial`
#> [1] 316
#> 
#> $`Boundary values`
#>             Stage 1 Stage 2
#> Lower bound   0.006   2.062
#> Upper bound   2.910   2.062
```

The design output shows the cumulative sample size for treatment and
control groups at each stage. The SCPRT lower and upper boundaries are
(0.006, 2.062) and (2.91, 2.062) respectively. Based on the design
parameters, the first interim analysis can be conducted after the
enrollment of 40 patients in the control arm. If the test statistic
$Z_{k,l}<0.006$, the $k_{th}$ arm is rejected for futility at $1^{st}$
stage and the trial continues with the remaining treatment arms and the
control. If the test statistic 0.006 $\le$ $Z_{k,l}$ $\le$ 2.91 for
$k$=1,2,3 then the trial continues to the next stage and 39 patients are
further enrolled per arm. If $Z_{k,1} >2.91$ for some $k$, the trial is
terminated and the arm with maximum value of $Z_{k,1}$, $k$=1,2,3 would
be recommend for further study.

The operating characteristics of the trial can be generated using the
op_power_cont() functions for power under alternative hypothesis.

``` r
#Generating operating characteristics of the trial.
op_power_cont(alpha = 0.05, 
              beta = 0.1, 
              p = 3, 
              frac = c(0.5, 1), 
              delta0 = 0.178, 
              delta1 = 0.545, 
              nsim = 10000, 
              seed = 10)
#> $Power
#> [1] 0.893
#> 
#> $`Stagewise Power`
#>  look1  look2 
#> 0.3126 0.5804 
#> 
#> $`Stopping probability under alternative`
#>  look1  look2 
#> 0.3258 0.6742 
#> 
#> $`Probability of futility under alternative`
#>  look1  look2 
#> 0.0035 0.0821 
#> 
#> $`Average sample size used per arm under alternative`
#> [1] 62.652
```

Based on the simulation results, the probability of success/power at the
first stage is 31.26% and at the second stage is around 58.04%.
Therefore, the overall power is approximately 90%. The sample size
required for the trial was 79 patients per arm but the trial used around
an average of 62 subjects per arm. The stopping probability should add
up to 1 which is the case here and under alternate configuration, the
probability of futility is approximately 8.5% which is less than 10%
type II error. The reason is that the type II error comes from both
failing to find any efficacious arm (futility) and finding the less
efficacious arm as the most efficacious arm. The latter part was not
included when the probability of futility was calculated.

For detailed usage of the package, please see the paper in the
repository.

## Issues and Contribution

If you want to contribute to the code or file an issue, we prefer them
to be handled via GitHub (link to the issues page for `gsMAMS`
[here](https://github.com/Tpatni719/gsMAMS/issues)). You can also
contact us via email (see the DESCRIPTION file).
