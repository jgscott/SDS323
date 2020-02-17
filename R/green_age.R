library(tidyverse)

greenbuildings = read.csv('../data/greenbuildings.csv')

# Step 1: identify possible confounders
# let's focus on age

# Step 2: check whether age is a plausible confounder.
# First, does age predict rent?
ggplot(greenbuildings) + 
  geom_point(aes(x=age, y=Rent))

# yes, about 5 cents per year less in rent
lm(Rent ~ age, data= greenbuildings)

# Next, are the ages different b/t green and non-green?
ggplot(greenbuildings) + 
  geom_histogram(aes(x=age, y=stat(density)), binwidth=2) + 
  facet_grid(green_rating~.)

# Yes!  
# Notice here we can see the whole distribution of ages
# important for recognizing the second group of older buildings
# that is largely missing among the green-rated buildings


# The truly excellent answer: try to hold age roughly constant

# easy way:
# define some age groupings
greenbuildings = mutate(greenbuildings, 
                        agecat= cut(age, c(0, 10, 20, 30, 50, 75, 200), include.lowest =TRUE))

# now compare rent within age groupings
summ1 = greenbuildings %>%
  group_by(agecat, green_rating) %>%
  summarize(mean_rent = mean(Rent), n = n())
summ1

summ1 %>% select(agecat, green_rating, mean_rent) %>%
  spread(green_rating, mean_rent)

# in bar plot form
ggplot(summ1) + 
  geom_col(aes(x=agecat, y=mean_rent, fill=factor(green_rating)), position='dodge')

# Note: comparison is much easier within categories this way, versus stacked bars!
ggplot(summ1) + 
  geom_col(aes(x=agecat, y=mean_rent, fill=factor(green_rating)), position='stack')

