library(ncdf)
library(rgdal)
library(raster)
library(foreign)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

# startTime <- Sys.time()
theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_nad27Albers.dbf',sep=''), as.is=TRUE)
# cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.

theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# print(head(theCentroids)); stop('cbw')
# theData <- theCentroids
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=aea +lat_1=38 +lat_2=41 +lat_0=34 +lon_0=-114 +x_0=0 +y_0=0 +datum=NAD27 +ellps=clrk66 +units=m +no_defs')) #,data=theCentroids)

#######################################################
# Lek components (units)
components <- readOGR(dsn=paste(workspace,'SageGrouse/sg_components',sep=''),'sg_components')

# startTime <- Sys.time()
extraction <- overlay(components,hex.grid)
extract.vector <- as.vector(extraction$dPC100k)
extract.vector[is.na(extract.vector)==TRUE] <- 0
extract.vector[extract.vector>0] <- 1

print(head(extract.vector))

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extract.vector)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/components.step0.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\components.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\Hexagons\\components"',sep='')
shell(command)
cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...

########################################################
# # Sagebrush
# sage90m <- raster(paste(workspace,'SageGrouse/allsage_90m/allsage_90m/allsage_90m',sep=''))

# extractedData <- extract(sage90m, hex.grid)
# extractedData[is.na(extractedData)==TRUE] <- 0

# dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
# write.csv(dataDump, paste(workspace,'HexSim/Workspaces/sage_grouse_v1/Spatial Data/sagebrush.step0.csv',sep=''),row.names=FALSE)

# # startTime <- Sys.time()
# workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
# command <- paste('cd "',workspace2,'\\HexSim\\current HexSim Model\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\sagebrush.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v1\\Spatial Data\\Hexagons\\sagebrush.v1"',sep='')
# shell(command)
# # cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...

#######################################################
# Management Zones
mgmt.zones <- readOGR(dsn=paste(workspace,'SageGrouse/SG_MgmtZones_ver2_20061018',sep=''),'SG_MgmtZones_ver2_20061018')

# startTime <- Sys.time()
extraction <- overlay(mgmt.zones,hex.grid)
extract.vector <- as.vector(extraction$Zone)
extract.vector[is.na(extract.vector)==TRUE] <- 0
# extract.vector[extract.vector>0] <- 1

print(head(extract.vector))

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extract.vector)
write.csv(dataDump, paste(workspace,'HexSim/Workspaces/sage_grouse_v2/Spatial Data/mgmt.zones.step0.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\mgmt.zones.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\sage_grouse_v2\\Spatial Data\\Hexagons\\mgmt.zones.v1"',sep='')
shell(command)
cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
