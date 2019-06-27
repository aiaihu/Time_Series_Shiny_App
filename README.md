# Time_Series_Shiny_App

## Dataset
There is a dataset available for past 20+ years weather on hourly basis for New Delhi, India. 
https://www.kaggle.com/mahirkukreja/delhi-weather-data/downloads/delhi-weather-data.zip/2
I did data cleaning and subset the dataset in my another file which is in my Time_Series repository. Hence, dataset in this repository is already subset with only three columns.

## This app is to forecast monthly temperature and humidity for city Delhi, India
I built this app by using a time series dataset from 1996-11-01 to 2017-04-24, therefore, the app will forecast 
monthly temperature and humility for months after 2017-04. Temperatures in this app are in Celsius.Humidity in this app is relative humidity and expressed as a percentage.

## Below is the shiny app link:
https://amy-hu-zhao-2001.shinyapps.io/time_series_shiny_app/

## To run this app on your local computer, please download below files:
server.r, ui.r and data_clean.csv

## Why monthly forecast not daily?
Tried do the daily forecast, but the computation time is too long and shiny app is unable to handle it due to the limited space for the instance

## Future development
I would like to add  tables to show the average tempeature and humidity for each forecasted month.
