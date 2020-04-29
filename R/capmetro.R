library(tidyverse)
library(lubridate)
library(randomForest)
library(pdp)

# read in data and take a peak
capmetro = read.csv('../data/capmetro.csv')
summary(capmetro)

# weather data from Dark Sky API, https://darksky.net/dev

###
# Some data pre-processing
###

# Cast zone as a factor
# 361 and 362: UT area
# 454: part of downtown
# 1626 and 1713: outside of city center
capmetro$zone = factor(capmetro$zone)

# Re-order the day variable
capmetro$day = factor(capmetro$day, levels=c('Monday','Tuesday', "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# create a numerical hour and "minute of day" variables for plotting/inclusion in models
# the hour and minute functions are in lubridate, which expects timestamps in standard Y-M-D hour:min:sec format  
capmetro = mutate(capmetro, hour = hour(timestamp),
                            min_of_day = 60*hour(timestamp) + minute(timestamp))


# add dummy variables for precipitation and inSemester
capmetro = mutate(capmetro, precipYes = ifelse(precipIntensity>0, 1, 0),
                  inSemester = ifelse(date(timestamp) %within%
                                  interval(ymd("2018-08-29"), ymd("2018-12-07")), 1, 0))


####
# Exploratory plots
####

# long upper tails!
ggplot(data=capmetro) +
  geom_boxplot(mapping=aes(x=factor(hour), y=boarding))


hour_summ = capmetro %>%
  group_by(hour, zone, day, inSemester) %>%
  summarize(boarding_mean = mean(boarding))

ggplot(hour_summ) +
  geom_col(aes(x=hour, y=boarding_mean)) + 
  facet_grid(day~zone)


# focus on a UT-area zone
ggplot(filter(hour_summ, zone==362)) +
  geom_col(aes(x=hour, y=boarding_mean)) + 
  facet_grid(day~inSemester)


# temperature -- though confounded by time of day effects
ggplot(data=filter(capmetro, zone==362)) + 
  geom_point(mapping=aes(x=apparentTemperature, y=boarding)) + 
  geom_smooth(aes(x=apparentTemperature, y=boarding))

# try holding time constant by focusing on a few specific hours
ggplot(data=filter(capmetro, zone==362, hour==10)) + 
  geom_point(mapping=aes(x=apparentTemperature, y=boarding)) + 
  geom_smooth(aes(x=apparentTemperature, y=boarding))

ggplot(data=filter(capmetro, zone==362, hour==17)) + 
  geom_boxplot(mapping=aes(x=precipYes, y=boarding))


###
# Model-building: focus here on zone=362
# Note: this implicitly assumes an interaction between zone and all other features
###

capmetro362 = filter(capmetro, zone==362)

# training and testing sets
n = nrow(capmetro362)
n_train = floor(0.8*n)
n_test = n - n_train
train_cases = sample.int(n, size=n_train, replace=FALSE)

capmetro362_train = capmetro362[train_cases,]
capmetro362_test = capmetro362[-train_cases,]

y_all = capmetro362$boarding
x_all = model.matrix(~day + temperature + min_of_day + precipYes + inSemester, data=capmetro362)

y_train = y_all[train_cases]
x_train = x_all[train_cases,]

y_test = y_all[-train_cases]
x_test = x_all[-train_cases,]

# fit the RF model with default parameter settings
forest1 = randomForest(x=x_train, y=y_train, xtest=x_test)


yhat_test = (forest1$test)$predicted

forest1 = randomForest(boarding ~ day + temperature + min_of_day + precipYes + inSemester, data=capmetro362_train)
yhat_test = predict(forest1, capmetro362_test)

plot(yhat_test, y_test)

# RMSE
(yhat_test - y_test)^2 %>% mean %>% sqrt

# performance as a function of iteration number
plot(forest1)

# a variable importance plot: how much SSE decreases from including each var
varImpPlot(forest1)


####
# Exploring the fit with partial dependence functions
####

p1 = pdp::partial(forest1, pred.var = 'min_of_day')
p1
plot(p1)

p2 = pdp::partial(forest1, pred.var = 'day')
p2
plot(p2)


p3 = pdp::partial(forest1, pred.var = 'precipYes')
p3

p4 = pdp::partial(forest1, pred.var = 'temperature')
p4
plot(p4)

p5 = pdp::partial(forest1, pred.var = c('min_of_day', 'day', 'inSemester'))
p5

# This is nice when you want to look at interactions
ggplot(p5) + geom_point(mapping=aes(x=min_of_day, y=yhat)) + 
  facet_grid(inSemester~day)

