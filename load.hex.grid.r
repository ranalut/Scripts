library(ncdf)
library(rgdal)
library(raster)
library(foreign)

load.hex.grid <- function(centroid.file, file.format, proj4)
{
	if (file.format=='dbf') { theCentroids <- read.dbf(centroid.file, as.is=TRUE) }
	if (file.format=='txt') { theCentroids <- read.csv(centroid.file, header=TRUE) }
	
	cat(Sys.time()-startTime, 'minutes to load file', '\n')

	theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
	# print(head(theCentroids)); stop('cbw')

	hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS(proj4))
	return(hex.grid)
}

# WGS 84
# hex.grid <- load.hex.grid(centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',file.format='txt',proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

# Truncated sage grouse study area...
# hex.grid <- load.hex.grid(centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf',file.format='dbf',proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

