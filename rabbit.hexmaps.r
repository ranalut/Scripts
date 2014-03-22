
# =========================================================================================
# Generate HexMaps from spatial data layers for the pygmy rabbit workspace.
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

hexsim.wksp <- 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'H:/HexSim/' # 'E:/HexSim/' # 'D:/data/wilsey/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' 
output.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\PostDoc\\HexSim' # 'H:\\HexSim' # 'E:\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'F:\\PNWCCVA_Data2\\HexSim'
spp.folder <- 'rabbit_v1'

run.hex.grid.distn <- 	'n'
run.distn <- 			'n'
run.hex.grid <-			'y'
run.move.ave <-			'n'
run.biomes <- 			'n'
run.hist.biomes <- 		'y'
run.initial <- 			'n' # Not updated for squirrel
run.fire <- 			'n' # May need to add this
run.all.huc <- 			'n'
run.pa <- 				'n'
run.eco.reg <- 			'n'

startTime <- Sys.time()

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid.distn=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file="F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km.dbf",# "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf',
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
	temp <- raster("H:/SpatialData/USGS GAP national/Bra_ida_PYRAx_Model (2)/bra_ida_pyrax")
	temp2 <- aggregate(temp, fact=30, fun=sum, expand=FALSE, na.rm=TRUE, filename="H:/SpatialData/USGS GAP national/Bra_ida_PYRAx_Model (2)/bra_ida_900")
	
	nc.2.hxn(
		variable=NA, # 'bra_ida_pyrax', 
		nc.file=temp2, # "H:/SpatialData/USGS GAP national/Bra_ida_PYRAx_Model (2)/bra_ida_900", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		# buffer=500, fun=sum,
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='pyra2',
		dimensions=c(1750,1859)
		)
}

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file="L:/Space_Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # "F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf",# "S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}

# ==========================================================================================================
# Biomes
if (run.biomes=='y')
{
	source('veg.file.paths.r')
	source('time.series.2.hexmaps.r')
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

	for (i in 1:5)
	{
		startTime <- Sys.time()
		the.names <- build.paths(theGCM=theGCMs[i])
		cat('built names\n')

		hexmap.time.series(
			the.names=the.names, 
			output.wksp=output.wksp, spp.folder=spp.folder, 
			theGCM=theGCMs[i], 
			hexmap.base.name='hist.biome', 
			hex.grid=hex.grid, 
			variable='biomes.a2',
			end.yr=NA
			)
	}
	source('veg.file.paths.r')
	
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	
	# file.path <- 'L:/Lawler_Share/pnwccva-vegetationdata/26jul13_outputs/biome_modal_30yr_a2/' # 'H:/vegetation/26jul13_outputs/biome_modal_30yr_a2/'
	# file.name <- c('wna30sec_a2_','_biome_30-year_mean_')
	# variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 1:5)
	# for (i in 1)
	{
		startTime <- Sys.time()
		the.names <- build.paths(theGCM=theGCMs[i])
		cat('built names\n')

		for (j in 2:length(the.names))
		# for (j in 1)
		{
			test <- file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2/',theGCMs[i],'.biomes.a2.',j,'.hxn',sep=''))
			if(test==TRUE) { cat(theGCMs[i],j,'\n'); next(j) }
			
			nc.2.hxn(
				variable='biome', 
				nc.file=the.names[j], 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf,
				changeTable=NA,
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2',sep=''),
				dimensions=c(1750,1859)
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2/',theGCMs[i],'.biomes.a2.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2/',theGCMs[i],'.biomes.a2.',j,'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Present-day
		nc.2.hxn(
				variable='biome', 
				nc.file=the.names[1], 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf,
				changeTable=NA,
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2',sep=''),
				dimensions=c(1750,1859)
				)

	}
}

# Just historical biomes
if (run.hist.biomes=='y')
{
	source('veg.file.paths.r')
	source('time.series.2.hexmaps.r')
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

	for (i in 1)
	{
		startTime <- Sys.time()
		the.names <- build.paths(theGCM=theGCMs[i])
		cat('built names\n')

		hexmap.time.series(
			the.names=the.names, 
			output.wksp=output.wksp, spp.folder=spp.folder, 
			theGCM=theGCMs[i], 
			hexmap.base.name='hist.biome', 
			hex.grid=hex.grid, 
			variable='biome',
			end.yr=40 # NA
			)
	}
}
# ==========================================================================================
if (run.move.ave=='y') # Make this a separate script, perhaps a function and apply to other variables.
{
  source('move.ave.r')
  source('move.ave.file.paths.r')
  theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
  hexmap.names <- c('ave.def.mam.','ave.fire.','ave.mtco.','ave.mtwa.')
  
  for (i in 2:length(theGCMs))
  {
    for (n in 2:length(hexmap.names))
    {
      the.names <- build.paths(var.index=n, theGCM=theGCMs[i])
      # print(the.names); stop('cbw')
      move.ave(
        the.names=the.names, 
        hex.grid=hex.grid, 
        theGCM=theGCMs[i], 
        hexmap.name=hexmap.names[n],
        spp.folder=spp.folder,
        hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2
        )
    }
    file.remove(dir("C:/Documents and Settings/cbwilsey/Local Settings/Temp/4/R_raster_tmp/cbwilsey",full.names=TRUE))
  }
}

# ==========================================================================================================
# HUCS

if (run.all.huc=='y')
{
	nc.2.hxn(
		variable='CBW_CODE', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/all_hucs2.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='all.huc.2',
		dimensions=c(1750,1859)
		)
}

# ==========================================================================================================
# Protected Areas

if (run.pa=='y')
{
	nc.2.hxn(
		variable='objectid', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/pa.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='protected.areas',
		dimensions=c(1750,1859)
		)
}	
# stop('cbw')

# ==========================================================================================================
# Ecoregions

if (run.eco.reg=='y')
{
	nc.2.hxn(
		variable='eco_id', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/tnc_eco_v1.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='eco.reg',
		dimensions=c(1750,1859)
		)
}

