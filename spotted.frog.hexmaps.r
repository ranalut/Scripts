
# =========================================================================================
# Generate HexMaps from spatial data layers for the spotted frog workspace.
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
output.wksp <- 'H:/HexSim/' #'E:/HexSim/'
output.wksp2 <- 'H:\\HexSim' # 'E:\\HexSim'
spp.folder <- 'spotted_frog_v2'

run.hex.grid <- 		'n'
run.historical.swe <- 	'n'
run.streams <- 			'n'
run.initial <- 			'n'
run.future.swe <- 		'n'
run.annual.hist.swe <- 	'n'
run.ann.hist.aet.mam <- 'n'
run.ann.hist.aet.jja <- 'y'
run.hist.aet.mam <- 	'n'
run.hist.aet.jja <- 	'n'
run.hist.veg <- 		'n'
run.biomes <- 			'n'
run.future.aet <-		'n' # c('y','jja')

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
# =====================================================================================
# Historical Biomes

if (run.hist.veg=='y')
{

	nc.2.hxn(
		variable='biome', 
		nc.file="H:/vegetation/26jul13_outputs/biome_modal_30yr_CRU_TS_2.10/wna30sec_CRU_TS_2.10_biome_30-year_mean_2000.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf,
		changeTable=data.frame(matrix(c(seq(1,12,1),c(1,1,1,-1,1,1,-1,-1,-1,-1,0,0)),ncol=2)),
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste('biomes.aet.v1',sep='')
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
				changeTable=data.frame(matrix(c(seq(1,12,1),c(1,1,1,-1,1,1,-1,-1,-1,-1,0,0)),ncol=2)),
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
			changeTable=data.frame(matrix(c(seq(1,12,1),c(1,1,1,-1,1,1,-1,-1,-1,-1,0,0)),ncol=2)),
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=paste(theGCMs[i],'.biomes.a2',sep='')
			)
	}
}

# ==============================================================================================================
# Historical SWE

if (run.historical.swe=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'snowfall_swe_balance'

	# Already Ran This...
	# for (j in 5:100)
	# {
		# extract.swe(
			# file.path.in=paste(file.path,variable.folders,file.name,variable.folders,'_first_day_of_month_',(1900+j),'.nc',sep=''),
			# file.path.out=paste(file.path,variable.folders,'/swe_max_',(1900+j),'.nc',sep=''),
			# month=13,
			# max.value=5000
			# )
		# # stop('cbw')
	# }
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_max_',(1960+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='swe',
		month='max'
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_swe_max', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_max.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.max.61.90'
		)

	nc.2.hxn(
		variable='sd_swe_max', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_max.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.max.61.90'
		)
}
# stop('cbw')

# ==========================================================================================================
# Streams Map

if (run.streams=='y')
{
	nc.2.hxn(
		variable='streams', 
		nc.file="C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/spotted_frog_v2/Spatial Data/streams_v2.nc", 
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='streams'
		)
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
# Historical AET MAM

if (run.hist.aet.mam=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'aet_mam_v1'
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1960+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='aet',
		month='mam'
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_aet_mam', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_mam_v1/mean_aet_mam.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.aet.mam.61.90'
		)

	nc.2.hxn(
		variable='sd_aet_mam', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_mam_v1/sd_aet_mam.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.aet.mam.61.90'
		)
}

# =========================================================================================================
# Historical AET JJA

if (run.hist.aet.jja=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'aet_jja_v1'
	
	all.file.paths <- list()
	for (j in 1:30) { all.file.paths[[j]] <- paste(file.path,variable.folders,file.name,variable.folders,'_',(1960+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='aet',
		month='jja'
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean_aet_jja', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_jja_v1/mean_aet_jja.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.aet.jja.61.90'
		)

	nc.2.hxn(
		variable='sd_aet_jja', 
		nc.file="H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_jja_v1/sd_aet_jja.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=Inf, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.aet.jja.61.90'
		)
}

# ========================================================================================================
# Calculating Deficit from AET and PET and writing deficit to netCDF files...

# See 'spotted.frog.hexmaps.v6.r' for the original version of this script.  I did not redo the code since I'd already run it the old way.
# See deficit.r for the newest version of this script.

# ==========================================================================================================
# Making hexmaps from SWE projections

if (run.future.swe=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'H:/bioclimate/annual/a2/' # 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('/wna30sec_a2_','_snowfall_swe_balance_first_day_of_month_')
	variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	# for (i in 1:5)
	# {
		# startTime <- Sys.time()

		# for (j in 1:99)
		# # for (j in 1)
		# {
			# extract.swe(
				# file.path.in=paste(file.path,variable.folders,file.name[1],theGCMs[i],file.name[2],(2000+j),'.nc',sep=''),
				# file.path.out=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_max_',(2000+j),'.nc',sep=''),
				# month=13,
				# max.value=5000
				# )
			# # stop('cbw')
			
			# nc.2.hxn(
				# variable='swe_max', 
				# nc.file=paste(file.path,variable.folders,'/',theGCMs[i],'_swe_max_',(2000+j),'.nc',sep=''), 
				# hex.grid=hex.grid[[2]], 
				# theCentroids=hex.grid[[1]],
				# max.value=2000, 
				# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				# hexmap.name=paste(theGCMs[i],'.max.swe',sep='')
				# )

			# file.copy(
				# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.1.hxn',sep=''), 
				# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.',(10+j),'.hxn',sep=''),
				# overwrite=TRUE
				# )
			# cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# # stop('cbw')
		# }
		
		# # Replace timestep 1 with historical mean.
		# file.copy(
			# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.swe.max/mean.swe.max.1.hxn',sep=''), 
			# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.1.hxn',sep=''),
			# overwrite=TRUE
			# )
	# }
	
	# Replace timesteps 1-10 with historical 1991-2000, writing directly to F: drive (as opposed to H:).
	# for (j in 1:10)
	# # for (j in 1)
	# {
		# nc.2.hxn(
			# variable='swe_max', 
			# nc.file=paste('H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/swe_max_',(1990+j),'.nc',sep=''), 
			# hex.grid=hex.grid[[2]], 
			# theCentroids=hex.grid[[1]],
			# max.value=2000, 
			# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=hexsim.wksp, output.wksp2=hexsim.wksp2, spp.folder=spp.folder, 
			# hexmap.name=paste('CRU.swe.temp',sep='')
			# )

		# file.copy(
			# from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/','CRU.swe.temp/','CRU.swe.temp.1.hxn',sep=''), 
			# to=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/','CRU.swe.max/CRU.swe.max.',j,'.hxn',sep=''),
			# overwrite=TRUE
			# )

		# cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# # stop('cbw')
	# }
	for (i in theGCMs)
	{
		for (j in seq(1,10,1))
		{
			file.copy(
			from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.swe.max/CRU.swe.max.',j,'.hxn',sep=''), 
			to=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',i,'.max.swe/',i,'.max.swe.',j,'.hxn',sep=''),
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
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance'
	startTime <- Sys.time()

	for (j in seq(90,51,-1))
	# for (j in 1)
	{
		nc.2.hxn(
			variable='swe_max', 
			nc.file=paste(file.path,'/','swe_max_',(1900+j),'.nc',sep=''), 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=2000, 
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste('CRU.max.swe.51.90',sep='')
			)

		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.max.swe.51.90/CRU.max.swe.51.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.max.swe.51.90/CRU.max.swe.51.90.',(j-50),'.hxn',sep=''),
			overwrite=TRUE
			)
		cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# stop('cbw')
	}
}

# ==========================================================================================================
# Making annual hexmaps from historical AET MAM

if (run.ann.hist.aet.mam=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_mam_v1'
	startTime <- Sys.time()

	for (j in seq(90,51,-1))
	# for (j in 1)
	{
		nc.2.hxn(
			variable='aet_mam', 
			nc.file=paste(file.path,'/wna30sec_CRU_TS_2.10_aet_mam_v1_',(1900+j),'.nc',sep=''), 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=2000, 
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste('CRU.aet.mam.51.90',sep='')
			)

		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.aet.mam.51.90/CRU.aet.mam.51.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.aet.mam.51.90/CRU.aet.mam.51.90.',(j-50),'.hxn',sep=''),
			overwrite=TRUE
			)
		cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# stop('cbw')
	}
}

# ==========================================================================================================
# Making annual hexmaps from historical AET JJA

if (run.ann.hist.aet.jja=='y')
{
	file.path <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_jja_v1'
	startTime <- Sys.time()

	for (j in seq(90,51,-1))
	# for (j in 1)
	{
		nc.2.hxn(
			variable='aet_jja', 
			nc.file=paste(file.path,'/wna30sec_CRU_TS_2.10_aet_jja_v1_',(1900+j),'.nc',sep=''), 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=2000, 
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			hexmap.name=paste('CRU.aet.jja.51.90',sep='')
			)

		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.aet.jja.51.90/CRU.aet.jja.51.90.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.aet.jja.51.90/CRU.aet.jja.51.90.',(j-50),'.hxn',sep=''),
			overwrite=TRUE
			)
		cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# stop('cbw')
	}
}

# ==========================================================================================================
# Making hexmaps from AET projections

if (run.future.aet[1]=='y')
{
	the.months <- run.future.aet[2]
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'H:/bioclimate/annual/a2/' # 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('wna30sec_a2_',paste('aet_',the.months,'_v1',sep=''))
	variable.folders <- paste('aet_',the.months,'_a2_v1',sep='')

	# for (i in 1:5)
	# {
		# startTime <- Sys.time()

		# for (j in 1:99)
		# # for (j in 1)
		# {
						
			# nc.2.hxn(
				# variable=paste('aet_',the.months,sep=''), 
				# nc.file=paste(file.path,variable.folders,'/',file.name[1],theGCMs[i],'_',file.name[2],'_',(2000+j),'.nc',sep=''), 
				# hex.grid=hex.grid[[2]], 
				# theCentroids=hex.grid[[1]],
				# max.value=2000, 
				# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
				# hexmap.name=paste(theGCMs[i],'.aet.',the.months,sep='')
				# )

			# file.copy(
				# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.aet.',the.months,'/',theGCMs[i],'.aet.',the.months,'.1.hxn',sep=''), 
				# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.aet.',the.months,'/',theGCMs[i],'.aet.',the.months,'.',(10+j),'.hxn',sep=''),
				# overwrite=TRUE
				# )
			# cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			# # stop('cbw')
		# }
	# }	
	# Replace timesteps 1-10 with historical 1991-2000.
	# for (j in 1:10)
	# # for (j in 1)
	# {
					
		# nc.2.hxn(
			# variable=paste('aet_',the.months,sep=''), 
			# nc.file=paste('H:/bioclimate/annual/CRU_TS2.1_1901-2000/aet_',the.months,'_v1/wna30sec_CRU_TS_2.10_aet_',the.months,'_v1_',(1990+j),'.nc',sep=''), 
			# hex.grid=hex.grid[[2]], 
			# theCentroids=hex.grid[[1]],
			# max.value=2000, 
			# hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, 
			# hexmap.name=paste('CRU.aet.',the.months,'.temp',sep='')
			# )

		# file.copy(
			# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/','CRU.aet.',the.months,'.temp/','CRU.aet.',the.months,'.temp.1.hxn',sep=''), 
			# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/','CRU.aet.',the.months,'/','CRU.aet.',the.months,'.',j,'.hxn',sep=''),
			# overwrite=TRUE
			# )
		# cat('Year',j,Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		# # stop('cbw')
	# }
	
	for (i in theGCMs)
	{
		for (j in seq(1,10,1))
		{
			file.copy(
			from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/CRU.aet.',the.months,'/','CRU.aet.',the.months,'.',j,'.hxn',sep=''), 
			to=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',i,'.aet.',the.months,'/',i,'.aet.',the.months,'.',j,'.hxn',sep=''),
			overwrite=TRUE
			)
			# stop('cbw')
		}
	}
		# file.copy(
			# from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.aet.',the.months,'/mean.aet.',the.months,'.1.hxn',sep=''), 
			# to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.aet.',the.months,'/',theGCMs[i],'.aet.',the.months,'.1.hxn',sep=''),
			# overwrite=TRUE
			# )
}
