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
data4 <- subset(
  full,
  select = c(
    Date, Time, Global_active_power, Global_reactive_power,
    Voltage, Sub_metering_1, Sub_metering_2, Sub_metering_3
  ),
  full$Date == "1/2/2007" | full$Date == "2/2/2007"
)

# concatenate Date & Time into new column DT, of type POSIXct
data4$DT <- as.POSIXct(
  strptime(
    paste(data4$Date, data4$Time),
    '%d/%m/%Y %H:%M:%S',
    tz = "GMT"
  )
)

# save plot to plot4.png (in working dir)
png(filename = "plot4.png", width = 480, height = 480)

# initialize display layout
par(mfrow = c(2,2))

# 1. Global_active_power against DT
plot(
  data4$DT,
  data4$Global_active_power,
  type = 'l',
  xlab = "",
  ylab = "Global Active Power"
)

# 2. Voltage against DT
plot(
  data4$DT,
  data4$Voltage,
  type = 'l',
  xlab = "datetime",
  ylab = "Voltage"
)

# 3. Three Sub_metering columns against DT
# initialize the empty plot with Sub_metering_1 data
plot(
  data4$DT,
  data4$Sub_metering_1,
  type = "n",
  xlab = "",
  ylab = "Energy sub metering"
)

# set up the legend; slight diff from prior: no legend border
legend(
  "topright",
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lwd = 1,
  bty = "n",
  col = c("black", "red", "blue")
)

# plot Sub_metering_1, Sub_metering_2, and Sub_metering_3
# use lines with appropriate colors
points(data4$DT, data4$Sub_metering_1, type = "l")
points(data4$DT, data4$Sub_metering_2, type = "l", col = "red")
points(data4$DT, data4$Sub_metering_3, type = "l", col = "blue")

# 4. Global_reactive_power against DT
plot(
  data4$DT,
  data4$Global_reactive_power,
  type = 'l',
  xlab = "datetime",
  ylab = "Global_reactive_power"
)

dev.off()

