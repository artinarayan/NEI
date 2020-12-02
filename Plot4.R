# Read in emissions data and classification code
library(tidyverse)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Dataset: Total Emissions for coal sector across US 

scc_coal_sector <- SCC[grep("[Cc]oal",SCC$EI.Sector),]
nei_coal_sector <- subset(NEI, 
                       NEI$SCC %in% scc_coal_sector$SCC)
coal_sector <- merge(x = nei_coal_sector, 
                       y = SCC, 
                       by.x = "SCC", 
                       by.y = "SCC")

total_coal_emissions<- coal_sector %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

# Create a bar plot to show total emissions  from coal sector across US
png(filename = "plot4.png")
ggplot(data=total_coal_emissions) +
  geom_bar(mapping = aes(factor(year),total_emissions/1000, fill="red"), 
           stat="identity", show.legend = F,width = 0.75) +
  labs(title=expression('Coal Related PM'[2.5]* ' Emissions Across US (1998-2008)'),
       x="Years", y=expression("Total PM"[2.5]*" Emissions (tons)"))+
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
