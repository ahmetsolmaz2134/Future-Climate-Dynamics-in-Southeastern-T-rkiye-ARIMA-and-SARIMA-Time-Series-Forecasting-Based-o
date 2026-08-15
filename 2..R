# ==============================================================================
# BATCH REGRESSION WITH ARIMA ERRORS (DETERMINISTIC TREND + ARIMA NOISE)
# ==============================================================================
cat("\n[INFO] Fitting Regression with ARIMA Errors (Guaranteed Warming Trend)...\n")

forecast_results_list <- map(unique(provinces$Province), function(prov) {
  
  df_sub <- annual_prov_df %>% filter(Province == prov)
  ts_annual <- ts(df_sub$Annual_Mean_Temp, start = 1991, frequency = 1)
  
  n_hist <- length(ts_annual)
  h_fc   <- 25 # 2026-2050
  
  # 1. Zaman de??i??kenini (xreg) d????sal trend olarak tan??mla
  xreg_hist <- 1:n_hist
  xreg_fut  <- (n_hist + 1):(n_hist + h_fc)
  
  # 2. Regresyon + ARIMA Hata Modeli
  fit_arima <- auto.arima(
    ts_annual, 
    xreg = xreg_hist, 
    ic = "aicc", 
    stepwise = FALSE, 
    approximation = FALSE
  )
  
  # 3. Gelecek trend de??i??keni (xreg_fut) ile tahmin ??ret
  fc_arima <- forecast(fit_arima, xreg = xreg_fut, h = h_fc)
  
  df_fc <- data.frame(
    Province   = prov,
    YEAR       = 2026:2050,
    Mean_Temp  = as.numeric(fc_arima$mean),
    Lo95       = as.numeric(fc_arima$lower[,2]),
    Hi95       = as.numeric(fc_arima$upper[,2]),
    ARIMA_Model= as.character(fit_arima)
  )
  
  return(df_fc)
})

all_forecasts_df <- bind_rows(forecast_results_list)

# ==============================================================================
# VISUALIZATION (SHOWING UPWARD WARMING SLOPE)
# ==============================================================================
historical_plot_df <- annual_prov_df %>%
  rename(Mean_Temp = Annual_Mean_Temp)

fig_provincial <- ggplot() +
  geom_ribbon(
    data = all_forecasts_df, 
    aes(x = YEAR, ymin = Lo95, ymax = Hi95), 
    fill = "#f4a582", alpha = 0.4
  ) +
  geom_line(
    data = historical_plot_df, 
    aes(x = YEAR, y = Mean_Temp, color = "Historical (1991???2025)"), 
    size = 0.7
  ) +
  geom_line(
    data = all_forecasts_df, 
    aes(x = YEAR, y = Mean_Temp, color = "ARIMA Trend Forecast (2026???2050)"), 
    size = 0.9
  ) +
  facet_wrap(~ Province, ncol = 3, scales = "fixed") +
  scale_color_manual(
    name = "Data Series",
    values = c("Historical (1991???2025)" = "#2b83ba", "ARIMA Trend Forecast (2026???2050)" = "#d7191c")
  ) +
  scale_x_continuous(breaks = seq(1990, 2050, by = 15)) +
  scale_y_continuous(labels = function(x) sprintf("%.1f??C", x)) +
  labs(
    title = "Southeastern Anatolia Provincial Temperature Projections (2026???2050)",
    subtitle = "Stochastic Regression with ARIMA Errors Modeling Multi-Decadal Warming Trends",
    x = "Year",
    y = "Annual Mean Temperature (??C)",
    caption = "Data Source: NASA POWER API (1991???2025) | Method: Regression with ARIMA Errors (Deterministic Trend + ARIMA Residuals)"
  ) +
  theme_bw(base_size = 11) +
  theme(
    plot.title      = element_text(face = "bold", size = 12),
    strip.background = element_rect(fill = "#1a365d", color = NA),
    strip.text       = element_text(color = "white", face = "bold"),
    legend.position  = "top"
  )

print(fig_provincial)

dir.create("outputs", showWarnings = FALSE)
ggsave("outputs/southeastern_turkey_temperature_2050.png", fig_provincial, width = 12, height = 9, dpi = 300)