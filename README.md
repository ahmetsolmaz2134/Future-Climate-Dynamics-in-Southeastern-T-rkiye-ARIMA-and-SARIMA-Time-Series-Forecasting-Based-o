# Future Climate Dynamics in Southeastern Türkiye
### ARIMA and SARIMA Time-Series Forecasting Based on NASA POWER Data

---

## 1. Project Overview

Climate change is increasingly affecting temperature and precipitation regimes across the Mediterranean and Middle East. Southeastern Türkiye is particularly vulnerable because of its semi-arid climatic conditions, agricultural dependence, water-resource pressure, and strong seasonal variability.

This project investigates the temporal dynamics of temperature and precipitation across Southeastern Türkiye using long-term NASA POWER climate data and statistical time-series modelling.

The study applies **ARIMA (AutoRegressive Integrated Moving Average)** and **SARIMA (Seasonal AutoRegressive Integrated Moving Average)** models to identify temporal patterns, evaluate seasonality, and generate short- to medium-term statistical forecasts.

The primary analysis period covers **1981–2025**, while statistical forecasts will be generated for the subsequent period where model performance and uncertainty permit.

---

## 2. Why Was This Project Conducted?

Many regional climate studies focus primarily on detecting trends in temperature and precipitation.

However, identifying a historical trend does not fully describe the temporal structure of a climate variable.

Temperature and precipitation are characterized by:

- temporal dependence,
- autocorrelation,
- seasonality,
- persistence,
- interannual variability,
- and non-stationary behaviour.

Therefore, this project approaches climate variability as a **time-series modelling problem**.

The purpose is not only to determine whether climate variables have changed, but also to investigate whether their historical temporal structure can be statistically modelled and used to generate future forecasts.

---

## 3. Research Question

### Main Research Question

**How can ARIMA and SARIMA models represent and forecast the temporal dynamics of temperature and precipitation in Southeastern Türkiye?**

### Sub-Questions

1. What are the long-term temporal characteristics of temperature and precipitation?
2. Do the climate time series exhibit significant autocorrelation?
3. Are the series stationary?
4. Is there a significant seasonal component?
5. Does SARIMA provide better predictive performance than non-seasonal ARIMA?
6. Which model provides the most reliable forecasts?
7. How do forecast characteristics differ among the provinces of Southeastern Türkiye?

---

## 4. Study Area

The study focuses on the major provinces of Southeastern Türkiye:

- Adıyaman
- Batman
- Diyarbakır
- Gaziantep
- Kilis
- Mardin
- Siirt
- Şanlıurfa
- Şırnak

These provinces represent an important climatic and socio-economic region of Türkiye where agricultural production, water availability, drought vulnerability, and increasing climatic variability are particularly important.

---

## 5. Data Source

All climate data used in this project are obtained from the:

**NASA Prediction of Worldwide Energy Resources (POWER) Project**

NASA POWER provides analysis-ready meteorological and solar datasets through temporal APIs, including monthly and daily time-series products. The platform allows data to be accessed programmatically using geographic coordinates and selected climate parameters.

The project is designed to obtain the data directly through the NASA POWER API in order to maintain a reproducible workflow.

### Data Source

NASA POWER

https://power.larc.nasa.gov/

### Temporal Coverage

**1981–2025**

### Temporal Resolution

**Monthly**

---

## 6. Climate Variables

The primary climate variables investigated in this project are:

### Temperature

- Mean temperature (`T2M`)
- Maximum temperature (`T2M_MAX`)
- Minimum temperature (`T2M_MIN`)

### Precipitation

- Corrected precipitation (`PRECTOTCORR`)

These variables are selected because temperature and precipitation represent two fundamental components of regional climate variability.

---

## 7. Methodological Framework

The analysis follows a reproducible time-series workflow.

```text
NASA POWER Climate Data
          ↓
Data Acquisition
          ↓
Data Quality Control
          ↓
Data Transformation
          ↓
Exploratory Time-Series Analysis
          ↓
Stationarity Testing
          ↓
ACF / PACF Analysis
          ↓
ARIMA Modelling
          ↓
SARIMA Modelling
          ↓
Model Diagnostics
          ↓
Model Comparison
          ↓
Forecasting
          ↓
Scientific Visualization
          ↓
Interpretation
