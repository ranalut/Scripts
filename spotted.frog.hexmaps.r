
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
hexsim.wksp <- 'E:/HexSim/' # 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/' #'F:/PNWCCVA_Data2/HexSim/scratch_workspace/',
hexsim.wksp2 <- 'E:\\HexSim' # 'C:\\Users\\cbwilsey\\Documents\\Postdoc\\HexSim' #'F:\\PNWCCVA_Data2\\HexSim\\'
spp.folder <- 'spotted_frog_v2'

run.hex.grid <- 		'n'
run.historical.swe <- 	'n'
run.stream <- 			'n'
run.initial <- 			'n'
run.future.swe <- 		'y'

startTime <- Sys.time()

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

# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.path <- 'E:/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.name <- '/wna30sec_CRU_TS_2.10_'
variable.folders <- 'snowfall_swe_balance'

if (run.historical.swe=='y')
{
	# Calculate historical stats
	# temp <- extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13); plot(temp); stop('cbw')
	extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	# temp <- calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13); stop('cbw')
	# plot.stack(temp,pick=1); stop('cbw')
	calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
	# stop('cbw')

	# Create the HexMap
	nc.2.hxn(
		variable='mean.swe.max', 
		nc.file="E:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_max.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name='mean.swe.max'
		)

	nc.2.hxn(
		variable='sd.swe.max', 
		nc.file="E:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/sd_swe_max.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
		hex.grid=hex.grid[[2]], 
		theCentroids=hex.grid[[1]],
		max.value=2000, 
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name='sd.swe.max'
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
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name='streams'
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
		hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name='initial.dist'
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
	# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
	file.path <- 'E:/bioclimate/annual/a2/'
	file.name <- '/wna30sec_CRU_TS_2.10_'
	variable.folders <- 'snowfall_swe_balance_first_day_of_month_a2'

	for (i in 5)
	{

		startTime <- Sys.time()

		for (j in 1:99)
		{
			extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
						
			nc.2.hxn(
			variable='swe_max', 
			nc.file=paste("E:/bioclimate/annual/a2/wna30sec_a2_",theGCMs[i],"_snowfall_swe_balance_first_day_of_month_",2000+j,".nc",sep=''), 
			hex.grid=hex.grid[[2]], 
			theCentroids=hex.grid[[1]],
			max.value=2000, 
			hexsim.wksp=hexsim.wksp, hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name='initial.dist'
			)

			file.copy(from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/',theGCMs[i],'.deficit/',theGCMs[i],'.deficit.1.hxn',sep=''), to=paste(outWorkspace,theGCMs[i],'.deficit/',theGCMs[i],'.deficit.',(10+j),'.hxn',sep=''))
			cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
			
			stop('cbw')

		}
	}
}