# ==============================================================================
# HYDRO-CLIMATOLOGICAL ANALYSIS & FUTURE RISK MODELING (SOUTHEASTERN TÜRKİYE)
# Data Source: NASA POWER API (1991 - 2025)
# Target Domain: Diyarbakır, Şanlıurfa, Mardin, Gaziantep, Batman
# ==============================================================================

# 1. GEREKLİ PAKETLERİN YÜKLENMESİ
suppressPackageStartupMessages({
  library(nasapower) # NASA POWER API erişimi
  library(dplyr)     # Veri manipülasyonu
  library(tidyr)     # Veri dönüştürme
  library(lubridate) # Tarih işlemleri
  library(trend)     # Mann-Kendall, Sen's Slope, Pettitt testleri
  library(SPEI)      # Hargreaves PET ve SPEI hesabı
  library(forecast)  # Auto-ARIMA zaman serisi projeksiyonu
  library(ggplot2)   # Görselleştirme
  library(ggtext)    # Zengin metin biçimlendirme
  library(patchwork) # Grafikleri birleştirme
})

# ==============================================================================
# 2. HEDEF LOKASYONLAR VE NASA POWER API VERİ ÇEKME
# ==============================================================================
locations <- data.frame(
  City = c("Diyarbakir", "Sanliurfa", "Mardin", "Gaziantep", "Batman"),
  Lon  = c(37.91, 38.79, 40.73, 37.38, 41.13),
  Lat  = c(37.91, 37.16, 37.31, 37.06, 37.88)
)

cat("--> NASA POWER API'den günlük iklim verileri çekiliyor (1991-2025)...\n")

raw_daily_list <- lapply(1:nrow(locations), function(i) {
  get_power(
    community = "AG",
    pars = c("T2M", "T2M_MAX", "T2M_MIN", "PRECTOTCORR", "ALLSKY_SFC_SW_DWN"),
    temporal_api = "daily",
    lonlat = c(locations$Lon[i], locations$Lat[i]),
    dates = c("1991-01-01", "2025-12-31")
  ) %>% mutate(City = locations$City[i])
})

climate_daily <- bind_rows(raw_daily_list)

# ==============================================================================
# 3. ETCCDI AŞIRI SICAKLIK İNDİSATÖRLERİ (SU35 & SU40)
# ==============================================================================
cat("--> Ekstrem sıcak gün sayıları (SU35, SU40) hesaplanıyor...\n")

extreme_heat <- climate_daily %>%
  group_by(City, YEAR) %>%
  summarise(
    SU35 = sum(T2M_MAX > 35, na.rm = TRUE),
    SU40 = sum(T2M_MAX > 40, na.rm = TRUE),
    TR20 = sum(T2M_MIN > 20, na.rm = TRUE),
    .groups = "drop"
  )

# ==============================================================================
# 4. AYLIK ÖLÇEKTE SPEI KURAKLIK ANALİZİ (HARGREAVES YÖNTEMİ)
# ==============================================================================
cat("--> SPEI-12 Kuraklık İndeksi hesaplanıyor...\n")

monthly_climate <- climate_daily %>%
  group_by(City, YEAR, MONTH) %>%
  summarise(
    Tmean = mean(T2M, na.rm = TRUE),
    Tmax  = mean(T2M_MAX, na.rm = TRUE),
    Tmin  = mean(T2M_MIN, na.rm = TRUE),
    Prec  = sum(PRECTOTCORR, na.rm = TRUE),
    .groups = "drop"
  )

# Diyarbakır özelinde SPEI-12 hesaplama örneği
diyar_monthly <- monthly_climate %>% filter(City == "Diyarbakir")
diyar_monthly$PET <- hargreaves(Tmin = diyar_monthly$Tmin, 
                                Tmax = diyar_monthly$Tmax, 
                                Pre = diyar_monthly$Prec, 
                                lat = 37.91)

diyar_monthly$Balance <- diyar_monthly$Prec - diyar_monthly$PET
spei_12_obj <- spei(diyar_monthly$Balance, scale = 12)
diyar_monthly$SPEI_12 <- as.numeric(spei_12_obj$fitted)
diyar_monthly$Date <- ymd(paste(diyar_monthly$YEAR, diyar_monthly$MONTH, "01", sep = "-"))

# ==============================================================================
# 5. MANN-KENDALL, SEN'S SLOPE VE PETTITT BREAKPOINT TESTLERİ
# ==============================================================================
cat("--> İstatistiksel Trend ve Kırılma Noktası Testleri uygulanıyor...\n")

diyar_annual <- climate_daily %>%
  filter(City == "Diyarbakir") %>%
  group_by(YEAR) %>%
  summarise(
    Mean_Temp = mean(T2M, na.rm = TRUE),
    Max_Temp  = mean(T2M_MAX, na.rm = TRUE),
    Total_Prec = sum(PRECTOTCORR, na.rm = TRUE)
  )

# Mann-Kendall & Sen's Slope
mk_temp <- mk.test(diyar_annual$Mean_Temp)
sen_temp <- sens.slope(diyar_annual$Mean_Temp)

# Pettitt Rejim Kırılma Testi
pettitt_temp <- pettitt.test(diyar_annual$Mean_Temp)
break_year <- diyar_annual$YEAR[pettitt_temp$estimate]

cat("--- DİYARBAKIR SICAKLIK TREND ANALİZİ SONUÇLARI ---\n")
cat("Mann-Kendall p-value :", mk_temp$p.value, "\n")
cat("Sen's Slope (Eğilim) :", sen_temp$estimates, "°C/yıl\n")
cat("Pettitt Kırılma Yılı :", break_year, "\n")

# ==============================================================================
# 6. AUTO-ARIMA 2026 - 2050 RİSK PROJEKSİYONU
# ==============================================================================
cat("--> Auto-ARIMA ile 2050 Projeksiyonu modelleniyor...\n")

temp_ts <- ts(diyar_annual$Mean_Temp, start = 1991, frequency = 1)
fit_arima <- auto.arima(temp_ts, ic = "aicc")
forecast_2050 <- forecast(fit_arima, h = 25) # 2026 - 2050 dönemi

# Projeksiyon Verisini Veri Çerçevesine Dönüştürme
df_forecast <- data.frame(
  YEAR = 2026:2050,
  Mean_Temp = as.numeric(forecast_2050$mean),
  Lo80 = as.numeric(forecast_2050$lower[,1]),
  Hi80 = as.numeric(forecast_2050$upper[,1]),
  Lo95 = as.numeric(forecast_2050$lower[,2]),
  Hi95 = as.numeric(forecast_2050$upper[,2])
)

# ==============================================================================
# 7. GÖRSELLEŞTİRME VE MASTER PANEL (PUBLICATION-READY)
# ==============================================================================
cat("--> Grafikler oluşturuluyor...\n")

# Grafik A: SPEI-12 Kuraklık Zaman Serisi
p1 <- ggplot(diyar_monthly, aes(x = Date, y = SPEI_12, fill = SPEI_12 > 0)) +
  geom_area(show.legend = FALSE) +
  scale_fill_manual(values = c("TRUE" = "#2166ac", "FALSE" = "#b2182b")) +
  geom_hline(yintercept = c(-1.5, 1.5), linetype = "dashed", color = "gray40") +
  labs(
    title = "A) Diyarbakır SPEI-12 Kuraklık İndeksi (1991-2025)",
    y = "SPEI-12", x = NULL
  ) +
  theme_minimal()

# Grafik B: Aşırı Sıcak Günler (Tmax > 35°C Trend)
p2 <- ggplot(extreme_heat, aes(x = YEAR, y = SU35, color = City)) +
  geom_line(size = 1) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", size = 0.6) +
  labs(
    title = "B) Bölgesel Aşırı Sıcak Gün Sayıları (Tmax > 35°C)",
    y = "Gün Sayısı", x = "Yıl", color = "İl"
  ) +
  theme_minimal()

# Grafik C: 2050 Auto-ARIMA Projeksiyonu
p3 <- ggplot() +
  geom_line(data = diyar_annual, aes(x = YEAR, y = Mean_Temp), color = "black", size = 1) +
  geom_ribbon(data = df_forecast, aes(x = YEAR, ymin = Lo95, ymax = Hi95), fill = "#fd8d3c", alpha = 0.3) +
  geom_ribbon(data = df_forecast, aes(x = YEAR, ymin = Lo80, ymax = Hi80), fill = "#e31a1c", alpha = 0.4) +
  geom_line(data = df_forecast, aes(x = YEAR, y = Mean_Temp), color = "#b10026", size = 1.2) +
  geom_vline(xintercept = break_year, linetype = "dotdash", color = "blue", size = 0.8) +
  annotate("text", x = break_year - 2, y = max(diyar_annual$Mean_Temp), 
           label = paste("Pettitt Kırılması:", break_year), color = "blue", angle = 90) +
  labs(
    title = "C) Diyarbakır Yıllık Sıcaklık Projeksiyonu (2026-2050)",
    subtitle = "Siyah: Tarihsel Veri | Kırmızı: **Auto-ARIMA**, Mavi: **Pettitt Kırılma Noktası**",
    y = "Sıcaklık (°C)", x = "Yıl"
  ) +
  theme_minimal() +
  theme(plot.subtitle = element_markdown())

# Panelleri Birleştirme (Patchwork)
master_panel <- (p1 / p2 / p3) +
  plot_annotation(
    title = "Güneydoğu Anadolu İklim Değişimi & Gelecek Risk Analizi Paneli",
    caption = "Veri Kaynağı: NASA POWER API | İşleme: R - Hydroclimate Framework",
    theme = theme(plot.title = element_text(face = "bold", size = 16))
  )

# Çıktıyı Kaydetme
ggsave("outputs/master_climate_panel.png", master_panel, width = 12, height = 14, dpi = 300)
cat("--> İşlem tamamlandı! Panel görseli 'outputs/master_climate_panel.png' konumuna kaydedildi.\n")
