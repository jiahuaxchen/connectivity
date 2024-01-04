# install packages
packages = c('sf','tidyverse','MASS',"spatialreg","spdep","modelsummary")
for (p in packages){
  if(!require(p, character.only = T)){
    install.packages(p)
  }
  library(p, character.only = T)
}

#newest version: from Dan
var <- st_read("scripts/python/outputs/connectivity_blocks.shp")

#turn shp into df
var_df <- var %>%  
  st_drop_geometry()
  
#common variables
common_var <- var_df %>% 
  dplyr::select(crashes, trips, are_km2 ,slope, pp_dn_2 , phisp, prc_low, incm_md, unmplyd, fem_prc, vtrns_p, wht_prc)
common_var[,-c(1,2)] <- scale(common_var[,-c(1,2)]) #remove those don't need scaling: GEOID, trips, crashes, factor of phisp&income 

#three sets of connectivity measures
connectivity_measures <- list(scale(data.frame(var_df$cnnctvt)),
                              scale(data.frame(var_df$b_net_dens,var_df$b_gamma,var_df$b_cover,var_df$b_int_dens,var_df$b_complex)),
                              scale(data.frame(var_df$ls_net_den,var_df$ls_gamma,var_df$ls_cover,var_df$ls_int_den,var_df$ls_complex)))

# Null model
model.null <- glm.nb(crashes ~ offset(log(trips)), data = var_df)

# run models for two different connectivity measure
# set up for loop
# install.packages("rlist")
library(rlist)
model_results_conn <- list()
model_results_all <- list()
for (i in seq_along(connectivity_measures)) {
  current_measure <- connectivity_measures[[i]]
  # model for only offset + connectivity measures
  df <- data.frame(current_measure,"trips"=common_var$trips,"crashes"=common_var$crashes)
  new_model_conn <- glm.nb(crashes ~ . -trips + offset(log(trips)),data = df)
  # model for all variables
  df <- cbind(current_measure,common_var)
  new_model_all <- glm.nb(crashes ~ . -trips + offset(log(trips)),data = df)
  # append model results to the list for making tables
  model_results_conn <- list.append(model_results_conn,new_model_conn)
  model_results_all <- list.append(model_results_all,new_model_all)
}
modelsummary(model_results_all,stars = TRUE)
modelsummary(model_results_conn,stars = TRUE)
  
# test spatial autocorrelation 
# Create a spatial weight matrix
weight_matrix <- poly2nb(var, row.names = var$GEOID)  # Adjust row.names to match your shapefile
weight_listw <- nb2listw(weight_matrix, style = "W")
moran_results <- list()
for (i in seq_along(model_results_all)){
  new_moran <- lm.morantest(model_results_all[[i]],weight_listw)
  moran_results <- list.append(moran_results,new_moran)
  print(new_moran$p.value)
}
# all test p > 0.5, no spatial autocorrelation

# model with interaction term


## summary tables
datasummary(income_3q *(cnnctvt+prc_low) ~  (mean + sd + max + min + median), data = var)
datasummary(phisp_m *(cnnctvt+prc_low) ~  (mean + sd + max + min + median), data = var)


                      