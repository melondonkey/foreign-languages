library(ggplot2)
library(plotly)
library(dplyr)

p<- 
mylang %>% group_by(`City State`) %>%
  summarize(ttl = sum(`Estimate Total`)) %>%
  filter(!is.na(`City State`)) %>%
  arrange(-ttl) %>%
  top_n(25) %>%
  ggplot(aes(x = reorder(`City State`, ttl), y = ttl)) + geom_bar(stat = 'identity') +
  coord_flip() +
  xlab("City") +
  ylab("# Speakers") +
  scale_y_continuous(labels = scales::comma) +
  ggtitle("Top 25 Metro Areas for this Language")




ggplotly(p, tooltip = c('y'))
