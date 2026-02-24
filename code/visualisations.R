## Data Visualisations
## Short and sweet analysis of the dataset

# Load libraries
library(tidyverse); library(readxl); library(dplyr); library(sf); library(ggplot2); library(maps); library(rnaturalearth)

# Load data
setwd("~/Desktop/GIT/Honours_Jasper/Honours_Data_Management")
data <- read.csv("data/data_clean.csv")
data_sf <- st_read("data/data_clean_sf.gpkg")
attach(data)
#View(data)

#Boxplot of distance travelled vs harvested 
boxplot(follow_trackdist ~ harvested,
        xlab = "Hive harvested",
        ylab = "Distance to hive (m)",
        col = c("red" , "lightgreen")
        )

#Boxplot of guiding time vs harvested 
boxplot(guiding_totaltime ~ harvested,
        xlab = "Hive Harvested",
        ylab = "Distance to hive (m)",
        col = c("red" , "lightgreen")
        )

#Boxplot of guiding time vs sex 
boxplot(guiding_totaltime ~ guide_sex,
        data = subset(data, guide_sex != "unk"), drop = TRUE,
        xlab = "Guide Sex",
        ylab = "Guiding Time (mins)",
        col = c("pink" , "skyblue")
)

#Boxplot of guiding distance vs sex (and dont include sex "unk")
boxplot(follow_trackdist ~ guide_sex, 
        data = subset(data, guide_sex != "unk"), drop = TRUE,
        xlab = "Guide Sex", 
        ylab = "Distance to hive (m)", 
        col = c("pink", "skyblue"))


#Boxplot of guiding distance vs animal found
data$bee_group <- ifelse(data$bee == "apis", "Apis", "Other")
boxplot(follow_trackdist ~ bee_group,
        data = data,
        xlab = "Animal",
        ylab = "Distance travelled (m)",
        col = c("lightgreen", "red"))

#Boxplot of guiding time vs animal found
data$bee_group <- ifelse(data$bee == "apis", "Apis", "Other")
boxplot(GPSguiding_totaltime ~ bee_group,
        data = data,
        names = c("Apis (bee)", "Other"),
        xlab = "Animal",
        ylab = "Guiding Time (mins)",
        col = c("lightgreen", "red"))

#Boxplot of final vs initial phase guiding times
boxplot(data$initialphase_totaltime, data$finalphase_totaltime,
        names = c("Initial Phase", "Final Phase"),
        ylab = "Total Time (mins)",
        col = c("lightblue", "orange"))

#Scatter plot of final vs initial phase guiding times
plot(data$initialphase_totaltime,
     data$finalphase_totaltime,
     xlab = "Initial Phase Time (mins)",
     ylab = "Final Phase Time (mins)",
     pch = 19)
abline(0,1, col = "blue") 

#Do guiding encounters speed up or slow down
data$time_diff <- data$finalphase_totaltime - data$initialphase_totaltime
hist(data$time_diff,
     main = NULL,
     xlab = "Time Difference (mins)",
     col = "lightblue")

#plot study location
ggplot() +
  geom_polygon(data = world_map,
               aes(x = long, y = lat, group = group),
               fill = "grey90",
               colour = "grey60") +
  geom_point(data = data,
             aes(x = beetree_lon, y = beetree_lat),
             colour = "darkblue",
             size = 3) +
  coord_fixed(xlim = c(10, 45),
              ylim = c(-35, -10),
              ratio = 1.3) +
  theme_minimal()

#Plot coordinates of bee trees vs other animals 
data_sf <- st_as_sf(data,
                    coords = c("beetree_lon", "beetree_lat"),
                    crs = 4326)   #make data frame a spatial item
data_utm <- st_transform(data_sf, crs = 32737)
buffer_10km <- st_buffer(data_utm, dist = 10000); buffer_union <- st_union(buffer_10km) #create a buffer of 10km around my points
ggplot() +
  geom_sf(data = buffer_union, fill = "grey100") +
  geom_sf(data = buffer_union, fill = "lightblue", alpha = 0.3) +
  geom_sf(data = data_utm, aes(colour = bee_group), size = 2) +
  labs(colour = "Animal Found") +
  theme_minimal()
