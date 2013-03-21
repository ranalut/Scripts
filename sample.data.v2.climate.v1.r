library(ncdf)
library(rgdal)
library(raster)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

startTime <- Sys.time()
# theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids84.txt',sep=''), header=TRUE)
cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.
# stop('cbw')

theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# print(head(theCentroids)); stop('cbw')
# theData <- theCentroids
hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

# climate <- raster(paste(workspace,'ClimateData/netCDF/wna30sec_a1b_CCCMA_CGCM3.1(T47)_mtwa_2001_test.nc',sep=''), band=1)
climate <- raster(paste(workspace,'ClimateData/netCDF/wna30sec_a1b_CCCMA_CGCM3.1(T47)_mtwa_2001_test.nc',sep=''), varname='mtwa')
# plot(climate)

startTime <- Sys.time()
extractedData <- extract(climate, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste(workspace,'ClimateData/a1b.cgcm.mtwa.step2001.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'C:\\Users\\cbwilsey\\Documents\\PostDoc'
command <- paste('cd "',workspace2,'\\HexSim\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\ClimateData\\a1b.cgcm.mtwa.step2001.csv" true true 3131 2075 true "',workspace2,'\\HexSim\\Workspaces\\Albers_Test3_1km\\Spatial Data\\Hexagons\\a1b.cgcm.mtwa.2001"',sep='')
shell(command)
cat(Sys.time()-startTime, 'minutes to create Hexmap', '\n') # 1.09 minutes...
