library(ncdf)
library(rgdal)
library(raster)
library(foreign)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')

# startTime <- Sys.time()
# theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids84.txt',sep=''), header=TRUE)
theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf',sep=''), as.is=TRUE)
# cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.

theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
print(dim(theCentroids)); stop('cbw')
# print(head(theCentroids)); stop('cbw')
# theData <- theCentroids
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

# startTime <- Sys.time()
extractedData <- extract(biomes, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

# Reclassify values...
# Sarah's classes: 1, temperate forest; 2, boreal forest; 3, open forest/woodland w/ broadleaf; 4, open forest/woodland; 5, grassland; 6, shrubland; 7, barren.
# Translation to vireo classes:
# 1 to 0
# 2 to 0
# 3 to 0
# 4 to 0
# 5 to 1
# 6 to 1
# 7 to 0

extractedData[extractedData %in% c(1:4,7)] <- 0
extractedData[extractedData==5] <- 1
extractedData[extractedData==6] <- 1

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/veg.step0.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
# command <- paste('cd "',workspace2,'\\HexSim\\current HexSim Model\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\veg.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\Hexagons\\biomes.v2"',sep='')
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\veg.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\Hexagons\\biomes.v2"',sep='')
shell(command)
# cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
