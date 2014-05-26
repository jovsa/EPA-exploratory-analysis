wd <- "C:/Users/jsardinha/Documents/GitHub/EPAExploratoryAnalysis"
setwd(wd)

####

# File Name: plot4.R
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

# Combining the NEI and SCC data sets
CombinedData <- join(NEI, SCC, type = "inner", by = "SCC")

# Cleaning the combined data set
CombinedData2 <- CombinedData[,c(1,2,3,4,5,6,9,10,12,13,14,15)]

# Creating .png file 
png(filename="plot4.png", width = 800, height = 800)

# Selecting rows specific to coal combustion-related sources
CoalRegEx <- grep(("Fuel Comb.*.Coal"), CombinedData2$EI.Sector)
CombinedData3 <- CombinedData2[CoalRegEx,]

# Plotting with ggplot
g <-  ggplot(aggregate(Emissions~year+EI.Sector,CombinedData3, sum), aes(x = year,y = Emissions, color = EI.Sector ))
g <- g + geom_line() + geom_point(size=4)
g <- g + xlab("Years") + ylab("Total amount of PM2.5 emitted, in tons") + labs(title = "Total PM2.5 emission from coal combustion-related sources")
g <- g + stat_summary(aes(colour="Total",shape="sum",group=1), fun.y=sum, geom="line", size=1.1)
g <- g + scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
g <- g + theme(legend.position="bottom")
g <- g + labs(colour="Source")
print(g)

# For cross-checking/validation
#write.table(SCC, file ="./filename-SCC.csv",row.names=FALSE,sep=",")

# Closing the device
dev.off()
