
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
# setwd('C:/Users/cbwilsey/Documents/GitHub/Scripts/')

source('extract.swe.r')
source('load.hex.grid.r')
source('netcdf.2.hexmap.r')
source('plot.raster.stack.r')

# Settings for this run.
# Lawler-Compute
hexsim.wksp <- 'S:/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/' 
hexsim.wksp2 <- 'S:\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim' 
output.wksp <- 'd:/data/wilsey/hexsim/' 
output.wksp2 <- 'd:\\data\\wilsey\\hexsim'
# Tower
# hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/' # 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/'
# hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'C:\\Users\\cbwilsey\\Documents\\Postdoc\\HexSim'
# output.wksp <- 'I:/HexSim/' #'E:/HexSim/'
# output.wksp2 <- 'I:\\HexSim' # 'E:\\HexSim'

spp.folder <- 'fisher_v1'

run.hex.grid <- 		'n'
run.historical.swe <- 	'n'
run.hist.t.djf <-  		'n'
run.biomes <- 			'n'
run.biomes.hist <- 		'n'
run.initial <- 			'n'
run.exclusion <- 		'n'
run.future.swe <- 		'n'
run.future.t.djf <- 	'y'

# startTime <- Sys.time()

# Used for visualization of outputs...
# plot(raster('e:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/swe_max_1906.nc'),main='1906')
# plot(raster('e:/bioclimate/annual/a2/snowfall_swe_balance_first_day_of_month_a2/swe_max_2001.nc'),main='2001')

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		# centroid.file="S:/Space/Lawler/Shared/Wilsey/Postdoc/HexSim/Workspaces/centroids84.txt",  
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
				changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,1,1,0,1,1,0,0,0,0,0)),ncol=2)),
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2',sep=''),
				dimensions=c(3131,2075)
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
			changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,1,1,0,1,1,0,0,0,0,0)),ncol=2)),
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(theGCMs[i],'.biomes.a2',sep=''),
			dimensions=c(3131,2075)
			)
	}
}
# # ==========================================================================================================
# Biomes

if (run.biomes.hist=='y')
{
	nc.2.hxn(
		variable='biome', 
		nc.file='h:/vegetation/26jul13_outputs/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_30-year_mean_2000.nc', 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf,
		changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,1,1,0,1,1,0,0,0,0,0)),ncol=2)),
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='biomes3',
		dimensions=c(3131,2075)
		)
}	

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
	variable.folders <- 'snowfall_swe_ann'
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1960+j),'.nc',sep='') } # Only the last 30 years, same as vegetation
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='snowfall_swe',
		month='ann'
		)
	
	# stop('cbw')

		# Create the HexMap
	nc.2.hxn(
		variable='mean_snowfall_swe_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_ann/mean_snowfall_swe_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=5000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.ann.61.90',
		dimensions=c(3131,2075)
		)

	nc.2.hxn(
		variable='sd_snowfall_swe_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_ann/sd_snowfall_swe_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=5000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.ann.61.90',
		dimensions=c(3131,2075)
		)
}
# stop('cbw')

# ==========================================================================================================
# Making hexmaps from SWE projections

if (run.future.swe=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- "S:/Space/Lawler/Shared/pnwccva-climatedata/annual/a2/" # 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('/wna30sec_a2_','_snowfall_swe_ann_')
	variable.folders <- 'snowfall_swe_ann_a2'

	for (i in 1:5) # 1:5
	{
		startTime <- Sys.time()

		for (j in 1:99)
		# for (j in 1)
		{	
			nc.2.hxn(
				variable='snowfall_swe_ann', 
				nc.file=paste(file.path,variable.folders,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf, 
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.swe.ann',sep=''),
				dimensions=c(3131,2075)
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.swe.ann/',theGCMs[i],'.swe.ann.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.swe.ann/',theGCMs[i],'.swe.ann.',(10+j),'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Replace timestep 1 with historical mean.
		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.swe.ann.61.90/mean.swe.ann.61.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.swe.ann/',theGCMs[i],'.swe.ann.1.hxn',sep=''), overwrite=TRUE
			)
	}
}

# ==============================================================================================================
# Historical T.djf

if (run.hist.t.djf=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'tmp_djf'
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1960+j),'.nc',sep='') } # Only the last 30 years, same as vegetation
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='tmp',
		month='djf'
		)
	
	# stop('cbw')

		# Create the HexMap
	nc.2.hxn(
		variable='mean_tmp_djf', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/tmp_djf/mean_tmp_djf.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.tmp.djf.61.90',
		dimensions=c(3131,2075)
		)

	nc.2.hxn(
		variable='sd_tmp_djf', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/tmp_djf/sd_tmp_djf.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.tmp.djf.61.90',
		dimensions=c(3131,2075)
		)
}
# stop('cbw')
# ==========================================================================================================
# Making hexmaps from Winter Temp projections

if (run.future.t.djf=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- "S:/Space/Lawler/Shared/pnwccva-climatedata/annual/a2/" # 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('/wna30sec_a2_','_tmp_djf_')
	variable.folders <- 'tmp_djf_a2'

	for (i in 1) # 1:5
	{
		startTime <- Sys.time()

		for (j in 1:99)
		# for (j in 1)
		{	
			nc.2.hxn(
				variable='tmp_djf', 
				nc.file=paste(file.path,variable.folders,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf, 
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.tmp.djf',sep=''),
				dimensions=c(3131,2075)
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.tmp.djf/',theGCMs[i],'.tmp.djf.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.tmp.djf/',theGCMs[i],'.tmp.djf.',(10+j),'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Replace timestep 1 with historical mean.
		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.tmp.djf.61.90/mean.tmp.djf.61.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.tmp.djf/',theGCMs[i],'.tmp.djf.1.hxn',sep=''), overwrite=TRUE
			)
	}
}

