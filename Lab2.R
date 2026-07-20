library(readxl)     # For reading Excel files
#library(lubridate)  # For date parsing
#library(ggplot2)    # For plotting
library(forecast)  
library(Metrics)  # For rmse function
install.packages("Metrics")
install.packages("forecast")
options(scipen = 999)

setwd("C:/Users/Public/PK MoM/Sem 2/Intro to data Analytics KObara/Lab/")

myData <- read_excel("Data for lab 2.xlsx", sheet = "housing")

# a function to turn data to time series object
housing_ts <- ts(myData$HStarts, start = c(2011, 1),end = c(2018,11),  frequency = 12)

# create a trend model
housing_model <- tslm(housing_ts ~ trend)
summary(housing_ts)  
forecast(housing_model)

plot(housing_ts, main = "Housing Starts", xlab = "Date", ylab = "Hstarts")
lines(fitted(housing_model), col = "blue")

# Q2.a: Fit the Moving Average (m = 4)
ma_4 <- ma(housing_ts, order = 4, centre = TRUE)

plot(housing_ts,main = "4-Month Moving Average of Housing Starts", 
     ylab = "Housing Starts", xlab = "Year", col = "red", lwd = 2)

# Add the moving average line
lines(ma_4, col = "blue", lwd = 2, lty = 2) 

# Add legend
legend("topleft",legend = c("Original", "Moving Average (m = 4)"),
       col = c("red", "blue"),lty = c(1, 2),lwd = 2, bty = "n")

# Q2 b: Fit Exponential Smoothing model with alpha = 0.4
ets_model <- ses(housing_ts, alpha = 0.4, initial = "simple")

# View model summary
summary(ets_model)

# ===== Plot original vs smoothed =====
plot(housing_ts, main = "Simple Exponential Smoothing (α = 0.4)", ylab = "Housing Starts", 
     xlab = "Year", col = "red", lwd = 2)


# Add the smoothed forecast line
lines(fitted(ets_model), col = "darkgreen", lwd = 2, lty = 2)

# Add legend
legend("topleft",legend = c("Original", "SES Smoothed (α = 0.4)"),col = c("red", "darkgreen"),
       lty = c(1, 2),lwd = 2, bty = "n")

# Q2 C : Linear Trend Only 
linear_model <- tslm(housing_ts ~ trend)
summary(linear_model)  

#  Q2 d: Seasonal Effect Only  
seasonal_model <- tslm(housing_ts ~ season)
summary(seasonal_model) 

# Q2 e: Linear + Seasonal Trend 
linear_seasonal_model <- tslm(housing_ts ~ trend + season)
summary(linear_seasonal_model) 

# Q2 f: Quadratic Trend + Seasonal 
quad_seasonal_model <- tslm(housing_ts ~ trend + I(trend^2) + season)
summary(quad_seasonal_model) 

# Plot the fitted values 
plot(housing_ts, 
     main = "Time Series Models Fitted to Housing Starts",
     ylab = "Housing Starts", xlab = "Year", col = "black", lwd = 2)

# Add fitted Linear Trend model
lines(fitted(linear_model), col = "blue", lwd = 2, lty = 2) 


# Add fitted Linear + Seasonal model
lines(fitted(linear_seasonal_model), col = "green", lwd = 2, lty = 3)

# Add fitted Quadratic + Seasonal model
lines(fitted(quad_seasonal_model), col = "red", lwd = 2, lty = 4)

# Add legend
legend("topleft", 
       legend = c("Original", "Linear Trend", "Linear + Seasonal", "Quadratic + Seasonal"),
       col = c("black", "blue", "green", "red"),
       lty = c(1, 2, 3, 4),
       lwd = 2,
       bty = "n")

-------------------------------------------
#  Q3 a:Compare the performance models using RMSE =====
 
# RMSE function from base R (alternative to Metrics package)
rmse_base <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2, na.rm = TRUE))
}

# Actual values
actual <- housing_ts

# RMSE for Moving Average (note: has NA values at ends due to centering)
rmse_ma <- rmse_base(actual, ma_4)

# RMSE for Linear Trend
rmse_linear <- rmse_base(actual, fitted(linear_model))

# RMSE for Seasonal Model
rmse_seasonal <- rmse_base(actual, fitted(seasonal_model))

# RMSE for Linear + Seasonal
rmse_lin_seasonal <- rmse_base(actual, fitted(linear_seasonal_model))

# RMSE for Quadratic + Seasonal
rmse_quad_seasonal <- rmse_base(actual, fitted(quad_seasonal_model))

# RMSE for Exponential Smoothing
rmse_ets <- rmse_base(actual, fitted(ets_model))

# Print results
cat("RMSE for each model:\n")
cat("1. Moving Average (m=4):      ", round(rmse_ma, 2), "\n")
cat("2. Linear Trend:              ", round(rmse_linear, 2), "\n")
cat("3. Seasonal Only:             ", round(rmse_seasonal, 2), "\n")
cat("4. Linear + Seasonal:         ", round(rmse_lin_seasonal, 2), "\n")
cat("5. Quadratic + Seasonal:      ", round(rmse_quad_seasonal, 2), "\n")
cat("6. Exponential Smoothing:     ", round(rmse_ets, 2), "\n")  


#Q3 b: Use cross-validation to compare model performance
# RMSE helper function
rmse <- function(errors) sqrt(mean(errors^2, na.rm = TRUE))

# Cross-Validation RMSE for Linear Trend
cv_linear <- tsCV(housing_ts, function(y, h) forecast(tslm(y ~ trend), h = h), h = 1)
rmse_linear <- rmse(cv_linear)

# Linear + Seasonal
cv_lin_seasonal <- tsCV(housing_ts, function(y, h) forecast(tslm(y ~ trend + season), h = h), h = 1)
rmse_lin_seasonal <- rmse(cv_lin_seasonal)

# Quadratic + Seasonal
cv_quad_seasonal <- tsCV(housing_ts, function(y, h) forecast(tslm(y ~ trend + I(trend^2) + season), h = h), h = 1)
rmse_quad_seasonal <- rmse(cv_quad_seasonal)

# Exponential Smoothing (alpha = 0.4)
cv_ets <- tsCV(housing_ts, function(y, h) forecast(ses(y, alpha = 0.4, initial = "simple"), h = h), h = 1)
rmse_ets <- rmse(cv_ets)

# Print results
cat("Cross-Validation RMSEs:\n")
cat("1. Linear Trend:             ", round(rmse_linear, 2), "\n")
cat("2. Linear + Seasonal:        ", round(rmse_lin_seasonal, 2), "\n")
cat("3. Quadratic + Seasonal:     ", round(rmse_quad_seasonal, 2), "\n")
cat("4. Exponential Smoothing:    ", round(rmse_ets, 2), "\n")

