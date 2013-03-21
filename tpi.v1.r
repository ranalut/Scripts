library(ncdf)
library(rgdal)
library(raster)

workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
setwd(paste(workspace,'Scripts/',sep=''))

startTime <- Sys.time()
# theCentroids <- read.csv(paste(workspace,'HexSim/Workspaces/Albers_Test3_1km/Spatial Data/centroids84.txt',sep=''), header=TRUE)
cat(Sys.time()-startTime, 'minutes to load file', '\n') # about 4 minutes.
# stop('cbw')

# theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)

climate <- raster(paste(workspace,'GMTED2010-GlobalDEM/TPI_r3',sep=''))
# plot(climate)

print(summary(climate))

