library(ncdf)
library(rgdal)
library(raster)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')

startTime <- Sys.time()
theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids84.txt',sep=''), header=TRUE)
cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.

theCentroids <- theCentroids[,c('HEX_ID','POINT_X','POINT_Y')]
# print(head(theCentroids)); stop('cbw')
# theData <- theCentroids
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

startTime <- Sys.time()
extractedData <- extract(biomes, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'VegProjections/veg.step0.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\current HexSim Model\\" && HexMapConverter.exe "',workspace2,'\\VegProjections\\veg.step0.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\Albers_Test3_1km\\Spatial Data\\Hexagons\\biomes"',sep='')
shell(command)
cat(Sys.time()-startTime, 'minutes to create Hexmap', '\n') # 1.09 minutes...
