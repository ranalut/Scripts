
# =========================================================================================
# Generate HexMaps from spatial data layers for the lynx workspace.
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
spp.folder <- 'lynx_v1'

run.hex.grid <- 		'y'
run.historical.swe <- 	'n'
run.historical.fire <- 	'n'	# Not going to include this
run.biomes <- 			'y'
run.streams <- 			'n' # Not including this
run.initial <- 			'n'
run.exclusion <- 		'n'
run.coastal <- 			'n'
run.future.swe <- 		'n'	# Copied these hexmaps from Spotted Frog workspace.
run.water.excl <-		'n'
run.eco.reg <- 			'n'
run.hfp <- 				'n'
run.all.huc <- 			'n'
run.pa <- 				'n'

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

# ==============================================================================================================
# Historical SWE

if (run.historical.swe=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'snowfall_swe_ann'
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1970+j),'.nc',sep='') } # Only for the final 30 years of the century, similar to biomes data.
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='swe',
		month='ann'
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_swe_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_ann/mean_swe_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.ann.71.00'
		)

	nc.2.hxn(
		variable='sd_swe_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_ann/sd_swe_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.ann.71.00'
		)
}
# stop('cbw')

# ==========================================================================================================
# Biomes
if (run.biomes=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'H:/vegetation/26jul13_outputs/biome_modal_30yr_a2/'
	file.name <- c('wna30sec_a2_','_biome_30-year_mean_')
	# variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 3:5)
	# for (i in 1)
	{
		startTime <- Sys.time()

		for (j in 1:99)
		# for (j in 1)
		{
			# test <- file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2.v3/',theGCMs[i],'.biomes.a2.v3.',(10+j),'.hxn',sep=''))
			# if(test==TRUE) { cat(theGCMs[i],j,'\n'); next(j) }
			
			nc.2.hxn(
				variable='biome', 
				nc.file=paste(file.path,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf,
				changeTable=data.frame(matrix(c(seq(1,12,1),c(0,1,1,0,0.75,0.75,0,0,0,0,0,0)),ncol=2)),
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2.v3',sep='')
				)
			
			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2.v3/',theGCMs[i],'.biomes.a2.v3.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2.v3/',theGCMs[i],'.biomes.a2.v3.',(10+j),'.hxn',sep=''),
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
			changeTable=data.frame(matrix(c(seq(1,12,1),c(0,1,1,0,0.75,0.75,0,0,0,0,0,0)),ncol=2)),
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(theGCMs[i],'.biomes.a2.v3',sep='')
			)
		# stop('cbw')
	}
}

# ==========================================================================================================
# Initial Dist Map

if (run.initial=='y')
{
	nc.2.hxn(
		variable='presence', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/initial_dist.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='initial.dist'
		)
}	
# stop('cbw')

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
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='protected.areas'
		)
}	
# stop('cbw')

# ==========================================================================================================
# Coastal vs. Interior Map

if (run.coastal=='y')
{
	nc.2.hxn(
		variable='presence', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/coast_interior.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='coast.interior'
		)
}	

# ==========================================================================================================
# Water Exclusion

if (run.water.excl=='y')
{
	# nc.2.hxn(
		# variable='lake', 
		# nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/pnw_lakes4_wgs84.nc",
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=Inf, 
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='lakes4'
		# )
		
	# nc.2.hxn(
		# variable='water', 
		# nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/mask_water.nc",
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=Inf, 
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mask.water'
		# )
		
	nc.2.hxn(
		variable='exclude', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/exclude.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mask.hucs'
		)
}

# ==========================================================================================================
# Human Footprint

if (run.hfp=='y')
{
	nc.2.hxn(
		variable='hfp', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/hfp_2005.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='hfp'
		)
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
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='all.huc.2'
		)
}

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
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='eco.reg'
		)
}

# ==========================================================================================================
# Exclusion SW Range

if (run.exclusion=='y')
{
	nc.2.hxn(
		variable='sw_range', 
		nc.file="F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Spatial Data/sw_range3.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sw.range3'
		)
}	

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
				file.path.out=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_max_',(2000+j),'.nc',sep=''),
				month=13,
				max.value=5000
				)
			# stop('cbw')
			
			nc.2.hxn(
				variable='swe_max', 
				nc.file=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_max_',(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=2000, 
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.max.swe',sep='')
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.',(10+j),'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Replace timestep 1 with historical mean.
		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.swe.max/mean.swe.max.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.1.hxn',sep=''),
			overwrite=TRUE
			)
	}
}

# ==============================================================================================================
# Historical Fire Fraction

if (run.historical.fire=='y')
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

