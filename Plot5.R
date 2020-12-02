# Read in emissions data and classification code
library(tidyverse)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Dataset: Total Emissions from Motor Vehicle sources(SCC.Level.Two) for Baltimore city

motor_scc<-SCC[grep("[Vv]eh", SCC$SCC.Level.Two), ]

baltimore_motor_emissions <- NEI %>% 
  subset(fips == "24510" & NEI$SCC %in% motor_scc$SCC) %>%
  merge(y = motor_scc, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions, na.rm = TRUE))

# Create a bar plot to show total emissions  from Motor Vehicle sources (SCC.Level.Two) for Baltimore city
png(filename = "plot5.png")
ggplot(data=baltimore_motor_emissions) +
  geom_bar(mapping = aes(factor(year),total_emissions, fill="red"), 
           stat="identity", show.legend = F,width = 0.75) +
  labs(title=expression('Total PM'[2.5]* ' Motor Vechicle Source Emissions in Baltimore (1998-2008)'),
       x="Years", y=expression("Total PM"[2.5]*" Emissions (tons)"))+
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
