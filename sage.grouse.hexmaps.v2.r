library(ncdf)
library(rgdal)
library(raster)
library(foreign)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
hexsimWorkspace <- 'sage_grouse_v2'
setwd(paste(workspace,'Scripts/',sep=''))

# # =======================================================================================================
# # WGS 84 grid for biomes data and climate data...

theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/albers_centroids_1km_wgs84.dbf',sep=''), as.is=TRUE)
theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

# # biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')

# extractedData <- extract(biomes, hex.grid)
# extractedData[is.na(extractedData)==TRUE] <- 0

# # Reclassify values...
# # Sarah's classes: 1, temperate forest; 2, boreal forest; 3, open forest/woodland w/ broadleaf; 4, open forest/woodland; 5, grassland; 6, shrubland; 7, barren.
# # Translation to vireo classes:
# # 1 to 0
# # 2 to 0
# # 3 to 0
# # 4 to 0
# # 5 to 1
# # 6 to 1
# # 7 to 0

# extractedData[extractedData %in% c(1:4,7)] <- 0
# extractedData[extractedData==5] <- 1
# extractedData[extractedData==6] <- 1

# dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
# write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/veg.step0.csv',sep=''),row.names=FALSE)

# workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
# # command <- paste('cd "',workspace2,'\\HexSim\\current HexSim Model\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\veg.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\Hexagons\\biomes.v2"',sep='')
# command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\veg.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\biomes.v2"',sep='')
# shell(command)

deficit <- raster(paste(workspace,'ClimateData/ClimateData/pet-aet_ann_1961-1990.nc',sep=''),varname='variable')

extractedData <- extract(deficit, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/deficit.step0.csv',sep=''),row.names=FALSE)

workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\deficit.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\deficit"',sep='')
shell(command)

# Crosswalked-veg derived sagebrush layer.
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs')) #,data=theCentroids)

sage.hab <- raster(paste(workspace,'SpatialData/Veg_noHF/crswk_sage',sep=''))

extractedData <- extract(sage.hab, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
extractedData[extractedData>0] <- 1

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/lf.sage.step0.csv',sep=''),row.names=FALSE)

workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\lf.sage.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\lf.sage"',sep='')
shell(command)

# ======================================================================================================
# ======================================================================================================
# Centroids for NAD 1927 Albers

# theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids27Albers.txt',sep=''), header=TRUE)
theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/albers_centroids_1km_nad27Albers.dbf',sep=''), as.is=TRUE)
theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# This is what I found for PROJ4 on SpatialReference.org '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=clrk66 +units=m +no_defs'
# I substituted some parameters based on the spatial reference information for the Leu coverage.
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=aea +lat_1=38 +lat_2=41 +lat_0=34 +lon_0=-114 +x_0=0 +y_0=0 +datum=NAD27 +ellps=clrk66 +units=m +no_defs'))
print('hex.grid loaded')

# ============================================================================================================
# Leu et al human impacts, Western US

human.impacts <- raster(paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus',sep=''))

# startTime <- Sys.time()
focalData <- focal(human.impacts, w=7, fun=mean, progress='text')
writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r1km.img',sep='')) # This is a 1260m length square.  This could work for squirrels, rabbits, and kangaroo rats
# focalData <- focal(human.impacts, w=55, fun=median, progress='text')
# writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r5km.img',sep='')) # This is a 5km radius.  This is also a median, even the file name says otherwise
# focalData <- raster(paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r5km.img',sep=''))
# focalData <- focal(human.impacts, w=100, fun=median, progress='text')
# writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r18km.img',sep='')) # This is a 18km radius.
# focalData <- focal(human.impacts, w=55, fun=mean, progress='text')
# writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean2_r5km2.img',sep='')) # This is a 5km radius.

extractedData <- extract(focalData, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
extractedData2 <- extractedData * 10
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData2)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/human.foot.leu.r1km.csv',sep=''),row.names=FALSE)
# stop('cbw: check .csv file')
# dataDump2 <- dataDump
# dataDump <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v1/Spatial Data/human.foot.leu.v3.csv',sep=''),header=TRUE)
# dataDump2$extractedData2[dataDump2$extractedData2 > 80] <- 0 # remove non-habitat, heavily impacted habitats.
# write.csv(dataDump2, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/human.foot.leu.r5km4.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\human.foot.leu.r1km.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\human_foot_leu_1km"',sep='')
shell(command)
# command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\human.foot.leu.r5km4.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\human_foot_leu_5km4"',sep='')
# shell(command)
stop('cbw')

# ========================================================================================================
# Lek components (units)

components <- readOGR(dsn=paste(workspace,'SageGrouse/sg_components',sep=''),'sg_components')

# startTime <- Sys.time()
extraction <- overlay(components,hex.grid)
extract.vector <- as.vector(extraction$dPC100k)
extract.vector[is.na(extract.vector)==TRUE] <- 0
extract.vector[extract.vector>0] <- 1

print(head(extract.vector))

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extract.vector)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/components.step0.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\components.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\components"',sep='')
shell(command)

# =========================================================================================================
# Management Zones
mgmt.zones <- readOGR(dsn=paste(workspace,'SageGrouse/SG_MgmtZones_ver2_20061018',sep=''),'SG_MgmtZones_ver2_20061018')

# startTime <- Sys.time()
extraction <- overlay(mgmt.zones,hex.grid)
extract.vector <- as.vector(extraction$Zone)
extract.vector[is.na(extract.vector)==TRUE] <- 0
# extract.vector[extract.vector>0] <- 1

print(head(extract.vector))

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extract.vector)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/mgmt.zones.step0.csv',sep=''),row.names=FALSE)

workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\mgmt.zones.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\mgmt.zones.v1"',sep='')
shell(command)


# ===========================================================================================================
# Sagebrush
sage90m <- raster(paste(workspace,'SageGrouse/allsage_90m/allsage_90m/allsage_90m',sep=''))

extractedData <- extract(sage90m, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/sagebrush.step0.csv',sep=''),row.names=FALSE)

workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\sagebrush.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\Hexagons\\sagebrush"',sep='')
shell(command)

stop('cbw')

# ==========================================================================================================
# Centroids for current and historic distribution
theCentroids2 <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/albers_centroids_1km_nad27albers_schroeder.dbf',sep=''), as.is=TRUE)
theCentroids2 <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
hex.grid2 <- SpatialPoints(coords=theCentroids2[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD27 +ellps=clrk66 +units=m +no_defs +nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat')) #,data=theCentroids)

# ========================================================================================================
# Historical distribution

# I could not get this to work.  I'm not sure why.  Ran it in ArcGIS
# historical <- readOGR(dsn=paste(workspace,'SageGrouse/Sage-grouse_distribution_sgca',sep=''),'Sage-grouse_historic_distribution_sgca')

# extraction <- overlay(historical,hex.grid2)
extraction <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/centroids_historical_distn.dbf',sep=''), as.is=TRUE)
extract.vector <- as.vector(extraction$HISTORIC_I)
extract.vector <- extract.vector[order(extraction$Hex_ID)]
extract.vector[is.na(extract.vector)==TRUE] <- 0
extract.vector[extract.vector>0] <- 1

# print(head(extract.vector))

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extract.vector)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/historical.step0.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\historical.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\historical"',sep='')
shell(command)

# ========================================================================================================
# Current distribution

# Again, I could not get this to work in R and did the extraction in ArcGIS
# current <- readOGR(dsn=paste(workspace,'SageGrouse/Sage-grouse_distribution_sgca',sep=''),'Sage-grouse_current_distribution_sgca')

# extraction <- overlay(current,hex.grid2)
extraction <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/centroids_current_distn.dbf',sep=''), as.is=TRUE)
extract.vector <- as.vector(extraction$CURRENT_ID)
extract.vector <- extract.vector[order(extraction$Hex_ID)]
extract.vector[is.na(extract.vector)==TRUE] <- 0
extract.vector[extract.vector>0] <- 1

# print(head(extract.vector))

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extract.vector)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/current.step0.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\current.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\current"',sep='')
shell(command)

# # =======================================================================================================
# # WGS 72 grid for cheatgrass data...

theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/albers_centroids_1km_cheatgrass2.dbf',sep=''), as.is=TRUE)
theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +ellps=WGS72 +no_defs')) 

cheatgrass <- raster(paste(workspace,'Cheatgrass/brte_present',sep=''))

extractedData <- extract(cheatgrass, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
extractedData[extractedData==1] <- 2
extractedData[extractedData==0] <- 1
extractedData[extractedData==2] <- 0

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/cheatgrass.step0.csv',sep=''),row.names=FALSE)

workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
# command <- paste('cd "',workspace2,'\\HexSim\\current HexSim Model\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\veg.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\Hexagons\\biomes.v2"',sep='')
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\cheatgrass.step0.csv" true true 1750 1859 true "',workspace2,'\\HexSim\\Workspaces\\',hexsimWorkspace,'\\Spatial Data\\Hexagons\\cheatgrass"',sep='')
shell(command)


# ===========================================================================================================
# Calculate available habitat per management zone.  Thinking about lek density.

biomes <- read.csv(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/veg.step0.csv',sep=''),header=TRUE)
m.zones <- read.csv(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/mgmt.zones.step0.csv',sep=''),header=TRUE)
human <- read.csv(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/human.foot.leu.r5km3.csv',sep=''),header=TRUE)
human1 <- human$extractedData2

print(table(biomes$extractedData[human1>0 & human1<80],m.zones$extract.vector[human1>0 & human1<80]))

sage <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/sagebrush.step0.csv',sep=''),header=TRUE)
print(table(sage$extractedData[human1>0 & human1<80],m.zones$extract.vector[human1>0 & human1<80]))
