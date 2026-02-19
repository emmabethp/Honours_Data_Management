## Data Visualisations
## Short and sweet analysis of the dataset

# Load libraries
library(tidyverse)
library(readxl)
library(dplyr)
library(sf)

# Load data
setwd("~/Desktop/GIT/Honours_Jasper/Honours_Data_Management")
data <- read.csv("data/data_clean.csv")
data_sf <- st_read("data/data_clean_sf.gpkg")
#View(data)