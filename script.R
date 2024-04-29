library(rerddap)
library(dplyr)
library(ggplot2)
library(parsedate)

# search layers

res <- ed_search(query = "dhw", which = "griddap")
res$info

# get DHW data (can take while)

layer <- "dhw_5km"
time_start <- "1990-01-01"
time_end <- "2024-03-16"
stride <- 7 # days
latitude <- -21.71868 # Great Barrier Reef
longitude <- 149.869995 # Great Barrier Reef

out <- info(layer)

res <- griddap(
  out,
  time = c(time_start, time_end),
  stride = stride,
  latitude = c(latitude, latitude),
  longitude = c(longitude, longitude)
)

df <- res$data

# plot

ggplot() +
  geom_line(data = df, aes(parse_date(time), CRW_SSTANOMALY), size = 1, color = "#dddddd") +
  geom_point(data = df, aes(parse_date(time), CRW_DHW, color = CRW_DHW), size = 1) +
  geom_line(data = df, aes(parse_date(time), CRW_DHW, color = CRW_DHW), size = 0.5) +
  scale_color_viridis_c(option = "magma") +
  theme_minimal() +
  ggtitle("Temperature anomaly and DHW")

ggsave("dhw.png", bg = "white", height = 7, width = 10, dpi = 300)
