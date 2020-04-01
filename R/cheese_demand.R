library(gamlr)
library(tidyverse)


# Problem 1
cheese = read.csv('../data/cheese.csv')
summary(cheese)

# lots of store-level differences
p0 = ggplot(cheese)
p0 + geom_boxplot(mapping=aes(x=store, y=log(vol))) +
  coord_flip() +
  theme(axis.text.y =element_text(size=4))

# obviously demand decreases with price
p0 + geom_point(aes(x=log(price), y=log(vol)))

# and display matters
p0 + geom_boxplot(aes(x=factor(disp), y=log(vol)))


# simple demand model
lm1 = lm(log(vol) ~ log(price) + disp + store, data=cheese)
summary(lm1)

# but do the elasticities differ by store and display status?
# we're going to have trouble for some of the stores here...
xtabs(~store + disp, data=cheese)

lm2 = lm(log(vol)~ log(price) + disp + store + store:log(price) + store:disp + store:disp:log(price), data=cheese)

# So let's allow interactions, but penalize them
# remember that -1 removes the intercept; gamlr will put one in for you
X_cheese = sparse.model.matrix(~ log(price) + disp + store + store:log(price) + store:disp + store:disp:log(price), data=cheese)[,-1]
y_cheese = log(cheese$vol)

# the first 89 coefficients in this matrix correspond to main effects
# we want to leave these in!
# don't penalize main effects if you want to use the lasso to search for interactions
colnames(X_cheese)

# the "free" argument tells gamlr which coefficients not to penalize
# see ?gamlr
lasso1 = cv.gamlr(X_cheese, y_cheese, free=1:89, nfolds=10)
beta_hat = coef(lasso1)
coef_names = rownames(coef(lasso1))

# main effects
beta_hat[1:3,]

# Let's look at specific stores
check_coef = grep('DALLAS/FT. WORTH - KROGER CO', coef_names)
check_coef = grep('SYRACUSE - PRICE CHOPPER', coef_names)
check_coef = grep('JACKSONVILLE,FL - FOOD LION', coef_names)
check_coef = grep('A & P', coef_names)

beta_hat[1:3,]
beta_hat[c(1:3, check_coef),]
