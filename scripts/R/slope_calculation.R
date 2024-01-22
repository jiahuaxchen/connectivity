library(sf)

# Load road network data
road_network <- st_read("../../data/slope/slope.shp") 

# Load polygon data
polygons <- big
  #st_read("data/urban_bg_18/urban_bg_18_v3.shp")
  
  #"data/urban_blocks/urban_blocks3.shp")

crs_x <- st_crs(road_network)
crs_y <- st_crs(polygons)

if (!identical(crs_x, crs_y)) {
  polygons <- st_transform(polygons, crs = crs_x)
}

library(dplyr)
library(progress)

# Create an empty vector to store the weighted average slopes
weighted_average_slopes <- numeric(length = nrow(polygons))

# Iterate over each polygon
for (i in 1:nrow(polygons)) {
  polygon <- polygons[i, ]
  
  # Extract road segments within the polygon
  road_segments_within_polygon <- st_intersection(road_network, polygon)
  
  # Calculate weighted average slope
  if (nrow(road_segments_within_polygon) > 0) {
    weighted_average_slopes[i] <- road_segments_within_polygon %>%
      mutate(weighted_slope = length * slope_medi) %>%
      summarize(weighted_average_slope = sum(weighted_slope) / sum(length)) %>%
      pull(weighted_average_slope)
  } else {
    weighted_average_slopes[i] <- NA
  }
  
  # Print the current progress
  cat("Processing polygon", i, "of", nrow(polygons), "\n")
}

big_combined$slope <- weighted_average_slopes
st_write(big_combined, "output/sb_goleta_v2_allbg/sb_goleta_v2_10.shp")

#### map visualization
ggplot() +
  geom_sf(data = SBC_bg, aes(fill = "crashes"), color = NA) +
  scale_fill_distiller(palette = "PuOr", direction = -1) +
  theme_void()
