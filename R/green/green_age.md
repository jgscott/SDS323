### Age, rent, and green buildings

The first question to address is whether green buildings are actually
newer, on average.

    library(tidyverse)

    ## ── Attaching packages ────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.2.0     ✔ purrr   0.3.2
    ## ✔ tibble  2.1.3     ✔ dplyr   0.8.3
    ## ✔ tidyr   0.8.3     ✔ stringr 1.4.0
    ## ✔ readr   1.3.1     ✔ forcats 0.4.0

    ## ── Conflicts ───────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

    greenbuildings = read.csv('../../data/greenbuildings.csv')
    ggplot(greenbuildings) + 
      geom_point(aes(x=age, y=Rent))

![](green_age_files/figure-markdown_strict/unnamed-chunk-1-1.png)

The next questio nis whether building age is systematically different
between green and non-green buildings. In the plot below, we see clearly
that they are:

    ggplot(greenbuildings) + 
      geom_histogram(aes(x=age, y=stat(density)), binwidth=2) + 
      facet_grid(green_rating~.)

![](green_age_files/figure-markdown_strict/unnamed-chunk-2-1.png)

Notice here we can see the whole distribution of ages by green status,
and we recognize the second group of older non-green buildings that is
largely missing among the green-rated buildings.

<!-- # The truly excellent answer: try to hold age roughly constant -->
<!-- # easy way: -->
<!-- # define some age groupings -->
<!-- greenbuildings = mutate(greenbuildings,  -->
<!--                         agecat= cut(age, c(0, 10, 20, 30, 50, 75, 200), include.lowest =TRUE)) -->
<!-- # now compare rent within age groupings -->
<!-- summ1 = greenbuildings %>% -->
<!--   group_by(agecat, green_rating) %>% -->
<!--   summarize(mean_rent = mean(Rent), n = n()) -->
<!-- summ1 -->
<!-- summ1 %>% select(agecat, green_rating, mean_rent) %>% -->
<!--   spread(green_rating, mean_rent) -->
<!-- # in bar plot form -->
<!-- ggplot(summ1) +  -->
<!--   geom_col(aes(x=agecat, y=mean_rent, fill=factor(green_rating)), position='dodge') -->
<!-- # Note: comparison is much easier within categories this way, versus stacked bars! -->
<!-- ggplot(summ1) +  -->
<!--   geom_col(aes(x=agecat, y=mean_rent, fill=factor(green_rating)), position='stack') -->
