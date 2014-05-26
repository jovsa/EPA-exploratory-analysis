wd <- "C:/Users/jsardinha/Documents/GitHub/EPAExploratoryAnalysis"
setwd(wd)

####

# File Name: plot3.R
# Written By: Jovan Sardinha
# Created On: May 25, 2014
# Email: jovan.sardinha@gmail.com
# Operating System: Windows 7 (32 bit)
# R Version: R version 3.1.0 (2014-04-10) 

# Packages Installed
install.packages("plyr")
install.packages("ggplot2")

# Libraries
library(plyr)
library(ggplot2)

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
png(filename="plot3.png", width = 822, height = 474)

# Subsetting the data
NEI2 <- NEI[NEI$fips == "24510",]

# Graphing the data wtih ggplot
g <-  ggplot(aggregate(Emissions~year+type,NEI2, sum), aes(x = year,y = Emissions, color = type))
g <- g+geom_line() + geom_point(size=4)
g <- g + xlab("Years") + ylab("Total amount of PM2.5 emitted, in tons") + labs(title = "Total PM2.5 emission by source for Baltimore City")
g <- g + scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
g <- g + labs(colour="Type of source")
print(g)

# For cross-checking/validation
#write.table(mm, file ="./filename.csv",row.names=FALSE,sep=",")

# Closing the device
dev.off()

