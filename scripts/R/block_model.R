

{r}
polygons <- var_block

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

var_block$slope <- weighted_average_slopes

#### map visualization
ggplot() +
  geom_sf(data = var_block, aes(fill = "slope"), color = NA) +
  scale_fill_distiller(palette = "PuOr", direction = -1) +
  theme_void()

{r}
block <- var_block %>% 
  dplyr::select(BLOCKID10,POP10,OVERALL_SC,sum_total_,sum_allroa,Point_Coun,slope,Shape_Area) %>%
  scale(OVERALL_SC,POP10,slope,Shape_Area) %>% 
  drop_na(sum_total_) %>% 
  filter(sum_total_!=0) %>% 
  mutate(rate=Point_Coun/sum_total_) %>% 
  st_drop_geometry

model.block <- glm.nb(Point_Coun ~ OVERALL_SC + slope + Shape_Area + sum_total_, data = block)

summary(model.block)

cor.test(block$rate,block$OVERALL_SC)

install.packages("ggpubr")
library(ggpubr)
ggscatter(block, x = "rate", y = "Point_Coun")
#color = "cyl", shape = "cyl",
#palette = c("#00AFBB", "#E7B800", "#FC4E07"),
#ellipse = TRUE, mean.point = TRUE,
#star.plot = TRUE))

