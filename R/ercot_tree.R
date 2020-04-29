library(tidyverse)
library(rpart)  # i like this better than tree


load_coast_medium = read.csv('../data/load_coast_medium.csv', row.names=1)
load_coast_medium = arrange(load_coast_medium, KHOU_temp)
N = nrow(load_coast_medium)

# split into a training and testing set
train_frac = 0.8
N_train = floor(train_frac*N)
N_test = N - N_train
train_ind = sample.int(N, N_train, replace=FALSE) %>% sort
load_train = load_coast_medium[train_ind,]
load_test = load_coast_medium[-train_ind,]


# using rpart on the training data
# great vignette at
# https://cran.r-project.org/web/packages/rpart/vignettes/longintro.pdf

# method = "anova" means make splits based on sums of squared erros
big.tree = rpart(COAST ~ KHOU_temp + hour, method="anova",data=load_train,
          control=rpart.control(minsplit=5, cp=1e-6, xval=10))

# see for fitting details
#  e.g. minsplit = minimum number of observations in a node in order
#  					for a split to be attempted.
# xval = number of CV folds


# how big is the tree? pretty big!
nbig = length(unique(big.tree$where))
nbig

# look at the cross-validated error
plotcp(big.tree)
head(big.tree$cptable, 100)


# a helper function for pruning the tree at the 
# min + 1se complexlity threshold
prune_1se = function(treefit) {
  # calculate the 1se threshold
  errtab = treefit$cptable
  xerr = errtab[,"xerror"]
  jbest = which.min(xerr)
  err_thresh = xerr[jbest] + errtab[jbest,"xstd"]
  j1se = min(which(xerr <= err_thresh))
  cp1se = errtab[j1se,"CP"]
  prune(treefit, cp1se)
}


# prune at the cp parameter within 1se of the best
cvtree = prune_1se(big.tree)
length(unique(cvtree$where))

# still a pretty deep tree
plot(cvtree)
log2(length(unique(cvtree$where)))


# visualize the predictions on the testing data
load_test$COAST_hat =  predict(cvtree, load_test)
ggplot(filter(load_test, hour %in% c(5, 8, 15))) +
  geom_point(aes(x=KHOU_temp, y=COAST), alpha=0.1) + 
  geom_step(aes(x=KHOU_temp, y=COAST_hat, color=factor(hour)), size=1)


load_test$COAST_hat =  predict(cvtree, load_test)
ggplot(filter(load_test, hour %in% c(15, 19, 23))) +
  geom_point(aes(x=KHOU_temp, y=COAST), alpha=0.1) + 
  geom_step(aes(x=KHOU_temp, y=COAST_hat, color=factor(hour)), size=1)


# calculate test_set RMSE
rmse = function(y, yhat) {
  sqrt(mean((y-yhat)^2))
}

rmse(load_test$COAST, predict(cvtree, load_test))


## Compare with a tree that uses more variables

# method = "anova" means make splits based on sums of squared erros
big.tree2 = rpart(COAST ~ KHOU_temp + month + hour + KHOU_dewpoint + day,
                  method="anova",data=load_train,
                  control=rpart.control(minsplit=5, cp=1e-6, xval=10))

# prune at the cp parameter within 1se of the best
cvtree2 = prune_1se(big.tree2)
length(unique(cvtree2$where))

# original tree (temp + hour)
rmse(load_test$COAST, predict(cvtree, load_test))

# tree with a few more variables (day, monthm dewpoint)
rmse(load_test$COAST, predict(cvtree2, load_test))

# compare with a simple linear model with some spline terms for nonlinearities
library(splines)
lm1 = lm(COAST ~ bs(KHOU_temp, 7) + factor(month) + bs(hour, 7) + bs(KHOU_dewpoint, 7) + factor(day), data=load_train)

# similar to our basic tree with two variables
rmse(load_test$COAST, predict(lm1, load_test))


