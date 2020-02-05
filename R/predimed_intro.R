# Note: anything after the pound sign (#) is a comment
# and therefore won't be executed by the program.  

# load the mosaic and tidyverse libraries
# if you get an error: install them from the Packages tab
library(mosaic)
library(tidyverse)

# Load the data:
# Click the Import Dataset button under the Environment tab at right.
# Use it to import the data in predimed.csv
# Make sure that:
# - You use "From Text (base)"
# - You check "Yes" next to Heading

# Examine the first few lines of the data frame:
# Each row is a person, each column is a variable.
# variables like group, sex, and smoke are categorical.
# variables like age and bmi are numerical.
head(predimed)

# look at some "favorite stats" for the age variable
favstats(predimed$age)

# Let's get a summary for all the variables in the data set
summary(predimed)

# Make a table for event versus diet group
# xtabs means "cross tabulate" and the tilde (~) means "by"
# This says "cross-tabulate the predimed data by group and event" 
xtabs(~group + event, data=predimed)

# Use this table to estimate:
#  P(event | Control diet)
#  P(event | any MedDiet)  

# Note: for now you can calculate proportions by using R just like a calculator, e.g. 3/(3+7)
# Later, we'll use slicker commands and tidier syntax...
# Here's a preview:
d1 = predimed %>%
  group_by(group) %>%
  summarize(surv_pct = sum(event=='Yes')/n())
d1


# tables for multiple factors
xtabs(~sex + group + event, data=predimed)

# "flatten" the table by piping (%>%) the result to ftable
xtabs(~sex + group + event, data=predimed) %>% ftable

# Use this table to estimate:
#  P(event | Control diet, Male)
#  P(event | Control diet, Female)
#  P(event | Control diet, Male)
#  P(event | Control diet, Female)


# We'll leave open the question of whether this is a real difference
# or a "small sample" difference!  

# checking independence
xtabs(~group + event + sex, data=predimed)
xtabs(~sex + event + htn, data=predimed)


xtabs(~sex + event, data=predimed)
101/(101+3544)
151/(151+2528)
