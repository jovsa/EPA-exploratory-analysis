wd <- "C:/Users/jsardinha/Documents/GitHub/EPAExploratoryAnalysis"
setwd(wd)

####

# File Name: plot1.R
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
png(filename="plot1.png")

# Plotting with the base plotting system
with(NEI, plot(aggregate(Emissions~year,NEI, sum),main = "Total PM2.5 emission from all sources", xlab = "Years", ylab = "Total amount of PM2.5 emitted, in mega tons", type = "b",axes=FALSE, frame.plot=TRUE))

# Modifying axis lables
axis(1, at=c(1999, 2002, 2005, 2008), labels=c(1999, 2002, 2005, 2008))
axis(2, at=c(0, 4e06, 5e06, 6e06, 7e06), labels=c(0,4,5,6,7))

# Closing the device
dev.off()
