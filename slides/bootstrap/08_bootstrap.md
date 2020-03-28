The bootstrap  
========================================================
author: SDS 323
date: James Scott  
autosize: true
font-family: 'Gill Sans'
transition: none  



<style>
.small-code pre code {
  font-size: 1em;
}
</style>



Reference: _Data Science: A Gentle Introduction_ Chapter 5; _Statistical Learning_ Ch 5.2  


Outline
========

- Sampling distributions  
- Bias and standard error  
- The bootstrap  
- Bootstrapped confidence intervals  

***

- Bootstrapped versus plug-in standard errors  
- Application: the bootstrap in supervised learning   
- Application: bootstrapping for risk estimation  



Quantifying uncertainty
========

From the New England Journal of Medicine in 2006:

> We randomly assigned patients with resectable adenocarcinoma of the stomach, esophagogastric junction, or lower esophagus to either perioperative chemotherapy and surgery (250 patients) or surgery alone (253 patients)....  With a median follow-up of four years, 149 patients in the perioperative-chemotherapy group and 170 in the surgery group had died. As compared with the surgery group, the perioperative-chemotherapy group had a higher likelihood of overall survival (five-year survival rate, 36 percent vs. 23 percent).
 

Quantifying uncertainty
========

Conclusion: 
- Chemotherapy patients are __13%__ more likely to survive past 5 years.    




Quantifying uncertainty
========

Conclusion: 
- Chemotherapy patients are __13%__ more likely to survive past 5 years.    

Not so fast!  In statistics, we ask "what if?" a lot:  
- What if the randomization of patients just happened, by chance, to assign more of the healthier patients to the chemo group?  
- Or what if the physicians running the trial had enrolled a different sample of patients from the same clinical population?    



Quantifying uncertainty
========

Conclusion: 
- Chemotherapy patients are __13%__ more likely to survive past 5 years.    

Always remember two basic facts about samples:    
- _All numbers are wrong_: any quantity derived from a sample is just a _guess_ of the corresponding population-level quantity.    
- _A guess is useless without an error bar_: an estimate of how wrong we expect the guess to be.  


Quantifying uncertainty
========

Conclusion: 
- Chemotherapy patients are __13% $\pm$ ?__ more likely to survive past 5 years, with __??%__ confidence.  

By "quantifying uncertainty" or "statistical inference," we mean filling in the blanks.  



Quantifying uncertainty
========

In stats, we equate trustworthiness with _stability_:
- If our data had been different merely due to chance, would our answer have been different, too?
- Or would the answer have been stable, even with different data?  

$$
\begin{array}{r}
\mbox{Confidence in} \\
\mbox{your estimates} \\
\end{array}
\iff
\begin{array}{l}
\mbox{Stability of those estimates} \\
\mbox{under the influence of chance} \\
\end{array}
$$

To assess stability, you have to contemplate the possibility of __alternate data universes.__  

Quantifying uncertainty
========

For example: 
- If doctors had taken a different sample of 503 cancer patients and gotten a drastically different estimate of the new treatment's effect, then the original estimate isn't very trustworthy.
- If, on the other hand, pretty much any sample of 503 patients would have led to the same estimates, then their answer for _this particular_ subset of 503 is probably accurate.  


Let's work through a thought experiment... 

Kolmorogov goes fishing...
========

<img src="fig/man_fishing.jpeg" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="800px" style="display: block; margin: auto;" />


Kolmorogov goes fishing...
========

Imagine Andrey Kolmorogov on four-day fishing trip.
- The lake is home to a very large population of fish of varying size and weight.  
- On each day, Kolmorogov takes a random sample of size $N=15$ from this population---that is, he catches (and releases) 15 fish.  
- He records the weight and approximate volume of each fish.  
- He uses each day's catch to compute a different estimate of the volume--weight relationship for __all__ fish in the lake.  


Kolmorogov goes fishing...
========

<img src="fig/fishingtrips.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="850px" style="display: block; margin: auto;" />


Kolmorogov goes fishing...
========

<img src="fig/fishingtrips2.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="850px" style="display: block; margin: auto;" />



Kolmorogov goes fishing...
========

At right we see the _sampling distribution_ for both $\beta_0$ and $\beta_1$.  
- Each is centered on the true population value.  
- The spread of each histogram tells us how _variable_ our estimates are from one sample to the next.  

***

<img src="fig/fishingtrips3.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="325px" style="display: block; margin: auto;" />


Some notation
========

Suppose we are trying to estimate some population-level quantity $\theta$: the _parameter_ of interest.  

So we take a sample from the population: $X_1, X_2, \ldots, X_N$.  

We use the data to form an estimate $\hat{\theta}_N$ of the parameter.  Key insight: $\hat{\theta}_N$ is a random variable.


Some notation
========

Suppose we are trying to estimate some population-level quantity $\theta$: the _parameter_ of interest.  

So we take a sample from the population: $X_1, X_2, \ldots, X_N$.  

We use the data to form an estimate $\hat{\theta}_N$ of the parameter.  Key insight: $\hat{\theta}_N$ is a random variable.

__Now imagine repeating this process thousands of times!__  Since $\hat{\theta}_N$ is a random variable, it has a probability distribution.  


Some notation
========

<img src="fig/samplingdistribution_schematic.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="625px" style="display: block; margin: auto;" />


Key definitions
========

__Estimator__: any method for estimating the value of a parameter (e.g. sample mean, sample proportion, slope of OLS line, etc).    

__Sampling distribution__: the probability distribution of an estimator $\hat{\theta}_N$ under repeated samples of size $N$.  

__Bias__:  Let $\bar{\theta}_N = E(\hat{\theta}_N)$ be the mean of the sampling distribution.  The bias of $\hat{\theta}_N$ is $(\bar{\theta}_N - \theta)$: the difference between the average answer and the truth.  

__Unbiased estimator__: $(\bar{\theta}_N - \theta) = 0$.


Standard error
========

__Standard error__: the standard deviation of an estimator's sampling distribution:

$$
\begin{aligned}
\mbox{se}(\hat{\theta}_N) &= \sqrt{ \mbox{var}(\hat{\theta}_N) } \\
&= \sqrt{ E[ (\hat{\theta}_N - \bar{\theta}_N )^2]  } \\
&= \mbox{Typical deviation of $\hat{\theta}_N$ from its average} 
\end{aligned}
$$

"If I were to take repeated samples from the population and use this estimator for every sample, how much does the answer vary, on average?"  


Standard error
========

If an estimator is unbiased, then $\bar{\theta}_N = \theta$, so

$$
\begin{aligned}
\mbox{se}(\hat{\theta}_N) &= \sqrt{ E[ (\hat{\theta}_N - \bar{\theta}_N )^2]  } \\
&= \sqrt{ E[ (\hat{\theta}_N - \theta )^2]  } \\
&= \mbox{Typical deviation of $\hat{\theta}_N$ from the truth} 
\end{aligned}
$$


"If I were to take repeated samples from the population and use this estimator for every sample, how big of an error do I make, on average?"  


An analogy
========

<img src="fig/farmhouse_fever.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" width="700px" style="display: block; margin: auto;" />



An analogy
========

<img src="fig/gaines.jpeg" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="700px" style="display: block; margin: auto;" />

<a href="https://www.youtube.com/watch?v=6-4c6UZDjfc" target="_blank">This is why doctors and lawyers are buying "farmhouses."</a>




An analogy
========

<!-- [Chip and Joanna lifestyle item #1: the farmhouse sink](https://youtu.be/tdaq3vEJlj0?t=146) -->

<a href="https://youtu.be/tdaq3vEJlj0?t=146" target="_blank">Chip and Joanna lifestyle item #1: the farmhouse sink</a>


<img src="fig/sink.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" width="400px" style="display: block; margin: auto;" />



The farmhouse idyll...
========

<img src="fig/shaws.jpg" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="900px" style="display: block; margin: auto;" />


And the fine print
========

<img src="fig/fineprint.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" width="900px" style="display: block; margin: auto;" />


Manufacturing tolerances
========

- On average across many weeks of manufacturing, the fancy sink has width equal to 30".  
- But individual sinks vary from the average by about 0.5", due to manufacturing variability.  
- So I expect that my specific sink will be somewhere in the vicinity of 30" $\pm$ 0.5".  

Don't make any lifestyle choices that require greater precision!  



Standard errors
========

- On average across many samples, my estimator $\hat{\theta}_N$ is equal to the right answer ($\theta$).   
- But individual estimates vary from the average by about $\mbox{se}(\hat{\theta}_N)$, due to sampling variability.    
- So I expect that the right answer is somewhere in the vicinity of $\hat{\theta}_N \pm \mbox{se}(\hat{\theta}_N)$.  

Don't reach any scientific conclusions that require greater precision!  




Standard errors
========

But there's a problem here...
- Knowing the standard error requires knowing what happens across many separate samples.  
- But we've only got our one sample!  
- So how can we ever calculate the standard error?  


Standard errors
========

> Two roads diverged in a yellow wood  
> And sorry I could not travel both  
> And be one traveler, long I stood  
> And looked down one as far as I could  
> To where it bent in the undergrowth...  
>  
> --Robert Frost, _The Road Not Taken_, 1916  


Quantifying our uncertainty would seem to require knowing all the roads not taken---an impossible task.


The bootstrap
========

Problem: we can't take repeated samples of size $N$ from the population, to see how our estimate changes across samples.  

Seemingly hacky solution: take repeated samples of size $N$, with replacement, _from the sample itself_, and see how our estimate changes across samples.   This is something we can easily simulate on a computer.  

Basically, we pretend that our sample is the whole population and we charge ahead!  This is called _bootstrap resampling_, or just _bootstrapping._  



Sampling with replacement is key!
========

Bootstrapped sample 1

<img src="fig/boot1.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" width="550px" style="display: block; margin: auto;" />

Sampling with replacement is key!
========

Bootstrapped sample 2

<img src="fig/boot2.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" width="550px" style="display: block; margin: auto;" />

Sampling with replacement is key!
========

Bootstrapped sample 3

<img src="fig/boot3.png" title="plot of chunk unnamed-chunk-13" alt="plot of chunk unnamed-chunk-13" width="550px" style="display: block; margin: auto;" />


The true sampling distribution
========

<img src="fig/samplingdistribution_schematic.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" width="625px" style="display: block; margin: auto;" />

The bootstrapped sampling distribution
========

<img src="fig/bootstrapping_schematic.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" width="625px" style="display: block; margin: auto;" />


The bootstrapped sampling distribution
========

- Each bootstrapped sample has its own pattern of duplicates and omissions from the original sample.  
- These duplicates and omissions create variability in $\hat{\theta}$ from one bootstrapped sample to the next.  
- This variability mimics the _true_ sampling variability you'd expect to see across real repeated samples from the population.  


Bootstrapping: pseudo-code
========

- Start with your original sample $S = \{X_1, \ldots, X_N\}$ and original estimate $\hat{\theta}_N$.

- For $b=1,...,B$:  
  1. Take a bootstrapped sample $S^{(b)} = \{ X_1^{(b)}, \ldots, X_N^{(b)} \}$  
  2. Use $S^{(b)}$ to re-form the estimate $\hat{\theta}_N^{(b)}$.

- Result: a set of $B$ different estimates $\hat{\theta}_N^{(1)}, \hat{\theta}_N^{(b)}, \ldots, \hat{\theta}_N^{(B)}$ that approximate the sampling distribution of $\hat{\theta}_N$. 



Then what?
========

Calculate the _bootstrapped standard error_ as the standard deviation of the bootstrapped estimates:  

$$
\hat{se}(\hat{\theta}_N) = \mbox{std dev}\left( \hat{\theta}_N^{(1)}, \hat{\theta}_N^{(b)}, \ldots, \hat{\theta}_N^{(B)} \right)
$$

This isn't the true standard error, but it's often a good approximation!  

Example
========
type: prompt

Let's dig in to some R code and data: `creatinine_bootstrap.R` and `creatinine.csv`  (both on class website).  

We'll bootstrap two estimators:  
- the sample mean  
- the OLS estimate of a slope  



Confidence intervals
========

Informally, an interval estimate is a range of plausible values for the parameter of interest.  For example:  

- Go out some multiple $k$ of the bootstrapped standard error from your estimate:  

$$
\theta \in \hat{\theta}_N \pm k \cdot \hat{se} (\hat{\theta}_N)
$$

- Use the quantiles (e.g. the 2.5 and 97.5 percentiles) of the bootstrapped sampling distribution, to cover a large fraction (e.g. 95%) of the bootstrapped estimates:

$$
\theta \in (q_{2.5}, q_{97.5})
$$



Confidence intervals
========

We'd like to be able to associate a _confidence level_ with an interval estimate like this.  How?  

If an interval estimate satisfies the _frequentist coverage principle_, we call it a confidence interval:

> Frequentist coverage principle: If you were to analyze one data set after another for the rest of your life, and you were to quote X% confidence intervals for every estimate you made, those intervals should cover their corresponding true values at least X% of the time.  Here X can be any number between 0 and 100.


Confidence intervals
========

An interval estimate takes the form $\hat{I}_N = [\hat{L}_N, \hat{U}_N]$.  Just like a point estimate $\hat{\theta}_N$, the interval estimate is a random variable, because its endpoints are functions of a random sample.  

We say that $[\hat{L}_N, \hat{U}_N]$ is a confidence interval at __coverage level__ $1-\alpha$ if, for every $\theta$,  

$$
P_{\theta} \left( \theta \in [\hat{L}_N, \hat{U}_N] \right) \geq 1- \alpha \, ,
$$

where $P_{\theta}$ is the probability distribution of the data, assuming that the true parameter is equal to $\theta$.  


Confidence intervals
========

The key statement here can be one of the most confusing in all of statistics:

$$
P_{\theta} \left( \theta \in [\hat{L}_N, \hat{U}_N] \right) \geq 1- \alpha \, ,
$$

Three questions to ask yourself:  
- What is fixed?  
- What is random?  
- What is the source of this randomness?  


Bootstrapped confidence intervals
========

So recall our two methods of generating an interval estimate using the bootstrap:  
- The standard error method: $\theta \in \hat{\theta}_N \pm z^{\star} \cdot \hat{se} (\hat{\theta}_N)$, where $z^{\star}$ is a pre-specified quantile of the normal distribution.  
- The quantile method (e.g. the 2.5 and 97.5 percentiles of the bootstrapped sampling distribution)  

The obvious question is: do these interval estimates satisfy the frequentist coverage principle?  


Bootstrapped confidence intervals
========

The answer is: not always, but often!  

In lots of common situations, both forms of bootstrapped interval estimate _approximately_ satisfy the coverage requirement:  

$$
P_{\theta} \left( \theta \in [\hat{L}_N, \hat{U}_N] \right) \approx 1- \alpha \, ,
$$

And the approximation gets better with larger sample sizes.  That is, as $N$ gets large,

$$
P_{\theta} \left( \theta \in [\hat{L}_N, \hat{U}_N] \right) \to 1-\alpha
$$

Bootstrapped confidence intervals
========

The math here is super hairy; we won't go into it.  (Google "empirical process theory" if want to learn and you've got a year or two to spare...)

But we can run a sanity check through Monte Carlo simulation!

Let's revisit our thought experiment about fishing...


Bootstrapped confidence intervals
========

<img src="fig/fishingtrips.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="850px" style="display: block; margin: auto;" />

Bootstrapped confidence intervals
========

Let's go on a 100 fishing trips.  On each trip:
- we catch a sample of $N=30$ fish  
- we run OLS on our sample to estimate $\beta_1$: the slope of the weight-vs.-volume line  
- we bootstrap our sample to get a 80% confidence interval for the slope.  


Bootstrapped confidence intervals
========


<img src="fig/bootstrap-confidence.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" width="900px" style="display: block; margin: auto;" />

Because we know the slope of the true line ($\beta_1 = 4.25$), we can check whether each bootstrapped confidence interval contains the true value.  About 80% of them should!


Bootstrapped confidence intervals
========

<img src="fig/bootstrap-coverage-landscape.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="950px" style="display: block; margin: auto;" />

- 100 different samples
- 100 different 80% confidence intervals 
- 83 of them cover the truth---pretty good!  



Plug-in standard errors  
========

Sometimes we can use probability theory to calculate a "plug-in" estimate of an estimator's standard error.  Some simple cases include:  
- means and differences of means  
- proportions and differences of proportions  

Let's see an example and compare the result with a bootstrap estimate of the standard error.  


Plug-in standard errors
========

Suppose that $X_1, X_2, \ldots, X_N$ are a sample of independent, identically distributed (IID) random variables with unknown mean $\mu$ and variance $\sigma^2$.  Let $\bar{X}_N$ be the sample mean:

$$
\bar{X}_N = \frac{1}{N} \sum_{i=1}^N X_i
$$


Clearly $\bar{X}_N$ is a sensible estimate of $\mu$, since it is unbiased: $E(\bar{X}_N) = \mu$ (show this!)  



Plug-in standard errors
========

We can also calculate the theoretical variance of $\bar{X}_N$ as:  

$$
\begin{aligned}
\mbox{var}(\bar{X}_N) = \mbox{var} \left( \frac{1}{N} \sum_{i=1}^N X_i \right) 
& = \frac{1}{N^2} \mbox{var} \left( \sum_{i=1}^N X_i \right) \\ 
&= \frac{1}{N^2} N \sigma^2 \\ 
&= \frac{\sigma^2}{N} 
\end{aligned}  
$$


Plug-in standard errors
========

This tells us that the _true standard error_ of the sample mean is:  

$$
\mbox{se}(\bar{X}_N) = \frac{\sigma}{\sqrt{N}}
$$

Or in words:

$$
\small
\mbox{Average error of the sample mean} = \frac {\mbox{Average error of a single measurement}} { \mbox{Square root of sample size} }
$$

This is sometimes called de Moivre's equation, after Abraham de Moivre.  


Plug-in standard errors
========

There's only one problem with de Moivre's equation: we don't know the true $\sigma$!

$$
\mbox{se}(\bar{X}_N) = \frac{\sigma}{\sqrt{N}}
$$

The obvious solution is to estimate $\sigma$ from the data.  This results in the so-called "plug-in" estimate of the standard error:  

$$
\hat{se}(\bar{X}_N) = \frac{\hat{\sigma}}{\sqrt{N}}
$$

where $\hat{\sigma}$ is an estimate of the population standard deviation (e.g. the sample standard deviation).  


Plug-in standard errors
========

Suppose we have an estimator $\hat{\theta}_N$ and we want to know its standard error.  The general plug-in procedure involves three steps:  
  1. Use probability theory to derive an expression for the _true standard error_ $\mbox{se}(\hat{\theta}_N)$.  
  2. Use the data to estimate any unknown population parameters $\phi$ that appear in the expression for $\mbox{se}(\hat{\theta}_N)$.  (Note: this might even include $\theta$, the parameter of interest itself.)
  3. Plug in the estimate $\hat{\phi}$ into this expression to yield the plug-in standard error, $\hat{se}(\hat{\theta}_N)$

Let's see an example in `predimed_plugin.R`.  



Summary
========

- Any estimator $\hat{\theta}_N$ is a random variable.  
- Its probability distribution is called the _sampling distribution._  
- The sampling distribution describes the results of a thought experiment: _what if_ we took lots and lots of samples, each of size $N$, and tracked how much our estimate changed?  


Summary
========

- The _standard error_ is the standard deviation of the sampling distribution.  
- Roughly speaking, it answers the question: how far off do I expect my estimate to be from the truth?  
- A practical way of estimating the standard error is by _bootstrapping_: repeatedly re-sampling with replacement from the original sample, and re-calculating the estimate each time.  
- In simple cases we can also calculate a _plug-in_ estimate of the standard error, using probability theory together with sample estimates of unknown parameters. 

Summary
========

- From the bootstrapped sampling distribution, we can get an interval estimate for the parameter of interest (using the standard-error method or the quantile method).  
- Both methods approximately satisfy the frequentist coverage principle: under repeated sampling, they contain the true value roughly the correct percentage of the time.  
- I tend to use the quantile method because it's pretty intuitive!  



The bootstrap in supervised learning
=============  

__Let's turn back to supervised learning!__ 

So we believe that $y_i = f(x_i) + \epsilon_i$, we've collected some data, and we have our estimate $\hat{f}(x)$... How can we quantify our uncertainty for this estimate?  

Fundamental frequentist thought experiment: "How might $\hat{f}(x)$ have been different in an alternate data universe?"    

The bootstrap in supervised learning
=============  

But what does "alternate data universe" actually mean?  
- a different sample (of size $N$) of $(x_i, y_i)$ pairs from the same population?  
- a different set of residuals?  
- a different realization of the same underlying random process/phenomenon?  

The bootstrap
=============  

There's a version the bootstrap for all three situations:  
- a different sample (of size $N$) of $(x_i, y_i)$ pairs from the same population?    __The nonparametric bootstrap__: pretty much example what we've already seen.  
- a different set of residuals?  __The residual-resampling bootstrap__  
- a different realization of the same underlying random process/phenomenon?  __The parametric bootstrap__  

Let's see all three versions of the bootstrap one by one.  


The nonparametric bootstrap
=============  

If you've seen the bootstrap before, it was probably this one!  

- Question: "how might my estimate $\hat{f}(x)$ have been different if I'd seen a different sample of $(x_i, y_i)$ pairs from the same population?"  
- Assumption: each $(x_i, y_i)$ is a random sample from a joint distribution $P(x, y)$ describing the population from which your sample was drawn.  
- Problem: We don't know $P(x, y)$.  
- Solution: Approximate $P(x, y)$ by $\hat{P}(x, y)$, the empirical joint distribution of the data in your sample.  
- Key fact for implementation: sampling from $\hat{P}(x, y)$ is equivalent to sampling with replacement from the original sample.  


The nonparametric bootstrap
=============  

This leads to the following algorithm.  

For b = 1 to B:
- Construct a sample from $\hat{P}(x, y)$ (called a _bootstrapped sample_) by sampling $N$ pairs $(x_i, y_i)$ _with replacement_ from the original sample.  
- Refit the model to each bootstrapped sample, giving you $\hat{f}^{(b)}$.  

This gives us $B$ draws from the bootstrapped sampling distribution of $\hat{f}(x)$.  

Use these draws to form (approximate) confidence intervals and standard errors for $f(x)$.  

An example
=============  
class: small-code


```r
library(tidyverse)
loadhou = read.csv('../data/loadhou.csv')

ggplot(loadhou) + geom_point(aes(x=KHOU, y=COAST), alpha=0.1) + 
  theme_set(theme_bw(base_size=18)) 
```

<img src="08_bootstrap-figure/unnamed-chunk-19-1.png" title="plot of chunk unnamed-chunk-19" alt="plot of chunk unnamed-chunk-19" style="display: block; margin: auto;" />


An example
=============  
class: small-code

Suppose we want to know $f(5)$ and $f(25)$, i.e. the expected values of `COAST` when `KHOU = 5` and `KHOU = 25`, respectively.  Let's bootstrap a KNN model, with $K=40$:  


```r
library(mosaic)
library(FNN)

X_test = data.frame(KHOU=c(5,25))
boot20 = do(500)*{
  loadhou_boot = resample(loadhou)  # construct a boostrap sample
  X_boot = select(loadhou_boot, KHOU)
  y_boot = select(loadhou_boot, COAST)
  knn20_boot = knn.reg(X_boot, X_test, y_boot, k=40)
  knn20_boot$pred
}
head(boot20, 3)  # first column is f(5), second is f(25)  
```

```
        V1       V2
1 10708.95 11882.67
2 10802.91 11997.82
3 10513.39 11812.59
```

An example
=============  
class: small-code
 
Now we can calculate standard errors and/or confidence intervals.  

- Standard errors: take the standard deviation of each column.  

```r
se_hat = apply(boot20, 2, sd)
se_hat
```

```
      V1       V2 
172.5259 156.6715 
```

- Confidence intervals: calculate quantiles for each column

```r
apply(boot20, 2, quantile, probs=c(0.025, 0.975))  
```

```
            V1       V2
2.5%  10283.88 11532.70
97.5% 10974.92 12125.45
```

An example
=============  
class: small-code

- Shortcut: 

```r
confint(boot20)
```

```
  name    lower    upper level     method estimate
1   V1 10283.88 10974.92  0.95 percentile 10638.78
2   V2 11532.70 12125.45  0.95 percentile 11906.23
```

Spaghetti plot: using base R graphics  
=============  
class: small-code  


```r
X_test = data.frame(KHOU=seq(0, 35, by=0.1))
plot(COAST ~ KHOU, data=loadhou)
for(i in 1:500) {
  loadhou_boot = resample(loadhou)  # construct a boostrap sample
  X_boot = select(loadhou_boot, KHOU)
  y_boot = select(loadhou_boot, COAST)
  knn20_boot = knn.reg(X_boot, X_test, y_boot, k=40)
  knn20_boot$pred
  lines(X_test$KHOU,  knn20_boot$pred, col=rgb(1, 0, 0, 0.1))
}
```

<img src="08_bootstrap-figure/unnamed-chunk-24-1.png" title="plot of chunk unnamed-chunk-24" alt="plot of chunk unnamed-chunk-24" style="display: block; margin: auto;" />


The residual-resampling bootstrap
=============  

- Question: "how might my estimate $\hat{f}(x)$ have been different if the error terms/residuals had been different?"  
- Assumption: each residual $e_i$ is a random sample from a probability distribution $P(e)$ describing the noise in your data set.      
- Problem: We don't know $P(e)$.  
- Solution: Approximate $P(e)$ by $\hat{P}(e)$, the empirical distribution of the residuals from your fitted model.     
- Key fact for implementation: sampling from $\hat{P}(e)$ is equivalent to sampling with replacement from residuals of your fitted model.  


The residual-resampling bootstrap  
=============  

This leads to the following algorithm.  First fit the model, yielding
$$
y_i = \hat{f}(x_i) + e_i
$$

Then, for b = 1 to B:
- Construct a sample from $\hat{P}(e)$ by sampling $N$ residuals $e^{(b)}_i$ _with replacement_ from the original residuals $e_1, \ldots, e_N$.  
- Construct synthetic outcomes $y_i^{(b)}$ by setting 
$$
y_i^{(b)} = \hat{f}(x_i) + e^{(b)}_i
$$
- Refit the model to the $(x_i, y_i^{(b)})$ pairs, yielding $\hat{f}^{(b)}$.  


An example
=============  
class: small-code


```r
ethanol = read.csv('ethanol.csv')
ggplot(ethanol) + geom_point(aes(x=E, y=NOx)) + 
  theme_set(theme_bw(base_size=18)) 
```

<img src="08_bootstrap-figure/unnamed-chunk-25-1.png" title="plot of chunk unnamed-chunk-25" alt="plot of chunk unnamed-chunk-25" style="display: block; margin: auto;" />

Key fact: the $(x_i, y_i)$ are not random samples here! _The $x_i$ points are fixed as part of the experimental design._  


An example
=============  
class: small-code

Let's quantify uncertainty for $f(0.7)$ and $f(0.95)$, under 5th-order polynomial model, via the residual resampling bootstrap.  

First, let's look at the empirical distribution of the residuals:  

```r
poly5 = lm(NOx ~ poly(E, 5), data=ethanol)
yhat = fitted(poly5)
evector = ethanol$NOx - yhat  # empirical distribution of residuals
```

An example
=============  
class: small-code


```r
hist(evector, 20)
```

<img src="08_bootstrap-figure/unnamed-chunk-27-1.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" style="display: block; margin: auto;" />

This is our estimate $\hat{P}(e)$ for the probability distribution of the residuals.  



An example
=============  
class: small-code

Now we bootstrap:  

```r
X_test = data.frame(E=c(0.7, 0.95))
boot5 = do(500)*{
  e_boot = resample(evector)
  y_boot = yhat + e_boot  # construct synthetic outcomes
  ethanol_boot = ethanol
  ethanol_boot$NOx = y_boot  # substitute real outcomes with synthetic ones
  poly5_boot = lm(NOx ~ poly(E, 5), data=ethanol_boot)
  fhat_boot = predict(poly5_boot, X_test)
  fhat_boot
}
head(boot5, 3)  # first column is f(0.7), second is f(0.95)  
```

```
        X1       X2
1 1.479639 3.634581
2 1.576081 3.536532
3 1.506203 3.615962
```


An example
=============  
class: small-code

As before, we can get standard errors and/or confidence intervals.  

- Standard errors:  

```r
se_hat = apply(boot5, 2, sd)
se_hat
```

```
        X1         X2 
0.07574009 0.07527173 
```

- Confidence intervals: calculate quantiles for each column  

```r
apply(boot5, 2, quantile, probs=c(0.025, 0.975))  
```

```
            X1       X2
2.5%  1.359714 3.390013
97.5% 1.653690 3.688565
```


The parametric bootstrap
=============  

- Question: "how might my estimate $\hat{f}(x)$ have been different if my outcomes were a different realization from the same underlying conditional distribution $P(y_i \mid x_i)$?  
- Assumption: each outcome $y_i$ is a random sample from a conditional probability distribution $P(y \mid x)$.    
- Problem: We don't know $P(y \mid x)$.  
- Solution: Approximate $P(y \mid x)$ by $\hat{P}(y \mid x)$, the family of conditional distributions estimated from your sample.  
- Key fact for implementation: $\hat{P}(y \mid x)$ is a parametric probability model parametrized by $\hat{f}(x)$, the fitted function.  


The parametric bootstrap
=============  

Solution: simulate hypothetical ``alternative data universes'' from a parametric model fitted to your data.  

Example: see `predimed_bootstrap.R`    




Bootstrapping for risk estimation
========

Suppose that you're trying to construct a portfolio: that is, to decide how to allocate your wealth among $D$ financial assets.  Things you want might to track include:
- the expected value of your portfolio at some point in the future (e.g. when you retire).  
- the variance of your portfolio's value at some point in the future.  
- the probability of losing some specific amount of money (10K, 20% of total value, etc)  
- some measure of "tail risk," i.e. what a bad week/month/year might look like.  

Key idea: __use the bootstrap to simulate portfolio performance.__  (See portfolio.R)


Bootstrapping for risk estimation
========

Notation:  

- Let $T$ be our investing horizon (e.g. T = 20 days, T = 40 years, etc), and let $t$ index discrete time steps along the way.  

- Let $X_{t,j}$ be the value of asset $j = 1, \ldots, D$ at time period $t$.  

- Let $R_{t,j}$ be the _return_ of asset $j$ in period $t$, so that we have the following recursive update:  

$$
X_{t,j} = X_{t-1, j} \cdot (1 + R_{t,j})
$$


Bootstrapping for risk estimation
========

Notation:  
- A portfolio is a set of investment weights over assets: $(w_{t1}, w_{t2}, \ldots, w_{tD})$.  Note: these weights might be fixed, or they might change over time. 

- The value of your portfolio is the weighted sum of the value of your assets:  

$$
W_{t} = \sum_{j=1}^D w_{t,j} X_{t,j}
$$


Bootstrapping for risk estimation
========

We care about $W_T$: the random variable describing your terminal wealth after $T$ investment periods.

Problem: this random variable is a super-complicated, nonlinear function of $T \times D$ individual asset returns:

$$
W_T = f(R) \quad \mbox{where} \quad R = \{R_{t,j} : t = 1, \ldots, T; j = 1, \ldots, D\}
$$

Bootstrapping for risk estimation
========

If we knew the asset returns, we could evaluate this function recursively, starting with initial wealth $W_0$ at time $t=0$ and sweeping through time $t=T$:  

Starting with initial wealth $X^{(i)}_{1, j}$ in each asset, we sweep through from $t=1$ to $t=T$:  

$$
\begin{aligned}
X^{(f)}_{t, j} &= X^{(i)}_{t, j} \cdot (1 + R_{t,j}) &\quad \mbox{(Update each asset)}  \\
W_{t} &= \sum_{j=1}^D w_{t,j} X^{(f)}_{t,j}  &\quad \mbox{(Sum over assets)}  \\
X^{(i)}_{t+1,j} &= w_{t+1,j} \cdot W_{t}  &\quad \mbox{(Rebalance)}   \\
\end{aligned}
$$


Bootstrapping for risk estimation
========

But of course, we don't know the asset returns!  This suggests that we should use a Monte Carlo simulation, where we repeat the following `for` loop many times.  

For $t = 1, \ldots, T$:
  1. Simulate $R_t = (R_{t1}, R_{t2}, \ldots,  R_{tD})$ from the joint probability distribution of asset returns at time $t$.  
  2. Use these returns to update $X_{j,t}$, the value of your holdings in each asset at step $t$.
  3. Rebalance your portfolio to the target allocation.   

The precise math of the update and rebalance steps are on the previous slide.  


Bootstrapping for risk estimation
========

The difficult step here is (1): simulate a high-dimensional vector of asset returns from its joint probability distribution.  
- very complicated correlation structure  
- probably not something simple like a Gaussian!  

In general, using simple parametric probability models (e.g. multivariate Gaussian) to describe high-dimensional joint distributions is a very dicey proposition.  


A simple approach: bootstrap resampling  
========

Suppose we have $M$ past samples of the asset returns, stacked in a matrix:

$$
R = \left(
\begin{array}{r r r r}
R_{11} & R_{12} & \cdots & R_{1D} \\
R_{21} & R_{22} & \cdots & R_{2D} \\
\vdots & && \\
R_{M1} & R_{M2} & \cdots & R_{MD}
\end{array}
\right)
$$

where $R_{tj}$ is the return of asset $j$ in period $t$.  


A simple approach: bootstrap resampling  
========

The key idea of bootstrap resampling is the following:  
- We may not be able to describe what the joint distribution $P(R_1, \ldots, R_D)$ is.  
- But _we do know that every row of this $R$ matrix is a sample from this joint distribution._
- So instead of sampling from some theoretical joint distribution, we will sample from the sample---i.e. we will bootstrap the past data.  
- Thus every time we need a new draw from the joint distribution $P(R_1, \ldots, R_D)$, we randomly sample (with replacement) a single row of $R$.


A simple approach: bootstrap resampling  
========

Thus our Monte Carlo simulation looks like the following at each draw.

For $t = 1, \ldots, T$:
  1. Simulate $R_t = (R_{t1}, R_{t2}, \ldots,  R_{tD})$ by drawing a whole row, with replacement, from our matrix of past returns.  
  2. Use these returns to update $X_{j,t}$, the value of your holdings in each asset at step $t$.
  3. Rebalance your portfolio to the target allocation.   


Example
========

Let's go to the R code!  See `portfolio.R` on the website.  


Key discussion question
========
type: prompt

__Why do we draw an entire row of $R$ at a time?__

