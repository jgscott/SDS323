library(mosaic)

predimed = read.csv('../data/predimed.csv')

# Cross tabulate participants by group and event status
# "Event = Yes" means some cardiac event 
xtabs(~group + event, data=predimed)

# A normal-based confidence interval for
# P(event) in the MedDiet + VOO group
n = 2097+85
x = 85
p_hat = x/n
se_hat = sqrt(p_hat*(1-p_hat)/n)

p_hat + c(-1.96, 1.96)*se_hat

# Parametric bootstrap:
# 1) Repeatedly simulate data under the assumed
#	 parametric model, using fitted parameter.
# 2) For each simulated data set, refit the model.
# 3) Approximate the sampling distribution using the
#	histogram of fitted parameters.

boot1 = do(1000)*{
	
	# 1) simulate data under the fitted parameter
	# (versus ordinary bootstrap:
	#	resample data with replacement)
	x_sim = rbinom(1, n, p_hat)
	
	# 2) Re-estimate the parameter using the simulated data
	p_hat_sim = x_sim/n
	
	# Return p_hat_sim
	p_hat_sim
}

# 3) Inspect the sampling distribution
hist(boot1$result)

# Bootstrapped estimate of standard error
sd(boot1$result)

# Compare with plug-in estimate
se_hat

# Compare bootstrap and normal-based confidence intervals
confint(boot1)
p_hat + c(-1.96, 1.96)*se_hat



## Bootstrapping a logistic regression model

glm1 = glm(event ~ group + sex + smoke + htn + diab, data=predimed, family=binomial)
coef(glm1)

# our fitted parametric estimate of each person's probability of an event
p_hat = fitted(glm1)

# simulate an alternate data universe under these fitted probabilities
N = nrow(predimed)
y_sim = rbinom(N, prob=p_hat, size=1)

# things are different in our alternate universe!
table(predimed$event, y_sim)

glm_boot = glm(y_sim ~ group + sex + smoke + htn + diab, data=predimed, family=binomial)
coef(glm1)
coef(glm_boot)

# repeat 500 times
paraboot1 = do(500)*{
  y_sim = rbinom(N, prob=p_hat, size=1)
  glm_boot = glm(y_sim ~ group + sex + smoke + htn + diab, data=predimed, family=binomial)
  coef(glm_boot)
}

# parametric bootstrap sampling distribution of the diet coefficients
hist(paraboot1$groupMedDiet...VOO)
