# SDS 323: Statistical Learning and Inference  

Meets MW 3:00 - 4:30 on Zoom.  See Canvas for link.

[__March 2020 updates to our syllabus__](ref/SDS323_Spring2020_Syllabus_UpdateMarch2020.docx)


The team:  
- [James Scott](https://jgscott.github.io/), instructor.  Drop-in office hours MW 1:30 to 2:45, GDC 7.516.  
- Rimli Sengupta, teaching assistant.  Drop-in office hours T 11am - 1pm, GDC 2.410.  

Quick links:
- [Course syllabus](ref/SDS323_Spring2020_Syllabus.pdf)   
- [Exercises](exercises/)  


## Software

- Statistical computing: [R](http://www.r-project.org), which we will use via [RStudio](http://www.rstudio.com), a free, platform-independent graphical front-end for R.  Make sure you have both installed, along with the [RMarkdown package](http://rmarkdown.rstudio.com).   
- Other software: please [install Git and create a GitHub account](https://help.github.com/articles/set-up-git/), if you don't already have one.  You will use GitHub for version control and to submit your assignments.  

A great reference on R is Hadley Wickham's online reference, [R for Data Science](https://r4ds.had.co.nz/)  The whole set of materials is great, but chapters 3 through 7 are especially useful for our purposes in this class.  

## Readings

Readings will be drawn from two free online resources:  
- [_Introduction to Statistical Learning_](http://faculty.marshall.usc.edu/gareth-james/ISL/), by James, Witten, Hastie, and Tibshirani (free online).   I'll refer to it as "ISL" in the course outline.  
- [_Data Science: A Gentle Introduction_](ref/DataScience.pdf), some of my own course notes covering various topics in data analysis and regression.   
 

## Topics

I'll post topics for class below.  We'll go in order from this outline.  


### The data scientist's toolbox

Slides: [The data scientist's toolbox](slides/00_toolbox/00_datascience_toolbox.pdf)    

Good data-curation and data-analysis practices; R; Markdown and RMarkdown; the importance of replicable analyses; version control with Git and Github.

Readings:  
- [Getting starting with GitHub Desktop](https://help.github.com/en/desktop/getting-started-with-github-desktop)  
- [Introduction to RMarkdown](http://rmarkdown.rstudio.com) and [RMarkdown tutorial](https://rmarkdown.rstudio.com/lesson-1.html)  
- [Introduction to GitHub](https://guides.github.com/activities/hello-world/)   
- [Jeff Leek's guide to sharing data](https://github.com/jtleek/datasharing)  


### Probability + R: a warm-up

Slides: [Warm-up](slides/01_warmup/01_warmup.pdf), covering a bit of probability and a bit of R to get the semester going.  

R scripts and data sets:  
- [predimed_intro.R](R/predimed_intro.R) and [predimed.csv](data/predimed.csv)   


### Data exploration and visualization

Examples of [bad graphics](ref/badgraphics.pdf).  And [an example from the New York Times](https://www.nytimes.com/interactive/2018/08/30/climate/how-much-hotter-is-your-hometown.html).  

Slides: [Introduction to Data Exploration and Visualization](slides/02_intro_dataviz/02_intro_dataviz.pdf)    

R scripts and data:  
- [mpg.R](R/mpg.R)  
- [titanic.R](R/titanic.R) and [TitanicSurvival.csv](data/TitanicSurvival.csv)  
- [toyimports_linegraph.R](R/toyimports_linegraph.R) and [toyimports.csv](data/toyimports.csv)  


### Fitting equations to data

Slides: [Fitting equations](slides/03_fitting_equations/03_fitting_equations.pdf)  

Fitting straight lines by OLS; polynomial models; exponential and power-law models; intro to splines.  
  
R scripts and data:    
- [afc_intro.R](./R/afc_intro.R) and [afc.csv](data/afc.csv)
- [creatinine.csv](data/creatinine.csv)  
- [utilities.R](./R/utilities.R)  
- [race_splines.R](./R/race_splines.R)  
- [ebola.R](./R/ebola.R)


### Principles of statistical learning

[Slides here.](slides/04_intro_learning/04_intro_learning.pdf)  

Reading: Chapters 1-2 of "Introduction to Statistical Learning."

In class:  
- [loadhou.R](R/loadhou.R) and [loadhou.csv](data/loadhou.csv)   

<!-- - [spamtoy.R](R/spamtoy.r)  
- [spamfit.csv](data/spamfit.csv)   
- [spamtest.csv](data/spamtest.csv)   
 -->


### Linear models

[Slides here.](slides/05_linear_models/05_linear_models.pdf)  

Reading: Chapter 3 of "Introduction to Statistical Learning."

In class:  
- [oj.R](R/oj.R) and [oj.csv](data/oj.csv)   
- [saratoga_lm.R](R/saratoga_lm.R)  


### Classification

[Slides here.](slides/06-classification/06-classification.pdf)  

Reading: Chapter 4 of "Introduction to Statistical Learning."

In class:  
- [spamtoy.R](R/spam_toy.r)  
- [spamfit.csv](data/spamfit.csv) and [spamtest.csv](data/spamtest.csv)   
- [glass.R](R/glass.R)  
- [glass_mlr.R](R/glass_mlr.R)  
- [congress109_bayes.R](R/congress109_bayes.R)  
- [congress109.csv](data/congress109.csv)   
- [congress109members.csv](data/congress109members.csv)   


### Model selection and regularization  

[Slides here.](slides/07-selection_regularization/07-selection_regularization.pdf)

Reading: Chapter 5.1 and Chapter 6 of _Introduction to Statistical Learning_.  

R scripts:  
- [saratoga_step.R](R/saratoga_step.R)  
- [semiconductor.R](R/semiconductor.R) and [semiconductor.csv](data/semiconductor.csv)  
- [gft_train.csv](data/gft_train.csv) and [gft_test.csv](data/gft_test.csv).  The goal here is to imagine you work at the CDC: build a flu-prediction model using the training data (`cdcflu` is the outcome) and make predictions on the testing data.  


### Unsupervised learning: clustering    

[Slides here.](slides/08-clustering/08-clustering.pdf)  
Reading: chapter 10.3 of _Introduction to Statistical Learning_.

In class:  
- [cars.R](R/cars.R)  
- [hclust_examples.R](R/hclust_examples.R)  
- [linkage_minmax.R](R/linkage_minmax.R)  




<!--  ### The bootstrap

[Slides here.](slides/08_bootstrap/08_bootstrap.pdf)

Reading: Chapter 5 of "Data Science: A Gentle Introduction" and Chapter 5.2 of "Statistical Learning."  

In class:  
- [creatinine_bootstrap.R](R/creatinine_bootstrap.R)  
- [residual_resampling.R](R/residual_resampling.R)  
- [predimed_bootstrap.R](R/predimed_bootstrap.R)    
- [portfolio.R](R/portfolio.R)   
- [chymotrypsin.csv](data/chymotrypsin.csv)   
- [ethanol.csv](data/ethanol.csv)    
- [predimed.csv](data/predimed.csv)    


### Principal components analysis (PCA)

Slides: [Introduction to PCA](http://rpubs.com/jgscott/PCA)    

Reference: ISL Section 10.2 


Scripts and data:  
- [pca_intro.R](R/pca_intro.R)  
- [congress109.R](R/congress109.R), [congress109.csv](data/congress109.csv), and [congress109members.csv](data/congress109members.csv)  
- [NCI60.R](R/NCI60.R)  

If time:  
- [FXmonthly.R](R/FXmonthly.R), [FXmonthly.csv](data/FXmonthly.csv), and [currency_codes.txt](data/currency_codes.txt)    
- [gasoline.R](R/gasoline.R) and [gasoline.csv](data/gasoline.csv)   


### Trees

[Slides on trees](notes/trees.pdf).  

Reading: Chapter 8 of _Introduction to Statistical Learning_.
 -->

