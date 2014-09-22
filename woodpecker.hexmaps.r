
# =========================================================================================
# Generate HexMaps from spatial data layers for the nutcracker workspace.
# =========================================================================================

# ========================================================================================
# Load packages and scripts, set workspace
library(ncdf)
library(rgdal)
library(raster)
library(foreign)

source('extract.swe.r')
source('load.hex.grid.r')
source('netcdf.2.hexmap.r')
source('plot.raster.stack.r')

# Settings for this run.

hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'H:/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'H:/HexSim/' # 'E:/HexSim/' # 'D:/data/wilsey/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' 
output.wksp2 <- 'H:\\HexSim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\PostDoc\\HexSim' # 'H:\\HexSim' # 'E:\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'F:\\PNWCCVA_Data2\\HexSim'

spp.folder <- 'woodpecker_v1'

run.hex.grid.distn <- 	'n'
run.distn <- 			'n'
run.hex.grid <- 		'y'
run.canada <- 			'y'


startTime <- Sys.time()

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid.distn=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v1/Spatial Data/albers_test3_centroids_1km.dbf', # "F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km.dbf",# "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf', # 'txt' # 'dbf'
		proj4='+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'
		# '+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		# '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs' 
		)
}
# Testing
# hex.grid[[1]] <- hex.grid[[1]][1673100:1674100,]; hex.grid[[2]] <- hex.grid[[2]][1673100:1674100,]; stop('cbw')

# ==========================================================================================================
# Modeled Distribution

if (run.distn=='y')
{
	temp <- raster("H:/SpatialData/USGS GAP national/Pic_alb_WHWOx_Model/Pic_alb_whwox")
	temp2 <- aggregate(temp, fact=30, fun=sum, expand=FALSE, na.rm=TRUE, filename="H:/SpatialData/USGS GAP national/Pic_alb_WHWOx_Model/Pic_alb_whwox_900", overwrite=TRUE)
	
	nc.2.hxn(
		variable=NA, # 'bra_ida_pyrax', 
		nc.file=temp2, # "H:/SpatialData/USGS GAP national/Bra_ida_PYRAx_Model (2)/bra_ida_900", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		# buffer=500, fun=sum,
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='woodpecker',
		dimensions=c(3131,2075) # c(1750,1859)
		)
}
# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt', # "L:/Space_Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/nutcracker_v1/Spatial Data/centroids84.txt", 
		# "F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # "L:/Space_Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", 
		# 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='txt',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}

# ===================================
# Canada

if (run.canada=='y')
{
	nc.2.hxn(
		variable='pico_albo', 
		nc.file="H:/SpatialData/USGS GAP national/pico_albo_CAN.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='canada2',
		dimensions=c(3131,2075) # c(1750,1859)
		)
}

