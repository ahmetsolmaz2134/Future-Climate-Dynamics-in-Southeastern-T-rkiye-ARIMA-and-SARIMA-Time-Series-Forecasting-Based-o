# Future Climate Risk in Southeastern Türkiye (2021–2050)

## Project Overview

Climate change is expected to substantially alter temperature and precipitation regimes across Southeastern Türkiye, a region characterized by high climatic variability, water-resource pressure, agricultural dependence, and increasing exposure to drought and extreme climatic conditions.

This project investigates projected climate change and associated climate risks across Southeastern Türkiye during the 2021–2050 period using CMIP6 climate projections and multiple Shared Socioeconomic Pathways (SSPs).

The primary objective is to quantify projected changes in temperature, precipitation, and drought-related climate conditions and to identify areas that may experience greater future climate risk.

---

## Research Question

**How are temperature, precipitation, and drought-related climate risks expected to change across Southeastern Türkiye during 2021–2050 under different CMIP6 climate scenarios?**

### Specific Objectives

- Quantify projected changes in mean temperature.
- Assess projected changes in precipitation.
- Examine spatial and temporal variations in climate change signals.
- Evaluate potential changes in drought conditions.
- Compare projected climate conditions under different SSP scenarios.
- Identify areas with relatively higher future climate risk.
- Produce reproducible maps and statistical visualizations using R.

---

## Study Area

The study focuses on **Southeastern Türkiye**, including the provinces of:

- Adıyaman
- Batman
- Diyarbakır
- Gaziantep
- Kilis
- Mardin
- Siirt
- Şanlıurfa
- Şırnak

The region is particularly relevant for climate-risk assessment because of its semi-arid climatic characteristics, agricultural activity, water-resource sensitivity, and exposure to increasing temperatures and drought.

---

## Data

The analysis will primarily use **CMIP6 climate projections**.

### Climate Variables

The following variables will be investigated:

- Near-surface air temperature
- Precipitation
- Temperature anomalies
- Precipitation anomalies
- Drought-related indicators

### Climate Scenarios

Multiple Shared Socioeconomic Pathways will be compared:

- SSP1-2.6
- SSP2-4.5
- SSP3-7.0
- SSP5-8.5

The analysis will focus on the **2021–2050 projection period**.

---

## Climate Models

The study may incorporate multiple CMIP6 global climate models in order to reduce dependence on a single model.

Candidate models include:

- ACCESS-CM2
- BCC-CSM2-MR
- CanESM5
- CNRM-CM6-1
- GISS-E2-1-G
- HadGEM3-GC31-LL
- MIROC6
- MPI-ESM1-2-HR

Where appropriate, multi-model comparisons and ensemble-based assessments will be conducted.

---

## Methodology

The analytical workflow will be implemented primarily in **R**.

### 1. Data Preparation

- Import climate projection datasets.
- Standardize temporal formats.
- Check missing and anomalous values.
- Harmonize spatial and temporal resolution.
- Extract the study region.
- Prepare model and scenario datasets.

### 2. Temperature Analysis

Temperature projections will be evaluated using:

- Mean temperature
- Temperature anomalies
- Linear trends
- Spatial temperature change
- Scenario-based comparison

### 3. Precipitation Analysis

Precipitation changes will be assessed using:

- Annual precipitation
- Seasonal precipitation
- Precipitation anomalies
- Relative precipitation change
- Temporal trends
- Spatial patterns

### 4. Drought Assessment

Potential future drought conditions will be examined using climate-based indicators such as:

- SPI
- SPEI
- Drought frequency
- Drought duration
- Drought intensity

Where data availability permits, evapotranspiration-related variables will also be incorporated into drought assessment.

### 5. Trend Analysis

Statistical trend analysis may include:

- Mann–Kendall test
- Sen's slope estimator
- Linear regression
- Pettitt change-point analysis

These methods will be used to evaluate the direction, magnitude, and statistical significance of projected climate changes.

---

## Climate Risk Assessment

A regional climate-risk framework will be developed by integrating multiple climate indicators.

Conceptually:

**Climate Hazard → Exposure → Potential Risk**

The climate hazard component will primarily consider:

- Increasing temperature
- Precipitation reduction
- Increasing drought conditions
- Climate variability

A composite climate-risk assessment may subsequently be developed to identify areas where multiple climate stressors overlap.

---

## Expected Outputs

The project will produce:

### Maps

- Projected temperature change
- Projected precipitation change
- Temperature anomalies
- Precipitation anomalies
- Drought distribution
- Scenario comparisons
- Spatial climate-risk patterns

### Statistical Outputs

- Trend statistics
- Sen's slope estimates
- Mann–Kendall significance
- Drought frequency
- Drought duration
- Scenario-based climate comparisons

### Figures

- Time-series plots
- Scenario comparison plots
- Climate anomaly plots
- Drought severity plots
- Spatial risk maps
- Multi-model comparison figures

---

## Reproducible Research Workflow

The project is designed as a reproducible climate-data analysis workflow.

```text
CMIP6 Climate Data
        ↓
Data Quality Control
        ↓
Spatial & Temporal Processing
        ↓
Climate Scenario Analysis
        ↓
Temperature Analysis
        ↓
Precipitation Analysis
        ↓
Drought Assessment
        ↓
Trend & Statistical Analysis
        ↓
Climate Risk Assessment
        ↓
Maps & Scientific Visualizations
