# Read in emissions data and classification code
library(tidyverse)
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Total Emissions for Baltimore city

baltimore<-filter(NEI, fips == "24510")
baltimore_total_by_year<- baltimore %>%
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))


# Create a bar plot to show total emissions by year for Balitmore
png(filename = "plot2.png")
barplot(height = baltimore_total_by_year$total_emissions, names.arg = baltimore_total_by_year$year,
        main = expression('Total Emissions of PM'[2.5]* 'in Baltimore by year'),
        ylab = expression('Total emissions of PM' [2.5]* ' (tons)'),
        xlab = "Years",
        col=c("cyan"))

dev.off()
