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
data2 <- subset(
  full,
  select = c(Date, Time, Global_active_power),
  full$Date == "1/2/2007" | full$Date == "2/2/2007"
)

# concatenate Date & Time into new column DT, of type POSIXct
data2$DT <- as.POSIXct(
  strptime(
    paste(data2$Date, data2$Time),
    '%d/%m/%Y %H:%M:%S',
    tz = "GMT"
  )
)

# save plot to plot2.png (in working dir)
png(filename = "plot2.png", width = 480, height = 480)

# set display layout & squeeze margins for max. plot area
par(mfrow = c(1,1), mar = c(2, 4, 0, 0))

# plot Global_active_power against DT, with specified labeling
plot(
  data2$DT,
  data2$Global_active_power,
  type = 'l',
  xlab = "",
  ylab = "Global Active Power (kilowatts)"
)

dev.off()

