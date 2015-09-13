# i was unable to find a platform-agnostic and performant way
# to read only the data subset for 2007-02-01 & 2007-02-02,
# so i read the entire data file and subset it (rows & columns)
# into a local data frame for subsequent processing

# the unzipped file is assumed to be in the working directory
full <- read.csv(
  "household_power_consumption.txt",
  header = TRUE,
  sep = ";",
  na.strings = c("?")
)

# filter to dates 2007-02-01, 2007-02-02
# select only the required columns
data3 <- subset(
  full,
  select = c(Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3),
  full$Date == "1/2/2007" | full$Date == "2/2/2007"
)

# concatenate Date & Time into new column DT, of type POSIXct
data3$DT <- as.POSIXct(
  strptime(
    paste(data3$Date, data3$Time),
    '%d/%m/%Y %H:%M:%S',
    tz = "GMT"
  )
)

# save plot to plot3.png (in working dir)
png(filename = "plot3.png", width = 480, height = 480)

# set layout, background; squeeze margins for max. plot area
par(mfrow = c(1,1), mar = c(2, 4, 0, 0), bg = "transparent")

# initialize the empty plot with Sub_metering_1 data
plot(
  data3$DT,
  data3$Sub_metering_1,
  type = "n",
  xlab = "",
  ylab = "Energy sub metering"
)

# set up the legend
legend(
  "topright",
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lwd = 1,
  col = c("black", "red", "blue")
)

# plot Sub_metering_1, Sub_metering_2, and Sub_metering_3
# use lines with appropriate colors
points(data3$DT, data3$Sub_metering_1, type = "l")
points(data3$DT, data3$Sub_metering_2, type = "l", col = "red")
points(data3$DT, data3$Sub_metering_3, type = "l", col = "blue")

dev.off()

