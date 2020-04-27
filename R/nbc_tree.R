library(tidyverse)
library(ggplot2)
library(tree)

### *** data on tv shows from NBC *** ###

shows = read.csv("../data/nbc_showdetails.csv", row.names=1)
head(shows)


# tree model: predicted engagement
tree1 = tree(PE ~ Genre + GRP, data=shows)
summary(tree1)

plot(tree1)
text(tree1)