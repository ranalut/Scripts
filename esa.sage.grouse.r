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
output.wksp <- 'F:/PNWCCVA_Data2/HexSim/'# 'H:/HexSim/' # 'E:/HexSim/' # 'D:/data/wilsey/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' 
output.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'H:\\HexSim' # 'E:\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'F:\\PNWCCVA_Data2\\HexSim'
spp.folder <- 'sage_grouse_v2'

hex.grid <- load.hex.grid(
		centroid.file="F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_lulc.dbf", # "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/Albers_Test3_1km/Spatial Data/albers_test3_centroids_1km.dbf', # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf',
		proj4='+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'
		)
hex.grid[[2]] <- SpatialPoints(hex.grid[[2]], proj4string=CRS('+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0'))

test<-nc.2.hxn(
		variable='lulc', 
		nc.file='h:/LULC/conus2099_r2b.tif', 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf,
		# changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,2,1,0,0,0)),ncol=2)), # grasslands steppe (8) and shrub steppe (9)
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='lulc.2099',
		dimensions=c(1750,1859)
		)
stop('cbw')

# hex.grid <- load.hex.grid(
		# centroid.file="F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf",# "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		# file.format='dbf',
		# proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		# )

# nc.2.hxn(
		# variable='biome', 
		# nc.file='h:/vegetation/26jul13_outputs/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_30-year_mean_2000.nc', # "H:/vegetation/wna30sec_1961-1990_biomes_DRAFT_v1.nc", 
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=Inf,
		# # changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,2,1,0,0,0)),ncol=2)), # grasslands steppe (8) and shrub steppe (9)
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='biomes.2000',
		# dimensions=c(1750,1859)
		# )

	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'H:/vegetation/26jul13_outputs/biome_modal_30yr_a2/' # 'S:/Space/Lawler/Shared/PNWCCVA-VegetationData/26jul13_outputs/biome_modal_30yr_a2/'
	file.name <- c('wna30sec_a2_','_biome_30-year_mean_')
	# variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 1:5)
	# for (i in 2)
	{
		startTime <- Sys.time()

		# for (j in 1:99)
		for (j in 99)
		{
						
			nc.2.hxn(
				variable='biome', 
				nc.file=paste(file.path,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf,
				# changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,2,1,0,0,0)),ncol=2)),
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.2099',sep=''),
				dimensions=c(1750,1859)
				)
		}
	}
	
	