
# =========================================================================================
# Generate HexMaps from spatial data layers for the wolverine workspace.
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
output.wksp <- 'F:/PNWCCVA_Data2/HexSim/' #'E:/HexSim/'
output.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'E:\\HexSim'
spp.folder <- 'wolverine_v1'

run.hex.grid <- 		'y'
run.historical.swe <- 	'n'
run.historical.mtwa <-  'n'
run.biomes <- 			'n'
run.initial <- 			'n'
run.exclusion <- 		'n'
run.future.swe <- 		'y'

startTime <- Sys.time()

# Used for visualization of outputs...
# plot(raster('e:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/swe_max_1906.nc'),main='1906')
# plot(raster('e:/bioclimate/annual/a2/snowfall_swe_balance_first_day_of_month_a2/swe_max_2001.nc'),main='2001')

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt', #'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/centroids84.txt',  
		file.format='txt',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}

# ==========================================================================================================
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
				changeTable=data.frame(matrix(c(seq(1,12,1),c(2,2,1,0,2,1,0,0,0,0,0,0)),ncol=2)),
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2',sep='')
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
			changeTable=data.frame(matrix(c(seq(1,12,1),c(2,2,1,0,2,1,0,0,0,0,0,0)),ncol=2)),
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(theGCMs[i],'.biomes.a2',sep='')
			)
	}
}
# # ==========================================================================================================
# # Biomes

# if (run.biomes=='y')
# {
	# nc.2.hxn(
		# variable='biome_modal_30yr', 
		# nc.file='h:/vegetation/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_modal_30yr_2000.nc', # "H:/vegetation/wna30sec_1961-1990_biomes_DRAFT_v1.nc", 
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=Inf,
		# changeTable=data.frame(matrix(c(seq(1,12,1),c(2,2,1,0,2,1,0,0,0,0,0,0)),ncol=2)),
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='biomes2'
		# )
# }	

# ==========================================================================================================
# Initial Dist Map

if (run.initial=='y')
{
	nc.2.hxn(
		variable='presence', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/wolverine_v1/Spatial Data/gulo_dist1.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='initial.dist'
		)
}	
# stop('cbw')

# ==========================================================================================================
# Exclusion SW Range

if (run.exclusion=='y')
{
	nc.2.hxn(
		variable='presence', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/wolverine_v1/Spatial Data/se_range.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='se.range'
		)
}	

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
			file.path.out=paste(file.path,variable.folders,'/swe_may_',(1900+j),'.nc',sep=''),
			month=5,
			max.value=5000
			)
		# stop('cbw')
	}
	
	all.file.paths <- list()
	for (j in 1:96) { all.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_may_',(1904+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='swe',
		month='may'
		)
	
	# stop('cbw')

		# Create the HexMap
	nc.2.hxn(
		variable='mean_swe_may', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_may.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.may'
		)

	nc.2.hxn(
		variable='sd_swe_may', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_may.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.may'
		)
}
# stop('cbw')

# ==============================================================================================================
# Historical MTWA

if (run.historical.mtwa=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'mtwa'
	
	all.file.paths <- list()
	for (j in 1:100) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1900+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='mtwa',
		month='ann'
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_mtwa_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/mtwa/mean_mtwa_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.mtwa'
		)

	nc.2.hxn(
		variable='sd_mtwa_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/mtwa/sd_mtwa_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.mtwa'
		)
}
# stop('cbw')


# ========================================================================================================
# Calculating Deficit from AET and PET and writing deficit to netCDF files...

# See 'spotted.frog.hexmaps.v6.r' for this script.  I did not redo the code since I'd already run it the old way.


# ==========================================================================================================
# Making hexmaps from SWE projections

if (run.future.swe=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'H:/bioclimate/annual/a2/' # 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('/wna30sec_a2_','_snowfall_swe_balance_first_day_of_month_')
	variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 1:5)
	{
		startTime <- Sys.time()

		for (j in 1:99)
		# for (j in 1)
		{
			extract.swe(
				file.path.in=paste(file.path,variable.folders,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''),
				file.path.out=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_may_',(2000+j),'.nc',sep=''),
				month=5,
				max.value=5000
				)
			# stop('cbw')
			
			nc.2.hxn(
				variable='swe_may', 
				nc.file=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_may_',(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=2000, 
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.may.swe',sep='')
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.may.swe/',theGCMs[i],'.may.swe.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.may.swe/',theGCMs[i],'.may.swe.',(10+j),'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Replace timestep 1 with historical mean.
		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.swe.may/mean.swe.may.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.may.swe/',theGCMs[i],'.may.swe.1.hxn',sep=''),
			overwrite=TRUE
			)
	}
}
