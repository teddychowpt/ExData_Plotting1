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
## 2) "result_data" is another data frame used to store the processed result data for making a line plot with multiple lines. 
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
## Plot a line plot by using the data of 3 different energy sub metering (stored in the "result_data") with 3 lines in black, red and blue respectively.
## X axis: Date at 2007-02-01 ("Thu") and 2007-02-02 ("Fri")
## Y axis: "Energy sub metering"
##
#############################################################################################################

## Set "LC_TIME" to "English_United States.1252" to ensure the language displayed on the plot is English rather than other languages. ##
Sys.setlocale("LC_TIME", "English")

result_data$Date <- strptime( paste( result_data$Date, result_data$Time ), "%Y-%m-%d %H:%M:%S" )

plot( result_data$Date, result_data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", bg = "transparent" )
lines( result_data$Date, result_data$Sub_metering_2, col="red" )
lines( result_data$Date, result_data$Sub_metering_3, col="blue" )
legend( "topright", legend = c( colnames( result_data[7] ), colnames( result_data[8] ), colnames( result_data[9] ) ), col = c( "black", "red", "blue" ), lty = c( 1, 1, 1 ), bg = "transparent", cex=0.9 )

#############################################################################################################
##
## Save the line plot to a PNG file named as "plot3.png".
##
#############################################################################################################

dev.copy( png, file = "plot3.png" )

## close the PNG device. ##
dev.off()