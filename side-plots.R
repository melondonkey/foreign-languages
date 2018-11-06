library(ggplot2)
library(plotly)
library(dplyr)

mylang %>% group_by(State) %>%
  summarize(ttl = sum(`Estimate Total`)) %>%
  arrange(ttl)




p <- ggplot(mylang, aes(x = State, y = `Estimate Total`)) + geom_point() +
  coord_flip()


ggplotly(p)
