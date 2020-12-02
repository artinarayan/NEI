# Read in emissions data and classification code
library(tidyverse)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Dataset: Total Emissions from Motor Vehicle sources (level 2) for Baltimore and LA
motor_scc<-SCC[grep("[Vv]eh", SCC$SCC.Level.Two), ]

motor_emissions_bal <- NEI %>% 
  subset(fips == "24510" & NEI$SCC %in% motor_scc$SCC) %>%
  merge(y = motor_scc, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions, na.rm = TRUE)) 

motor_emissions_la <- NEI %>% 
  subset(fips == "06037" & NEI$SCC %in% motor_scc$SCC) %>%
  merge(y = motor_scc, by.x = "SCC", by.y = "SCC") %>%
  group_by(year) %>%
  summarize(total_emissions = sum(Emissions, na.rm = TRUE))
## adding city to the dataset
motor_emissions_bal2 <- cbind(motor_emissions_bal, "City" = rep("Baltimore", NROW(motor_emissions_bal)))
motor_emissions_la2 <- cbind(motor_emissions_la, "City" = rep("Los Angeles", NROW(motor_emissions_la)))
combined_motor_emissions<-rbind(motor_emissions_bal2,motor_emissions_la2)

# Create bar plots to show emissions from motor vehicle sources in Baltimore and LA
# scales=free so Y axis different for both graphs 
# theme so title is centered over the graph
png(filename = "plot7.png")
ggplot(data=combined_motor_emissions,aes(x=factor(year),y=total_emissions,fill=City)) +
  geom_bar(stat="identity") +
  facet_grid(City~.) + 
  labs(title = expression('Total PM'[2.5]* ' Motor Vehicle Source Emissions in Baltimore & LA (1998-2008)'),
       y = expression('Total PM' [2.5]* ' Emissions (tons)'),
       x = "Years") +
  theme(plot.title = element_text(hjust = 0.25)) +
  geom_label(aes(fill = City,label=round(total_emissions)),colour = "black", fontface = "bold")

qplot(year, total_emissions, data = combined_motor_emissions, color = City, geom = "line") +
  labs(title = expression('PM'[2.5]* ' Motor Vehicle Source Emissions in Baltimore & LA (1998-2008)'),
       y = expression('Total PM' [2.5]* ' Emissions (tons)'),
       x = "Years") 

ggplot(data = combined_motor_emissions) + 
  geom_line(aes(x=year,y=total_emissions,color=City))+ 
  labs(title = expression('PM'[2.5]* ' Motor Vehicle Source Emissions in Baltimore & LA (1998-2008)'),
       y = expression('Total PM' [2.5]* ' Emissions (tons)'),
       x = "Years") 
#theme(plot.title = element_text(hjust = 0.25))
 
dev.off()
