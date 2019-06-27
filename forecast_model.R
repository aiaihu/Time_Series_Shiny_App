#loading necessary libraries
library('ggplot2')
library('forecast')
library('tseries')

#loading in the dataset that consists of Delhi's daily weather for past 20 years
data = read.csv('data_clean.csv', header=TRUE, stringsAsFactors=FALSE)

#its original data column datetime_utc requires some cleaning
#starting by splitting its date and time aspect
library(data.table)
setDT(data)[, paste0("type", 1:2) := tstrsplit(data$datetime_utc, "-")]


#checking data$type1(date splitted from original column) is character
class(data$type1)


#converting data$type1 to date format
library("lubridate")
data$date <- ymd(data$type1)
class(data$date)


#extracting only columns needed for time series analysis
#at the same time, it is noticed that not all dates have equal number of data points
#some dates have 24 observations, some have less. 
#for equally sparsed time points, data setss are being aggregated by date

head(data$date)
tail(data$date)


# Build up model

# Plots for temperature

#Use ggplot for the daily temperature data


#this is for temperature and changing its column names to something simpler
temp<- aggregate(data$X_tempm ~ data$date, data, mean )
colnames(temp)=c("date", "temp")



## TEMPATURE MONTHLY FORECAST##

# Decomposing the monthly temperature time series

#now aggregating daily dataset into monthly avg. 
short.date = strftime(temp$date, "%Y/%m")
aggr.stat = aggregate(temp$temp ~ short.date, FUN = mean)
colnames(aggr.stat)=c("date", "temp")

#monthly temperature: decomposing the temperature time series, monthly
tstemp2 <-ts(aggr.stat$temp, frequency=12, start=c(1996,11), end=c(2017, 4))

#STL is a flexible function for decomposing and forecasting the series.
#It calculates the seasonal component of the series using smoothing,
#and adjusts the original series by subtracting seasonality in two simple lines:
decomp = stl(tstemp2, s.window="periodic")

#plot(decomp)

#monthly temperature: auto arima
set.seed(123)
mytep_month <-auto.arima(tstemp2,seasonal=TRUE)

# mytep_month

# show residuals
#tsdisplay(residuals(mytep_month), lag.max=45, main='(4,0,2)(0,1,1) Model Residuals')
# forecast for next h month


#myfcast_month <- forecast(mytep_month, h=36) # here h needs to be input
#plot(myfcast_month)

# see the forecast values
# round(myfcast_month$mean)

# plot last observations and the forecast
# plot(myfcast_month)

#monthly temperature: manual ARIMA: ARIMA calculations
#fit <-arima(tstemp2, order=c(9, 0, 9), seasonal=list(order=c(0, 1, 1)))
#fit


#tsdisplay(residuals(fit), lag.max=45, main='(9,0,9)(0,1,1) Model Residuals')



# Since the model seems to have better accuracy, now the model is being tested for its forecast accuracy with actual value. For this, first 200 values are being used to train the model and remaining actual 45 values are being compared to forecast. 


#testing the model
#test <- window(ts(tstemp2), start=200)
#train <- arima(tstemp2[-c(200:245)], order=c(9, 0, 9), seasonal=list(order=c(0, 1, 1)))




#fcast_test <- forecast(train, h=12)
#plot(fcast_test)
#lines(ts(tstemp2))

# See the forcased values
#fcast_test$mean

# plot last observations and the forecast
#plot(fcast_test,xlim=c(201, 210))

# Build model for variable humidity
#Although it is more or less redundant, as humidity also plays a big role in Summer weather condition, another ARIMA model is being built for a humidity prediction model.


#this is for humidity and changing its column names to something simpler
hum<- aggregate(data$X_hum~ data$date, data, mean )
colnames(hum)=c("date", "hum")

#decomposing the humidity time series
#tshum <-ts(hum$hum, frequency=365)

#now aggregating daily dataset into monthly avg. since there are too many observations. 
short.date = strftime(hum$date, "%Y/%m")
aggr.stat = aggregate(hum$hum ~ short.date, FUN = mean)
colnames(aggr.stat)=c("date", "hum")

#monthly humidity: decomposing the raine time series
tshum2 <-ts(aggr.stat$hum, frequency=12, start=c(1996,11), end=c(2017, 4))

#decomp = stl(tshum2, s.window="periodic")
#plot(decomp)

#monthly humidity: auto arima model and forecast plot
hum_arima <-auto.arima(tshum2, seasonal=TRUE)

#hum_arima

#tsdisplay(residuals(hum_arima), lag.max=45, main='(2,0,1)(0,1,1) Model Residuals')
# forecast for next 3 yrs

hum_fcast <- forecast(hum_arima, h=36)
#plot(hum_fcast, )

## see the forecast values
# humidity <- round(hum_fcast$mean)


# plot last observations and the forecast
#plot(hum_fcast$mean)

forecastTemperature <- function(months) {
  forecast(mytep_month, h = months)
}


forecastHumidity <- function(months) {
  forecast(hum_arima, h = months)
}


