library(gamlr)
library(tidyverse)


# let's simulate some confounders
N = 500
P = 50
X = matrix(rnorm(N*P, 0, 1), nrow=N)

d_on_x = rep(1/P, P)

sd_independent = 1
d = X %*% d_on_x + rnorm(N, 0, sd_independent)


y_on_x = rep(1/P, P)
y = 

g1 = gamlr(cbind(d,X), y)