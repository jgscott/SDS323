# SDS 323: Exercises 2


## KNN practice

The data in [sclass.csv](../data/sclass.csv) contains data on over 29,000 Mercedes S Class vehicles---essentially every such car in this class that was advertised on the secondary automobile market during 2014.  For websites like Cars.com or Truecar that aim to provide market-based pricing information to consumers, the Mercedes S class is a notoriously difficult case.  There is a huge range of sub-models that are all labeled "S Class,"" from large luxury sedans to high-performance sports cars; one sub-category of S class even serves as the official pace car in Formula 1 Races.  Moreover, individual submodels involve cars with many different features.  This extreme diversity---unusual for a single model of car---makes it difficult to provide accurate pricing predictions to consumers.

Let's focus on three variables in particular:
- trim: categorical variable for car's trim level, e.g. 350, 63 AMG, etc.  The trim is like a sub-model designation.  
- mileage: mileage on the car
- price: the sales price in dollars of the car

Your goal is to use K-nearest neighbors to build a predictive model for price, given mileage, separately for each of two trim levels: 350 and 65 AMG.  (There are lots of other trim levels that you'll be ignoring for this question.) That is, you'll be treating the 350's and the 65 AMG's as two separate data sets.  See [sclass.R](../r/sclass.R) for some code that extracts these two subsets from the full data set.

For each of these two trim levels:
1) Split the data into a training and a testing set.  
2) Run K-nearest-neighbors, for many different values of K, starting at K=2 and going as high as you need to. For each value of K, fit the model to the training set and make predictions on your test set.
3) Calculate the out-of-sample root mean-squared error (RMSE) for each value of K.

For each trim, make a plot of RMSE versus K, so that we can see where it bottoms out.  Then for the optimal value of K, show a plot of the fitted model.  (Again, separately for each of the two trim levels.)

Which trim yields a larger optimal value of K?  Why do you think this is?



## Saratoga house prices

Return to the data set on house prices in Saratoga, NY that we considered in class.  Recall that a starter script here is in `saratoga_lm.R`.  

- See if you can "hand-build" a model for price that outperforms the "medium" model that we considered in class.  Use any combination of transformations, polynomial terms, and interactions that you want.  Are there any variables or interactions that seem to be especially strong drivers of house prices?  
- Then see if you can turn this hand-built linear model into a better-performing KNN model.  Note: don't explicitly include interactions or polynomial terms in your KNN model.  The method is sufficiently adaptable to find them, if they are there.  However, if your linear model did include composite features (like sqft of house per acre of land, or something like that), then you _should_ include those in KNN.  Make sure to _standardize_ your variables before applying KNN, and make sure to include a plot of RMSE versus K.   

Write your report as if you were describing your price-modeling strategies for a local taxing authority, who needs to form predicted market values for properties in order to know how much to tax them.  Keep the focus on the conclusions and model performance, rather than on the technical details.  

Note: When measuring out-of-sample performance, there is _random variation_ due to the particular choice of data points that end up in your train/test split.  Make sure your script addresses this by averaging the estimate of out-of-sample RMSE over many different random train/test splits.   



## Predicting when articles go viral

The data in [online_news.csv](../data/online_news.csv) contains data on 39,797 online rticles published by Mashable during 2013 and 2014.  The target variable is `shares`, i.e. how many times the article was shared on social media.  The other variables are article-level features: things like how long the headline is, how long the article is, how positive or negative the "sentiment" of the article was, and so on.  The full list of features is in [online_news_codes.txt](../data/online_news_codes.txt).  

Mashable is interested in building a model for whether the article goes viral or not.  They judge this on the basis of a cutoff of 1400 shares -- that is, the article is judged to be "viral" if shares > 1400.  (This cutoff is somewhat but not entirely arbitrary, because it ultimately has to do with pricing for any ads that appear next to those articles.)  Mashable wants to know if there's anything they can learn about how to improve an article's chance of reaching this threshold.  (E.g. by telling people to write shorter headlines, snarkier articles, or whatever.)  

First approach this problem from the standpoint of regression.  That is, try building your best model for `shares`, or perhaps some transformation of `shares`, using any tools you know (linear modeling, KNN, etc).  To assess the performance of your model on a test set, you should _threshold_ the model's predictions:
- if predicted shares exceeds 1400, predict the article as "viral"
- if predicted shares are 1400 or lower, predict the article as "not viral"

Then compare the predicted viral status with whether the actual test article exceeded 1400 shares.  Note that while the predictions of your model are numerical (shares), the ultimate evaluation is in terms of a binary prediction (shares > 1400).  Report the confusion matrix, overall error rate, true positive rate, and false positive rate for your best model.  Make sure to average these quantities across multiple train/test splits.  How do these numbers compare with a reasonable baseline or "null" model (such as the model which always predicts "not viral")?  

As a second pass, approach this problem from the standpoint of classification.  That is, define a new variable `viral = ifelse(shares > 1400, 1, 0)` and build your very best model for directly predicting viral status as a target variable.  As above, report the confusion matrix, overall error rate, true positive rate, and false positive rate for your best model.  Make sure to average these quantities across multiple train/test splits. 

Which approach performs better: regress first and threshold second, or threshold first and regress/classify second?  Why do you think this is?

Note: don't use the `url` variable as a predictor; it's there for reference only, although you can definitely waste a lot of time reading them all!  


