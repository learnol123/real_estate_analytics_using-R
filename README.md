Business Scenario
A real estate analytics firm is tracking monthly housing starts to forecast future demand and guide investment decisions.
1. Data Exploration
   a. Plot the time series of housing starts.
   b. What patterns do you observe? Are there any visible trends or seasonal effects?
2. Forecasting Models
   a. Fit a Moving Average model to the data with a sample of m = 4.
   b. Fit an Exponential Smoothing (ETS) model with an alpha = 0.4.
   c. Fit a linear trend model.
   d. Fit a seasonal trend model.
   e. Fit a model with both linear and seasonal trend.
   f. Fit a model with both quadratic and seasonal trend   
3. Model selection
   a. Compare the performance models using RMSE.
4. Business Insights
   a. What does the forecast suggest about future housing demand?
   b. How should the firm adjust its investment strategy based on the forecasting

**Approach:** 

- Exploratory Data Analysis: Analyzed 8 years of monthly housing starts (2011–2018) to identify underlying trend and seasonality.
- Model Fitting:Built and compared 6 time-series models in R:
    ◦ Moving Average (m = 4) & Exponential Smoothing (alpha = 0.4)
    ◦ Linear Trend & Seasonal Trend
    ◦ Combined Models (Linear + Seasonal, Quadratic + Seasonal)
- Model Evaluation: Evaluated performance using **RMSE** and **time-series cross-validation** with a rolling forecast origin..

Outcome:(What did you find or build? What was the impact?)

- Top-Performing Model: The **Quadratic + Seasonal Model** achieved the lowest RMSE, successfully capturing accelerating demand alongside annual seasonal spikes.
- Core Market Insights:Strong upward trend overall, with predictable peaks in spring/summer and lulls in winter.

Business Impact & Recommendations

- Seasonal Execution: Schedule new project rollouts for early spring to capture peak summer demand.
- Resource Optimization: Secure supply chain contracts and labor ahead of Q2/Q3 to prevent delays and cost spikes.
- Strategic Growth: Focus capital allocation in high-demand regions while maintaining flexibility against macroeconomic shifts.

Tech Stack:

- Language: R
- Core Libraries & Tools:
    - `forecast` — Model fitting (`tslm`, `ses`), moving averages (`ma`), and cross-validation (`tsCV`)
    - `readxl` — Data ingestion from Excel
    - `Metrics` / `Base R` — Mathematical error calculations (RMSE)
- Techniques & Models: Time Series Analysis, Centered Moving Averages, Simple Exponential Smoothing (SES), Linear/Quadratic Trend Regression, Seasonal Indicators, Time-Series Cross-Validation (Rolling Origin)
- Environment: RStudio / R Console
