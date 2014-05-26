wd <- "C:/Users/jsardinha/Documents/GitHub/EPAExploratoryAnalysis"
setwd(wd)

####

# File Name: plot5.R
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

#Creating .png file 
png(filename="plot5.png", width = 800, height = 800)

# Selecting rows specific to motor vehicle sources
MotorRegEx <- grep(("Motor*"), CombinedData2$SCC.Level.Three)
CombinedData4 <- CombinedData2[MotorRegEx,]

# Selecting rows specific to Baltimore City
CombinedData5 <- CombinedData4[CombinedData4$fips == "24510",]

# Plotting with ggplot 
g <-  ggplot(aggregate(Emissions~year+SCC.Level.Three,CombinedData5, sum), aes(x = year,y = Emissions, color = SCC.Level.Three ))
g <- g+geom_line() + geom_point(size=4)
#g <- g + facet_grid(. ~ EI.Sector)
g <- g + xlab("Years") + ylab("Amount of PM2.5 emitted, in tons") + labs(title = "Amount of PM2.5 emission from motor vehicle sources in Baltimore City")
g <- g + stat_summary(aes(colour="Total",shape="sum",group=1), fun.y=sum, geom="line", size=1.1)
g <- g + scale_x_continuous(breaks=c(1999, 2002, 2005, 2008))
g <- g + theme(legend.position="bottom")
g <- g + labs(colour="Source")
print(g)

# Closing the device
dev.off()

