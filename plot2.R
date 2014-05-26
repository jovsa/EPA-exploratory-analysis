wd <- "C:/Users/jsardinha/Documents/GitHub/EPAExploratoryAnalysis"
setwd(wd)

####

# File Name: plot2.R
# Written By: Jovan Sardinha
# Created On: May 25, 2014
# Email: jovan.sardinha@gmail.com
# Operating System: Windows 7 (32 bit)
# R Version: R version 3.1.0 (2014-04-10) 

# Packages Installed
install.packages("plyr")

# Libraries
library(plyr)

# Setting up data directory if it does not exist
if(!file.exists("./data")){dir.create("./data")}

# Downloading the data file from UCI Machine Learning Repository
origDataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
file <- paste("./data/", basename(origDataURL),sep = "")
download.file(origDataURL, file)
unzip(file, exdir = "./data")

# Setting up the path variables for data extraction
dataDir <- "./data"

# Loading data in the R workspace
NEI <- readRDS(paste(dataDir, "/summarySCC_PM25.rds",sep = ""))
SCC <- readRDS(paste(dataDir, "/Source_Classification_Code.rds",sep = ""))

# Creating .png file 
png(filename="plot2.png")

# Subsetting the data to only include Baltimore City
NEI2 <- NEI[NEI$fips == "24510",]

# Plotting the data with the base plotting system
with(NEI2, plot(aggregate(Emissions~year,NEI2, sum), main = "Total PM2.5 emission from all sources by in Baltimore City", xlab = "Years", ylab = "Total amount of PM2.5 emitted, in tons", type = "b",axes=FALSE, frame.plot=TRUE))

# Axis modification
axis(1, at=c(1999, 2002, 2005, 2008), labels=c(1999, 2002, 2005, 2008))
axis(2, at=c(2000, 2400, 2800, 3200), labels=c(2000, 2400, 2800, 3200))

# Closing the device
dev.off()
