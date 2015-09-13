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
data1 <- subset(
  full,
  select = c(Global_active_power),
  full$Date == "1/2/2007" | full$Date == "2/2/2007"
)

# plot the histogram to plot1.png (in working dir)
png(filename = "plot1.png", width = 480, height = 480)

# set display layout & squeeze margins for max. plot area
par(mfrow = c(1,1), mar = c(4, 4, 2, 0))

hist(
  data1$Global_active_power,
  col = "red",
  xlab = "Global Active Power (kilowatts)",
  main = "Global Active Power"
)

dev.off()

