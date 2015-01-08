#############################################################################################################
##
## Set the name of the dataset file which is required to be read its data for analysis.
##
#############################################################################################################

dataSet <- "household_power_consumption.txt"

#############################################################################################################
##
## Initialize the data frames:
## 1) "temp" is a data frame used to store the data temporarily.
## 2) "result_data" is another data frame used to store the processed result data for ploting a histogram. 
##
#############################################################################################################

temp = data.frame()
result_data = data.frame()

#############################################################################################################
##
## Read the required data from the dataset file and use "result_data" to store it.
##
#############################################################################################################

## (1) Get the column name from the dataset file ##
temp <- read.table( dataSet, header = TRUE, sep = ";", dec = ".", nrows = 1 )

## (2) Get all the data which was recorded with the date 2007-2-1 and store it in "result_data". ##
result_data <- read.table( dataSet, header = FALSE, sep = ";", dec = ".", col.names = colnames( temp ), skip = grep( "1/2/2007", readLines( dataSet ) ), nrows = 1439 )

## (3) Get all the data which was recorded with the date 2007-2-2 and store it in "temp". ##
temp <- read.table( dataSet, header = FALSE, sep = ";", dec = ".", col.names = colnames( result_data ), skip = grep( "2/2/2007", readLines( dataSet ) ) - 1, nrows = 1440 )

## (4) Combine these two data frames and use "result_data" to store the result. ##
result_data <- rbind( result_data, temp )

## (5) Get a data which was recorded with the date 2007-2-3 at 00:00:00 and store it in "temp". ##
temp <- read.table( dataSet, header = FALSE, sep = ";", dec = ".", col.names = colnames( result_data ), skip = grep( "3/2/2007", readLines( dataSet ) ) - 1, nrows = 1 )

## (6) Combine it with "result_data" and use "result_data" to store the result. ##
result_data <- rbind( result_data, temp )

## (7) Convert the date format from "day/month/year" to "year-month-day". ##
result_data$Date <- as.Date( result_data$Date, format = "%d/%m/%Y" )

#############################################################################################################
##
## Plot a histogram by using the data of Global_active_power (stored in the "result_data") with bars filled in red.
## Title:  "Global Active Power"
## X axis: "Global Active Power (kilowatts)"
## Y axis: "Frequency"
##
#############################################################################################################

## Set "LC_TIME" to "English_United States.1252" to ensure the language displayed on the plot is English rather than other languages. ##
Sys.setlocale( "LC_TIME", "English" )

hist(result_data$Global_active_power, col = "red", main = paste( "Global Active Power" ), xlab = "Global Active Power (kilowatts)", ylab = "Frequency", bg = "transparent" )

#############################################################################################################
##
## Save the histogram to a PNG file named as "plot1.png".
##
#############################################################################################################

dev.copy( png, file = "plot1.png" )

## close the PNG device. ##
dev.off()