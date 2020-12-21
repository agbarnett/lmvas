
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eq5d.plus

<!-- badges: start -->
<!-- badges: end -->

The goal of eq5d.plus is to run linear models on EQ-5D quality of life
data that uses both the score and visual analogue scale (VAS).

## Installation

You can install the released version of eq5d.plus from
[GitHub](https://github.com/) with:

``` r
# use the devtools library
library(devtools)
# Install the latest version from GitHub:
install_github("agbarnett/lmvas")
```

## Example

This example runs a linear model with independent variables of age and
sex:

``` r
library(eq5d.plus)
## example using the Spanish osteoarthritis data
model = lmvas(vas_name='EQ5D_VAS', eq_name='EQ5D', independent_vars = c('age','sex'), data=arthritis)
summary(model)
#> 
#> Call:
#>    "inla(formula = as.formula(formula), family = \"normal\", data = 
#>    for_model2)" 
#> Time used:
#>     Pre = 1.23, Running = 3.16, Post = 0.406, Total = 4.79 
#> Fixed effects:
#>               mean    sd 0.025quant 0.5quant 0.975quant   mode kld
#> (Intercept)  0.967 0.014      0.939    0.967      0.995  0.967   0
#> type_vas    -0.153 0.006     -0.164   -0.153     -0.141 -0.153   0
#> age55-59    -0.047 0.018     -0.082   -0.047     -0.012 -0.047   0
#> age60-64    -0.046 0.019     -0.083   -0.046     -0.009 -0.046   0
#> age65-69    -0.056 0.019     -0.093   -0.056     -0.019 -0.056   0
#> age70-74    -0.067 0.021     -0.108   -0.067     -0.027 -0.067   0
#> age75-79    -0.104 0.022     -0.147   -0.104     -0.062 -0.104   0
#> age80-84    -0.122 0.025     -0.170   -0.122     -0.074 -0.122   0
#> age85+      -0.216 0.027     -0.269   -0.216     -0.163 -0.216   0
#> sexWoman    -0.041 0.011     -0.063   -0.041     -0.020 -0.041   0
#> 
#> Random effects:
#>   Name     Model
#>     ID IID2D model
#> 
#> Model hyperparameters:
#>                                             mean       sd 0.025quant 0.5quant
#> Precision for the Gaussian observations 2.21e+04 1.97e+04   2186.430 1.66e+04
#> Precision for ID (component 1)          2.42e+01 1.09e+00     22.114 2.42e+01
#> Precision for ID (component 2)          2.86e+01 1.29e+00     26.112 2.85e+01
#> Rho1:2 for ID                           5.57e-01 2.20e-02      0.513 5.57e-01
#>                                         0.975quant     mode
#> Precision for the Gaussian observations   7.41e+04 6311.739
#> Precision for ID (component 1)            2.64e+01   24.128
#> Precision for ID (component 2)            3.12e+01   28.494
#> Rho1:2 for ID                             5.99e-01    0.558
#> 
#> Expected number of effective parameters(stdev): 1994.00(7.35)
#> Number of equivalent replicates : 1.00 
#> 
#> Marginal log-Likelihood:  546.51
```

The results show a reduced intercept for the VAS compared with the score
of -0.153. Quality of life is lower on average for women and for older
respondents.

The score and VAS are positively correlated with an estimated
correlation of 0.557 (“rho” estimate in model hyperparameters).

The model may take a short while to run for very large data sets.
