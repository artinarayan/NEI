# Read in emissions data and classification code
library(tidyverse)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Total Emissions for Baltimore city

baltimore<-filter(NEI, fips == "24510")
baltimore_total_by_year_type<- baltimore %>%
  group_by(year,type) %>%
  summarise(total_emissions = sum(Emissions))


# Create a bar plots to show  by type and year for Balitmore
png(filename = "plot3.png")
ggplot(data=baltimore_total_by_year_type) +
  geom_bar(mapping = aes(factor(year),total_emissions,fill=type), 
           stat='identity',show.legend = F) +
  facet_grid(.~type)+
  labs(title = expression('Total PM'[2.5]* ' Emissions in Baltimore by Source Type (1998-2008)'),
       y = expression('Total PM' [2.5]* ' Emissions (tons)'),
       x = "Years") +
  theme(plot.title = element_text(hjust = 0.5))


dev.off()
