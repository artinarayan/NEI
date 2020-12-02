# Read in emissions data and classification code
library(tidyverse)
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Total emissions for each year from all sources

total_by_year<- NEI %>%
  group_by(year) %>% 
  summarise(total_emissions = sum(Emissions))


# Create a bar plot to show total emissions by year
png(filename = "plot1.png")

# Emissions total divided by 1000 to prevent scientific notation on y axis
barplot(height = total_by_year$total_emissions/1000, names.arg = total_by_year$year,
        main = expression('Total Emissions of PM'[2.5]* ' by year'),
        ylab = expression('Total emissions of PM' [2.5]* ' (tons)'),
        xlab = "Years",
        col=c("cyan"))

dev.off()

