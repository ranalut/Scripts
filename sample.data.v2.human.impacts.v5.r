library(ncdf)
library(rgdal)
library(raster)
library(foreign)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

# Centroids for NAD 1927 Albers
# startTime <- Sys.time()
# theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids27Albers.txt',sep=''), header=TRUE)
theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_nad27Albers.dbf',sep=''), as.is=TRUE)
# cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.

theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# print(head(theCentroids)); stop('cbw')
# theData <- theCentroids
# This is what I found for PROJ4 on SpatialReference.org '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=clrk66 +units=m +no_defs'
# I substituted some parameters based on the spatial reference information for the Leu coverage.
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=aea +lat_1=38 +lat_2=41 +lat_0=34 +lon_0=-114 +x_0=0 +y_0=0 +datum=NAD27 +ellps=clrk66 +units=m +no_defs'))
print('hex.grid loaded')

# ============================================================================================================
# Leu et al human impacts, Western US

human.impacts <- raster(paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus',sep=''))

# startTime <- Sys.time()
# focalData <- focal(human.impacts, w=5, fun=mean, progress='text')
# writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_5x5.img',sep='')) # This is a 900m radius or about 1km.  This could work for squirrels, rabbits, and kangaroo rats
# focalData <- focal(human.impacts, w=55, fun=median, progress='text')
# writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r5km.img',sep='')) # This is a 5km radius.
focalData <- raster(paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r5km.img',sep=''))
# focalData <- focal(human.impacts, w=100, fun=median, progress='text')
# writeRaster(focalData,paste(workspace,'HumanImpacts/HF_Leu_etal/hf_wus_focal_mean_r18km.img',sep='')) # This is a 18km radius.

extractedData <- extract(focalData, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/human.foot.leu.r5km1.csv',sep=''),row.names=FALSE)
# stop('cbw: check .csv file')
dataDump2 <- dataDump
# dataDump <- read.csv(paste(workspace,'HexSim/Workspaces/sage_grouse_v1/Spatial Data/human.foot.leu.v3.csv',sep=''),header=TRUE)
dataDump2$extractedData[dataDump2$extractedData > 8] <- 0 # remove non-habitat, heavily impacted habitats.
write.csv(dataDump2, paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/human.foot.leu.r5km2.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\human.foot.leu.r5km1.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\Hexagons\\human_foot_leu_5km1"',sep='')
shell(command)
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\human.foot.leu.r5km2.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\Hexagons\\human_foot_leu_5km2"',sep='')
shell(command)
# cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # This took a long time +20 minutes...
