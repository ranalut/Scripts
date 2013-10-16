
# =========================================================================================
# Generate HexMaps from spatial data layers for the Townsend's ground squirrel workspace.
# =========================================================================================

# ========================================================================================
# Load packages and scripts, set workspace
library(ncdf)
library(rgdal)
library(raster)
library(foreign)

# setwd('F:/PNWCCVA_Data2/Scripts/')
# setwd('C:/Users/cbwilsey/Documents/PostDoc/Scripts/')
setwd('C:/Users/cbwilsey/Documents/GitHub/Scripts/')

source('extract.swe.r')
source('load.hex.grid.r')
source('netcdf.2.hexmap.r')
source('plot.raster.stack.r')

# Settings for this run.

hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/' # 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/'
hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'C:\\Users\\cbwilsey\\Documents\\Postdoc\\HexSim'
output.wksp <- 'F:/PNWCCVA_Data2/HexSim/' #'H:/HexSim/' #'E:/HexSim/'
output.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' #'H:\\HexSim' # 'E:\\HexSim'
spp.folder <- 'town_squirrel_v1'

run.hex.grid <- 		'y'
run.historical.swe <- 	'n'
run.hist.deficit <- 	'n'
run.hist.biomes <-		'n'
run.biomes <- 			'n'
# run.initial <- 		'n' # Not updated for squirrel
run.future.swe <- 		'n'
run.defict <- 			'n' # Need to resample for new grid
run.fire <- 			'n' # May need to add this

startTime <- Sys.time()

# Used for visualization of outputs...
# plot(raster('e:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/swe_max_1906.nc'),main='1906')
# plot(raster('e:/bioclimate/annual/a2/snowfall_swe_balance_first_day_of_month_a2/swe_max_2001.nc'),main='2001')

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file="F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/Spatial Data/albers_centroids_1km_wgs84.dbf", #'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt', #'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/centroids84.txt',  
		file.format='dbf',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}
# ==========================================================================================================
# Biomes

if (run.hist.biomes=='y')
{
	nc.2.hxn(
		variable='biome_modal_30yr', 
		nc.file='h:/vegetation/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_modal_30yr_2000.nc', # "H:/vegetation/wna30sec_1961-1990_biomes_DRAFT_v1.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf,
		changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,1,1,0,0,0)),ncol=2)), # grasslands steppe (8) and shrub steppe (9)
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='biomes2',
		dimensions=c(1750,1859)
		)
}	

# Biomes
if (run.biomes=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'H:/vegetation/26jul13_outputs/biome_modal_30yr_a2/'
	file.name <- c('wna30sec_a2_','_biome_30-year_mean_')
	# variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 1:5)
	# for (i in 1)
	{
		startTime <- Sys.time()

		for (j in 1:99)
		# for (j in 1)
		{
			test <- file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2/',theGCMs[i],'.biomes.a2.',(10+j),'.hxn',sep=''))
			if(test==TRUE) { cat(theGCMs[i],j,'\n'); next(j) }
			
			nc.2.hxn(
				variable='biome', 
				nc.file=paste(file.path,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf,
				changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,1,1,0,0,0)),ncol=2)),
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2',sep=''),
				dimensions=c(1750,1859)
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2/',theGCMs[i],'.biomes.a2.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2/',theGCMs[i],'.biomes.a2.',(10+j),'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Present-day
		nc.2.hxn(
			variable='biome', 
			nc.file="H:/vegetation/26jul13_outputs/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_30-year_mean_2000.nc", 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=Inf,
			changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,1,1,0,0,0)),ncol=2)),
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(theGCMs[i],'.biomes.a2',sep=''),
			dimensions=c(1750,1859)
			)
	}
}


# ==========================================================================================================
# Initial Dist Map

if (run.initial=='y')
{
	nc.2.hxn(
		variable='presence', 
		nc.file="C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/spotted_frog_v2/Spatial Data/initial_dist.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='initial.dist'
		)
}	
# stop('cbw')


# ==============================================================================================================
# Historical SWE

if (run.historical.swe=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'snowfall_swe_balance'

	for (j in 5:100)
	{
		extract.swe(
			file.path.in=paste(file.path,variable.folders,file.name,variable.folders,'_first_day_of_month_',(1900+j),'.nc',sep=''),
			file.path.out=paste(file.path,variable.folders,'/swe_mar_',(1900+j),'.nc',sep=''),
			month=3,
			max.value=5000
			)
		# stop('cbw')
	}
	
	all.file.paths <- list()
	for (j in 1:96) { all.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_mar_',(1904+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='swe',
		month='mar'
		)
	
	# stop('cbw')

		# Create the HexMap
	nc.2.hxn(
		variable='mean_swe_mar', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.mar',
		dimensions=c(1750,1859)
		)

	nc.2.hxn(
		variable='sd_swe_mar', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.mar',
		dimensions=c(1750,1859)
		)
}
# stop('cbw')

# ==============================================================================================================
# Historical Deficit

if (run.hist.deficit=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS2.1_lpj_'
	variable.folders <- 'afirefrac'
	
	all.file.paths <- list()
	for (j in 1:100) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1900+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='firefrac',
		month='ann'
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_firefrac_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/afirefrac/mean_firefrac_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.fire.ann'
		)

	nc.2.hxn(
		variable='sd_firefrac_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/afirefrac/sd_firefrac_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.fire.ann'
		)
}
# stop('cbw')

