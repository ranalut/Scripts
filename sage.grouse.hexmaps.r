
# =========================================================================================
# Generate HexMaps from spatial data layers for the Greater sage-grouse workspace.
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
spp.folder <- 'rabbit_v1'

run.hex.grid <- 		'y'
run.historical.swe <- 	'n'
run.annual.hist.swe <- 	'n'
run.ann.hist.def <-		'n'
run.hist.deficit <- 	'y'
run.fut.deficit <- 		'n'
run.hist.biomes <-		'y'
run.biomes <- 			'n'
run.initial <- 			'n' # Not updated for squirrel
run.future.swe <- 		'n'
run.fire <- 			'n' # May need to add this
run.all.huc <- 			'n'
run.pa <- 				'n'
run.eco.reg <- 			'n'

startTime <- Sys.time()

# Used for visualization of outputs...
# plot(raster('e:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/swe_max_1906.nc'),main='1906')
# plot(raster('e:/bioclimate/annual/a2/snowfall_swe_balance_first_day_of_month_a2/swe_max_2001.nc'),main='2001')

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
		# changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,2,1,0,0,0)),ncol=2)), # grasslands steppe (8) and shrub steppe (9)
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='biomes',
		dimensions=c(1750,1859)
		)
}	

# Biomes
if (run.biomes=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'S:/Space/Lawler/Shared/PNWCCVA-VegetationData/26jul13_outputs/biome_modal_30yr_a2/' # 'H:/vegetation/26jul13_outputs/biome_modal_30yr_a2/'
	file.name <- c('wna30sec_a2_','_biome_30-year_mean_')
	# variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 1:5)
	# for (i in 2)
	{
		startTime <- Sys.time()

		for (j in 1:99)
		# for (j in 1)
		{
			test <- file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2.v2/',theGCMs[i],'.biomes.a2.v2.',(10+j),'.hxn',sep=''))
			if(test==TRUE) { cat(theGCMs[i],j,'\n'); next(j) }
			
			nc.2.hxn(
				variable='biome', 
				nc.file=paste(file.path,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''), 
				hex.grid=hex.grid[[2]], 
				theCentroids=hex.grid[[1]],
				max.value=Inf,
				changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,2,1,0,0,0)),ncol=2)),
				hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				hexmap.name=paste(theGCMs[i],'.biomes.a2.v2',sep=''),
				dimensions=c(1750,1859)
				)

			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2.v2/',theGCMs[i],'.biomes.a2.v2.1.hxn',sep=''), 
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.biomes.a2.v2/',theGCMs[i],'.biomes.a2.v2.',(10+j),'.hxn',sep=''),
				overwrite=TRUE
				)
			cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# stop('cbw')
		}
		
		# Present-day
		nc.2.hxn(
			variable='biome', 
			nc.file='S:/Space/Lawler/Shared/PNWCCVA-VegetationData/26jul13_outputs/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_30-year_mean_2000.nc', # "H:/vegetation/26jul13_outputs/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_30-year_mean_2000.nc", 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=Inf,
			changeTable=data.frame(matrix(c(seq(1,12,1),c(0,0,0,0,0,0,0,2,1,0,0,0)),ncol=2)),
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(theGCMs[i],'.biomes.a2.v2',sep=''),
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
	file.path <- 'S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/' # 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' 
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'snowfall_swe_balance'

	# for (j in 5:100)
	# {
		# extract.swe(
			# file.path.in=paste(file.path,variable.folders,file.name,variable.folders,'_first_day_of_month_',(1900+j),'.nc',sep=''),
			# file.path.out=paste(file.path,variable.folders,'/swe_mar_',(1900+j),'.nc',sep=''),
			# month=3,
			# max.value=5000
			# )
		# # stop('cbw')
	# }
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_mar_',(1960+j),'.nc',sep='') }
	
	# # calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	# calc.swe(
		# all.file.paths.in=all.file.paths,
		# file.path.out=paste(file.path,variable.folders,sep=''),
		# variable='swe',
		# month='mar',
		# FUN='quantiles',
		# probs=c(0.02,0.05,0.1,0.5,0.9,0.95,0.98)
		# )
	
	# stop('cbw')

		# Create the HexMap
	# nc.2.hxn(
		# variable='mean_swe_mar', 
		# nc.file= "S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_mar.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_mar.nc",
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=2000, 
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.mar.61.90',
		# dimensions=c(1750,1859)
		# )

	# nc.2.hxn(
		# variable='sd_swe_mar', 
		# nc.file="S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=2000, 
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.mar.61.90',
		# dimensions=c(1750,1859)
		# )
		
	nc.2.hxn(
		variable='quantiles_swe_mar', 
		nc.file= "S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/q_swe_mar.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_mar.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='q50.swe.mar.61.90',
		dimensions=c(1750,1859),
		band=4
		)

	nc.2.hxn(
		variable='quantiles_swe_mar', 
		nc.file="S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/q_swe_mar.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='q5.swe.mar.61.90',
		dimensions=c(1750,1859),
		band=2
		)
	
	nc.2.hxn(
		variable='quantiles_swe_mar', 
		nc.file="S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/q_swe_mar.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='q95.swe.mar.61.90',
		dimensions=c(1750,1859),
		band=6
		)
}
# stop('cbw')

# ==========================================================================================================
# Making hexmaps from SWE projections

if (run.future.swe=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'S:/Space/Lawler/shared/PNWCCVA-ClimateData/annual/a2/' # 'H:/bioclimate/annual/a2/' # 'E:/bioclimate/annual/a2/'
	file.name <- c('/wna30sec_a2_','_snowfall_swe_balance_first_day_of_month_')
	variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	# # for (i in 1:5)
	# for (i in 2)
	# {
		# startTime <- Sys.time()

		# for (j in 1:99)
		# # for (j in 1)
		# {
			# extract.swe(
				# file.path.in=paste(file.path,variable.folders,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''),
				# file.path.out=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_mar_',(2000+j),'.nc',sep=''),
				# month=3,
				# max.value=5000
				# )
			# # stop('cbw')
			
			# nc.2.hxn(
				# variable='swe_march', 
				# nc.file=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_mar_',(2000+j),'.nc',sep=''), 
				# hex.grid=hex.grid[[2]], 
				# theCentroids=hex.grid[[1]],
				# max.value=2000, 
				# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				# hexmap.name=paste(theGCMs[i],'.mar.swe',sep=''),
				# dimensions=c(1750,1859)
				# )

			# file.copy(
				# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.mar.swe/',theGCMs[i],'.mar.swe.1.hxn',sep=''), 
				# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.mar.swe/',theGCMs[i],'.mar.swe.',(10+j),'.hxn',sep=''),
				# overwrite=TRUE
				# )
			# cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# # stop('cbw')
		# }

	# }

	for (i in theGCMs)
	{
		for (j in seq(41,50,1))
		{
			file.copy(
			from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.mar.swe.51.90/CRU.mar.swe.51.90.',j,'.hxn',sep=''), 
			to=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',i,'.mar.swe/',i,'.mar.swe.',(j-40),'.hxn',sep=''),
			overwrite=TRUE
			)
			# stop('cbw')
		}
	}
}

# ==========================================================================================================
# Making annual hexmaps from historical SWE

if (run.annual.hist.swe=='y')
{
	file.path <- 'S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance' # 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance'
	startTime <- Sys.time()

	# for (j in seq(90,51,-1)) 
	for (j in c(seq(100,91,-1),51)) # This will actually be 1951-2000.
	# for (j in 1)
	{
		nc.2.hxn(
			variable='swe_march', 
			nc.file=paste(file.path,'/','swe_mar_',(1900+j),'.nc',sep=''), 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=2000, 
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste('CRU.mar.swe.51.90',sep=''),
			dimensions=c(1750,1859)
			)

		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.mar.swe.51.90/CRU.mar.swe.51.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.mar.swe.51.90/CRU.mar.swe.51.90.',(j-50),'.hxn',sep=''),
			overwrite=TRUE
			)
		cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# stop('cbw')
	}
}

# ==========================================================================================================
# Making annual hexmaps from historical Deficit

if (run.ann.hist.def=='y')
{
	file.path <- 'S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/deficit_mam_v1' # 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_mam_v1'
	startTime <- Sys.time()

	# for (j in seq(90,51,-1))
	for (j in c(seq(100,91,-1),51)) # This will actually be 1951-2000.
	# for (j in 1)
	{
		nc.2.hxn(
			variable='deficit_mam', 
			nc.file=paste(file.path,'/deficit_mam_',(1900+j),'.nc',sep=''), 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=2000, 
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste('CRU.deficit.mam.51.90',sep=''),
			dimensions=c(1750,1859)
			)

		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.deficit.mam.51.90/CRU.deficit.mam.51.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.deficit.mam.51.90/CRU.deficit.mam.51.90.',(j-50),'.hxn',sep=''),
			overwrite=TRUE
			)
		cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# stop('cbw')
	}
}

# ==============================================================================================================
# Historical Deficit

if (run.hist.deficit=='y')
{
	file.path <- 'S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/' # 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' 
	variable.folders <- 'deficit_mam_v1'

	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,'/deficit_mam_',(1960+j),'.nc',sep='') }
	
	# # calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	# calc.swe(
		# all.file.paths.in=all.file.paths,
		# file.path.out=paste(file.path,variable.folders,sep=''),
		# variable='deficit',
		# month='mam',
		# FUN='quantiles',
		# probs=c(0.02,0.05,0.1,0.5,0.9,0.95,0.98)
		# )
	
	# stop('cbw')

	# Create the HexMap
	# nc.2.hxn(
		# variable='mean_deficit_mam_mam', # Due to a typo above
		# nc.file= "S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/deficit_mam_v1/mean_deficit_mam.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_mar.nc",
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=2000, 
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.deficit.mam.61.90',
		# dimensions=c(1750,1859)
		# )

	# nc.2.hxn(
		# variable='sd_deficit_mam_mam', # Due to a typo above
		# nc.file="S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/deficit_mam_v1/sd_deficit_mam.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", 
		# hex.grid=hex.grid[[2]], 
		# theCentroids=hex.grid[[1]],
		# max.value=2000, 
		# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.deficit.mam.61.90',
		# dimensions=c(1750,1859)
		# )
		
	nc.2.hxn(
		variable='quantiles_deficit_mam', 
		nc.file= "S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/deficit_mam_v1/q_deficit_mam.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_mar.nc",
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='q50.deficit.mam.61.90',
		dimensions=c(1750,1859),
		band=4
		)

	nc.2.hxn(
		variable='quantiles_deficit_mam', 
		nc.file="S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/deficit_mam_v1/q_deficit_mam.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='q5.deficit.mam.61.90',
		dimensions=c(1750,1859),
		band=2
		)
	
	nc.2.hxn(
		variable='quantiles_deficit_mam', 
		nc.file="S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/CRU_TS2.1_1901-2000/deficit_mam_v1/q_deficit_mam.nc", # "H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_mar.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='q95.deficit.mam.61.90',
		dimensions=c(1750,1859),
		band=6
		)
}
# stop('cbw')

# ==========================================================================================================
# Making hexmaps from deficit projections

if (run.fut.deficit=='y')
{
	the.months <- 'mam'
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'S:/Space/Lawler/Shared/PNWCCVA-ClimateData/annual/a2/' # 'H:/bioclimate/annual/a2/' # 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('',paste('deficit_',the.months,sep=''))
	variable.folders <- paste('deficit_',the.months,'_a2_v1',sep='')

	# # for (i in 1:5)
	# for (i in 4)
	# {
		# startTime <- Sys.time()

		# for (j in 1:99)
		# # for (j in 1)
		# {
						
			# nc.2.hxn(
				# variable=paste('deficit_',the.months,sep=''), 
				# nc.file=paste(file.path,variable.folders,'/',file.name[1],theGCMs[i],'_',file.name[2],'_',(2000+j),'.nc',sep=''), 
				# hex.grid=hex.grid[[2]], 
				# theCentroids=hex.grid[[1]],
				# max.value=Inf, 
				# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				# hexmap.name=paste(theGCMs[i],'.deficit.',the.months,sep=''),
				# dimensions=c(1750,1859)
				# )

			# file.copy(
				# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.deficit.',the.months,'/',theGCMs[i],'.deficit.',the.months,'.1.hxn',sep=''), 
				# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.deficit.',the.months,'/',theGCMs[i],'.deficit.',the.months,'.',(10+j),'.hxn',sep=''),
				# overwrite=TRUE
				# )
			# cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# # stop('cbw')
		# }
	# }	
	
	for (i in theGCMs)
	{
		for (j in seq(41,50,1))
		{
			file.copy(
			from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.deficit.',the.months,'.51.90/CRU.deficit.',the.months,'.51.90.',j,'.hxn',sep=''), 
			to=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',i,'.deficit.',the.months,'/',i,'.deficit.',the.months,'.',(j-40),'.hxn',sep=''),
			overwrite=TRUE
			)
			# stop('cbw')
		}
	}
}


# ==============================================================================================================
# Historical Fire Fraction

if (run.fire=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS2.1_lpj_'
	variable.folders <- 'afirefrac'
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1960+j),'.nc',sep='') }
	
	# # calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	# calc.swe(
		# all.file.paths.in=all.file.paths,
		# file.path.out=paste(file.path,variable.folders,sep=''),
		# variable='firefrac',
		# month='ann'
		# )
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_firefrac_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/afirefrac/mean_firefrac_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.fire.ann.61.90',
		dimensions=c(1750,1859)
		)

	nc.2.hxn(
		variable='sd_firefrac_ann', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/afirefrac/sd_firefrac_ann.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.fire.ann.61.90',
		dimensions=c(1750,1859)
		)
}
# stop('cbw')

