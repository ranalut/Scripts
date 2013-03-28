
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
setwd('C:/Users/cbwilsey/Documents/PostDoc/Scripts/')

source('extract.swe.r')
source('load.hex.grid.r')
source('netcdf.2.hexmap.r')
source('plot.raster.stack.r')

# Settings for this run.

hexsim.wksp <- 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/' #'F:/PNWCCVA_Data2/HexSim/scratch_workspace/',
hexsim.wksp2 <- 'C:\\Users\\cbwilsey\\Documents\\Postdoc\\HexSim' #'F:\\PNWCCVA_Data2\\HexSim\\'
output.wksp <- 'E:/HexSim/'
output.wksp2 <- 'E:\\HexSim'
spp.folder <- 'spotted_frog_v2'

run.hex.grid <- 		'n'
run.historical.swe <- 	'n'
run.streams <- 			'n'
run.initial <- 			'n'
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
		centroid.file='C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/centroids84.txt',  # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt'
		file.format='txt',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}
# ==============================================================================================================
# Historical SWE

if (run.historical.swe=='y')
{
	file.path <- 'E:/bioclimate/annual/CRU_TS2.1_1901-2000/' # 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'snowfall_swe_balance'

	for (j in 5:100)
	{
		extract.swe(
			file.path.in=paste(file.path,variable.folders,file.name,variable.folders,'_first_day_of_month_',(1900+j),'.nc',sep=''),
			file.path.out=paste(file.path,variable.folders,'/swe_max_',(1900+j),'.nc',sep=''),
			month=13,
			max.value=5000
			)
		# stop('cbw')
	}
	
	all.file.paths <- list()
	for (j in 1:96) { all.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_max_',(1904+j),'.nc',sep='') }
	
	# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	calc.swe(
		all.file.paths.in=all.file.paths,
		file.path.out=paste(file.path,variable.folders,sep=''),
		variable='swe',
		month=13
		)
	
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean.swe.max', 
		nc.file="E:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_max.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.max'
		)

	nc.2.hxn(
		variable='sd.swe.max', 
		nc.file="E:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_max.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, output.wksp=output.wksp, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.max'
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

# ========================================================================================================
# Calculating Deficit from AET and PET and writing deficit to netCDF files...

# See 'spotted.frog.hexmaps.v6.r' for this script.  I did not redo the code since I'd already run it the old way.


# ==========================================================================================================
# Making hexmaps from SWE projections

if (run.future.swe=='y')
{
	theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
	file.path <- 'E:/bioclimate/annual/a2/' # file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.name <- c('/wna30sec_a2_','_snowfall_swe_balance_first_day_of_month_')
	variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 5)
	{
		startTime <- Sys.time()

		for (j in 1:99)
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
			cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			
			stop('cbw')
		}
		
		# Replace timestep 1 with historical mean.
		file.copy(
			from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/mean.swe.max/mean.swe.max.1.hxn',sep=''), 
			to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',theGCMs[i],'.max.swe/',theGCMs[i],'.max.swe.1.hxn',sep=''),
			overwrite=TRUE
			)
	}
}
