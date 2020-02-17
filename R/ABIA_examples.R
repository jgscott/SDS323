ABIA = read.csv('../data/ABIA.csv')


names(ABIA)
dim(ABIA)


# focus on carrier delays by day of week (1=Monday)
delay_summary = ABIA %>%
  filter(!is.na(CarrierDelay)) %>% 
  group_by(DayOfWeek, UniqueCarrier) %>%
  summarize(n = n(),
            mean_carrier_delay = mean(CarrierDelay), 
            freq_bad_carrier_delay = sum(CarrierDelay >= 60)/n())
  
# quick peak at means for AA
delay_summary %>%
  select(DayOfWeek, mean_carrier_delay, UniqueCarrier) %>%
  filter(UniqueCarrier == 'AA')

# frequency of "bad delays" for AA
delay_summary %>%
  select(DayOfWeek, freq_bad_carrier_delay, UniqueCarrier) %>%
  filter(UniqueCarrier == 'AA')

# barplot across carriers
p0 = ggplot(delay_summary)

p0  + geom_col(aes(x=DayOfWeek, y = freq_bad_carrier_delay)) + 
  facet_wrap(~UniqueCarrier)

p0  + geom_col(aes(x=DayOfWeek, y = mean_carrier_delay)) + 
  facet_wrap(~UniqueCarrier)
  
# how to order by size of carrier?
# first calculate how many flights each carrier has
Carrier_Total = ABIA %>%
  filter(!is.na(CarrierDelay)) %>% 
  group_by(UniqueCarrier) %>%
  summarize(n=n()) %>%
  arrange(desc(n))

# define a new factor with levels re-ordered
delay_summary$UniqueCarrierSort = factor(delay_summary$UniqueCarrier, levels=Carrier_Total$UniqueCarrier)

# barplot across carriers, now ordereded!
p1 = ggplot(delay_summary)

# Mesa Airlines is an interesting story (code YV)
p1  + geom_col(aes(x=DayOfWeek, y = freq_bad_carrier_delay)) + 
  facet_wrap(~UniqueCarrierSort)

p1  + geom_col(aes(x=DayOfWeek, y = mean_carrier_delay)) + 
  facet_wrap(~UniqueCarrierSort)
