## Data Wrangling
## Cleaning and analysing data using tidy data principles

# Load libraries
library(tidyverse)
library(readxl)
library(dplyr)
library(sf)
library(readr)

# Load data
setwd("~/Desktop/GIT/Honours_Jasper/Honours_Data_Management")
data <- read_excel("data/data_raw.xlsx")
#View(data)

# Check data format
head(data)
str(data)

#change to factor: group, guide_sex, bee, harvested, treeID 
cols1 <- c("group", 
           "guide_sex", 
           "bee", 
           "harvested", 
           "treeID")
data[cols1] <- lapply(data[cols1], as.factor)

#change to num: audio_start_indication, audio_finish_woo, indication_to_woo, dist_fp_start_to_bees, guiding_starttime, finalphasecalls_time, foundtree_time, GPSguiding_starttime,GPSguiding_endtime 
data$finalphasecalls_time <- as.POSIXct(as.numeric(data$finalphasecalls_time) * 86400, origin = "1899-12-31",tz = "UTC") #as other times are this format
cols2 <- c("audio_start_indication", 
           "audio_finish_woo", 
           "indication_to_woo",
           "dist_fp_start_to_bees",
           "guiding_starttime", 
           "finalphasecalls_time", 
           "foundtree_time", 
           "GPSguiding_starttime", 
           "GPSguiding_endtime")
data[cols2] <- lapply(data[cols2], as.numeric)
#note, that the times are now in seconds since 1970

#find difference in times and change to minutes 
data <- mutate(data, guiding_totaltime = (foundtree_time - guiding_starttime)/60)
data <- mutate(data, finalphase_totaltime = (foundtree_time - finalphasecalls_time)/60)
data <- mutate(data, initialphase_totaltime = (finalphasecalls_time - guiding_starttime)/60) 

#change GPS coords into tidy format (also changes dataset to a spatial object)
data_sf <- st_as_sf(data, coords = c("beetree_lon", "beetree_lat"), crs = 4326)

#Save cleaned data as files
write.csv(data, "data/data_clean.csv", row.names = FALSE)
st_write(data_sf, "data/data_clean_sf.gpkg", delete_dsn = TRUE)

#check files are correct
library(readr)
data_clean <- read_csv("data/data_clean.csv")
head(data_clean)
class(data_clean$group) #no this is wrong.
#when I saved the cleaned data file, does it not preserve data structure?

