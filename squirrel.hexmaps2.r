
# =========================================================================================
# Generate HexMaps from spatial data layers for the Greater sage-grouse workspace.
# Many of the spatial data was created in the rabbit_v1 workspace and copied over.
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

hexsim.wksp <- 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'H:/HexSim/' # 'E:/HexSim/' # 'D:/data/wilsey/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' 
output.wksp2 <- 'H:\\HexSim' # 'E:\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'F:\\PNWCCVA_Data2\\HexSim'
spp.folder <- 'town_squirrel_v1'

run.hex.grid.distn <- 	'y'
run.distn <- 			'y'
run.hex.grid <- 		'n'

# Run in rabbit.hexmaps.r
# run.hex.grid.lulc <- 	'n'
# run.lulc <- 			'n'
# run.hist.lulc <- 		'n'
# run.hex.grid <-			'y'
# run.move.ave <-			'n'
# run.biomes <- 			'n'
# run.hist.biomes <- 		'n'
# run.water <- 			'n'
# run.all.huc <- 			'y'
# run.pa <- 				'y'
# run.eco.reg <- 			'y'

startTime <- Sys.time()

# Used for visualization of outputs...
# plot(raster('e:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/swe_max_1906.nc'),main='1906')
# plot(raster('e:/bioclimate/annual/a2/snowfall_swe_balance_first_day_of_month_a2/swe_max_2001.nc'),main='2001')


if (run.hex.grid.distn=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file="H:/HexSim/Workspaces/sage_grouse_v3/Spatial Data/albers_centroids_1km.dbf",# "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf',
		proj4='+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'
		# '+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		# '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs' 
		)
}

# ==========================================================================================================
# Modeled Distribution

if (run.distn=='y')
{
	temp <- raster("H:/SpatialData/USGS GAP national/town_complex")
	temp2 <- aggregate(temp, fact=30, fun=sum, expand=FALSE, na.rm=TRUE, filename="H:/SpatialData/USGS GAP national/town_complex_900")
	
	nc.2.hxn(
		variable=NA, 
		nc.file=temp2, 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		# buffer=500, fun=sum,
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='town',
		dimensions=c(1750,1859)
		)
}

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file="F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf",# "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}
	
# stop('cbw')

