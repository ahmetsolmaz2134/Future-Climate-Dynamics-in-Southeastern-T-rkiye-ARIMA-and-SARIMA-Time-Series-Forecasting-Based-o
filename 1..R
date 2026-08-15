# ==============================================================================
# SECTION 1: DATA RETRIEVAL & TIME-SERIES CONSTRUCTIONS (FIXED)
# ==============================================================================
cat("[INFO] Fetching daily climate data and processing monthly/annual aggregations...\n")

# Coordinates: Diyarbak??r (37.91?? N, 37.91?? E)
# Fetching daily data guarantees explicit parameter columns (T2M, PRECTOTCORR, etc.)
climate_daily <- get_power(
  community = "AG",
  pars = c("T2M", "T2M_MAX", "PRECTOTCORR"),
  temporal_api = "daily",
  lonlat = c(37.91, 37.91),
  dates = c("1991-01-01", "2025-12-31")
)

# 1. Monthly Aggregation for SARIMA (Frequency = 12)
monthly_df <- climate_daily %>%
  mutate(
    YEAR = as.numeric(format(YYYYMMDD, "%Y")),
    MONTH = as.numeric(format(YYYYMMDD, "%m"))
  ) %>%
  filter(YEAR <= 2025) %>%
  group_by(YEAR, MONTH) %>%
  summarise(
    T2M = mean(T2M, na.rm = TRUE),
    PRECTOTCORR = sum(PRECTOTCORR, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(YEAR, MONTH)

# Construct Monthly Time Series
monthly_ts <- ts(
  monthly_df$T2M, 
  start = c(1991, 1), 
  frequency = 12
)

# 2. Annual Aggregation for Non-Seasonal ARIMA (Frequency = 1)
annual_df <- monthly_df %>%
  group_by(YEAR) %>%
  summarise(
    Mean_Temp = mean(T2M, na.rm = TRUE),
    Total_Prec = sum(PRECTOTCORR, na.rm = TRUE),
    .groups = "drop"
  )

annual_ts <- ts(annual_df$Mean_Temp, start = 1991, frequency = 1)

cat("[SUCCESS] Time series successfully constructed: ", length(monthly_ts), " months.\n")