
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

startTime <- Sys.time()

# ==========================================================================================
# Load WGS 84 hex.grid for extracting spatial data

# hex.grid <- load.hex.grid(
	# centroid.file='C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/centroids84.txt',  # 'F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt'
	# file.format='txt',
	# proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
	# )

# ==============================================================================================================
# Historical SWE

file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.path <- 'E:/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.name <- '/wna30sec_CRU_TS_2.10_'
variable.folders <- 'snowfall_swe_balance'

# Calculate historical stats
# temp <- extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13); plot(temp); stop('cbw')
extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
temp <- calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13); plot.stack(temp, picks='3'); stop('cbw')
# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)


# Create the HexMap
nc.2.hxn(
	variable='swe.march', 
	nc.file="E:/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc", # "D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/snowfall_swe_balance/mean_swe_march.nc"
	hex.grid=hex.grid[[2]], 
	theCentroids=hex.grid[[1]],
	max.value=2000, 
	hexsim.wksp='C:/Users/cbwilsey/Documents/PostDoc/HexSim/', #'F:/PNWCCVA_Data2/HexSim/scratch_workspace/',
	hexsim.wksp2='C:\\Users\\cbwilsey\\Documents\\Postdoc\\HexSim', #'F:\\PNWCCVA_Data2\\HexSim\\'
	spp.folder='spotted_frog_v2'
	)

stop('cbw')




# ==============================================================================================================
# Streams Map
# streams <- raster("F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/streams_v2.nc",varname='streams')

# startTime <- Sys.time()
# extractedData <- extract(streams, hex.grid)
# extractedData[is.na(extractedData)==TRUE] <- 0
# cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# # print(head(extractedData)); stop('cbw')

# dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
# write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/streams.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
# workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
# command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\streams.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\streams.v1"',sep='')
# shell(command)

# stop('cbw')

# ==============================================================================================================
# Initial Dist Map
pres <- raster("F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/initial_dist.nc",varname='presence')

startTime <- Sys.time()
extractedData <- extract(pres, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/initial.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\initial.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\initial.v1"',sep='')
shell(command)

# stop('cbw')

# =======================================================================================================
# # WGS 84 grid for biomes data...

# # biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')

# extractedData <- extract(biomes, hex.grid)
# extractedData[is.na(extractedData)==TRUE] <- 0

# # Reclassify values...
# # Sarah's classes: 1, temperate forest; 2, boreal forest; 3, open forest/woodland w/ broadleaf; 4, open forest/woodland; 5, grassland; 6, shrubland; 7, barren.
# # Translation to vireo classes:
# # 1 to 1
# # 2 to 1
# # 3 to 1
# # 4 to 1
# # 5 to 0
# # 6 to 0
# # 7 to 0

# extractedData[extractedData %in% c(5:7)] <- 0
# extractedData[extractedData %in% c(1:4)] <- 1

# dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
# write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/biomes.csv',sep=''),row.names=FALSE)

# startTime <- Sys.time()
# workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
# command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\biomes.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\biomes.v1"',sep='')
# shell(command)

# ==============================================================================================================
# Historical Deficit
variable <- 'deficit.mam'
theData <- raster("D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/mean_deficit_mam.nc") #,varname='streams')

startTime <- Sys.time()
extractedData <- extract(theData, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/',variable,'.csv',sep=''),row.names=FALSE)

startTime <- Sys.time()
workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\',variable,'.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\',variable,'"',sep='')
shell(command)

# Historical Deficit SD
variable <- 'deficit.sd.mam'
theData <- raster("D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/sd_deficit_mam.nc") #,varname='streams')

startTime <- Sys.time()
extractedData <- extract(theData, hex.grid)
extractedData[is.na(extractedData)==TRUE] <- 0
cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
# print(head(extractedData)); stop('cbw')

dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/',variable,'.csv',sep=''),row.names=FALSE)

dir.create(paste('F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/Hexagons/',variable,sep=''),recursive=TRUE)
startTime <- Sys.time()
workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\',variable,'.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\',variable,'"',sep='')
shell(command)

stop('cbw')

# ==============================================================================================================
# Calculating Deficit from AET and PET and writing deficit to netCDF files...

inWorkspace <- 'D:/PNWCCVA_Data1/bioclimate/annual/a2/'
outWorkspace <- "F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/Hexagons/"

file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/a2/'
file.path2 <- 'G:/PNWCCVA_Data2/bioclimate/annual/a2/'

file.name <- list(
c('/wna30sec_a2_CCSM3_aet_mam_v1','/wna30sec_a2_CCSM3_pet_mam_v1'),c('/wna30sec_a2_CGCM3.1_t47_aet_mam_v1','/wna30sec_a2_CGCM3.1_t47_pet_mam_v1'),c('/wna30sec_a2_GISS-ER_aet_mam_v1','/wna30sec_a2_GISS-ER_pet_mam_v1'),c('/wna30sec_a2_MIROC3.2_medres_aet_mam_v1','/wna30sec_a2_MIROC3.2_medres_pet_mam_v1'),c('/wna30sec_a2_UKMO-HadCM3_aet_mam_v1','/wna30sec_a2_UKMO-HadCM3_pet_mam_v1'))
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

variable.folders <- c('aet_mam_a2_v1','pet_mam_a2_v1')
output.name <- '_mam'

full.file.paths1 <- list()
full.file.paths2 <- list()

# for (i in 2:5) # The number of GCMs
for (i in 5)
{

	startTime <- Sys.time()

	for (j in 1:99)
	{
		full.file.paths1[[j]] <- paste(file.path,variable.folders[1],file.name[[i]][1],'_',(2000+j),'.nc',sep='')
		full.file.paths2[[j]] <- paste(file.path,variable.folders[2],file.name[[i]][2],'_',(2000+j),'.nc',sep='')


		aet <- raster(full.file.paths1[[j]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

		# aet <- stack(full.file.paths1[[1:2]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0',varname='aet_mam')
		# print('aet'); print(Sys.time()-startTime)

		pet <- raster(full.file.paths2[[j]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
		# pet <- stack(full.file.paths2[[1]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0',varname='pet_mam')
		# print('pet'); print(Sys.time()-startTime)

		deficit <- aet - pet
		print('deficit'); print(Sys.time()-startTime)
		# rm(aet)
		# rm(pet)

		writeRaster(deficit, paste(file.path2,'deficit_mam_a2/deficit_',theGCMs[i],output.name,'_',(2000+j),'.nc',sep=''),overwrite=TRUE)

		# mean.deficit <- mean(deficit, na.rm=TRUE)
		# print('mean'); print(Sys.time()-startTime)

		# sd.deficit <- calc(deficit, sd, na.rm=TRUE)
		# print('sd'); print(Sys.time()-startTime)

		# writeRaster(mean.deficit, paste(file.path,'mean_deficit',output.name,'.nc',sep=''),overwrite=TRUE)
		# writeRaster(sd.deficit, paste(file.path,'sd_deficit',output.name,'.nc',sep=''),overwrite=TRUE)

		print('files written'); print(Sys.time()-startTime)
		
		startTime <- Sys.time()
		extractedData <- extract(deficit, hex.grid)
		extractedData[is.na(extractedData)==TRUE] <- 0
		cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
		# print(head(extractedData)); stop('cbw')

		dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
		write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/deficit.step.csv',sep=''),row.names=FALSE)
		
		dir.create(path=paste("F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/Hexagons/",theGCMs[i],".deficit",sep=''),showWarnings = TRUE,recursive = TRUE)

		startTime <- Sys.time()
		workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
		command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\deficit.step.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\',theGCMs[i],'.deficit"',sep='')
		shell(command)
		
		file.copy(from=paste(outWorkspace,theGCMs[i],'.deficit/',theGCMs[i],'.deficit.1.hxn',sep=''), to=paste(outWorkspace,theGCMs[i],'.deficit/',theGCMs[i],'.deficit.',(10+j),'.hxn',sep=''))
		cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		
		# stop('cbw')

	}
}

# ==============================================================================================================
# Writing SWE projections

file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/a2/'
file.path2 <- 'G:/PNWCCVA_Data2/bioclimate/annual/a2/'

file.name <- list(
c('/wna30sec_a2_CCSM3_aet_mam_v1','/wna30sec_a2_CCSM3_pet_mam_v1'),c('/wna30sec_a2_CGCM3.1_t47_aet_mam_v1','/wna30sec_a2_CGCM3.1_t47_pet_mam_v1'),c('/wna30sec_a2_GISS-ER_aet_mam_v1','/wna30sec_a2_GISS-ER_pet_mam_v1'),c('/wna30sec_a2_MIROC3.2_medres_aet_mam_v1','/wna30sec_a2_MIROC3.2_medres_pet_mam_v1'),c('/wna30sec_a2_UKMO-HadCM3_aet_mam_v1','/wna30sec_a2_UKMO-HadCM3_pet_mam_v1'))
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

variable.folders <- c('aet_mam_a2_v1','pet_mam_a2_v1')
output.name <- '_mam'

full.file.paths1 <- list()
full.file.paths2 <- list()

# for (i in 2:5) # The number of GCMs
for (i in 5)
{

	startTime <- Sys.time()

	for (j in 1:99)
	{
		full.file.paths1[[j]] <- paste(file.path,variable.folders[1],file.name[[i]][1],'_',(2000+j),'.nc',sep='')
		full.file.paths2[[j]] <- paste(file.path,variable.folders[2],file.name[[i]][2],'_',(2000+j),'.nc',sep='')


		aet <- raster(full.file.paths1[[j]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

		# aet <- stack(full.file.paths1[[1:2]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0',varname='aet_mam')
		# print('aet'); print(Sys.time()-startTime)

		pet <- raster(full.file.paths2[[j]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
		# pet <- stack(full.file.paths2[[1]],crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0',varname='pet_mam')
		# print('pet'); print(Sys.time()-startTime)

		deficit <- aet - pet
		print('deficit'); print(Sys.time()-startTime)
		# rm(aet)
		# rm(pet)

		writeRaster(deficit, paste(file.path2,'deficit_mam_a2/deficit_',theGCMs[i],output.name,'_',(2000+j),'.nc',sep=''),overwrite=TRUE)

		# mean.deficit <- mean(deficit, na.rm=TRUE)
		# print('mean'); print(Sys.time()-startTime)

		# sd.deficit <- calc(deficit, sd, na.rm=TRUE)
		# print('sd'); print(Sys.time()-startTime)

		# writeRaster(mean.deficit, paste(file.path,'mean_deficit',output.name,'.nc',sep=''),overwrite=TRUE)
		# writeRaster(sd.deficit, paste(file.path,'sd_deficit',output.name,'.nc',sep=''),overwrite=TRUE)

		print('files written'); print(Sys.time()-startTime)
		
		startTime <- Sys.time()
		extractedData <- extract(deficit, hex.grid)
		extractedData[is.na(extractedData)==TRUE] <- 0
		cat(Sys.time()-startTime, 'minutes to extract data', '\n') # 1.5 minutes...
		# print(head(extractedData)); stop('cbw')

		dataDump <- data.frame(hex_id=theCentroids$Hex_ID, extractedData)
		write.csv(dataDump, paste('F:/PNWCCVA_Data2/HexSim/scratch_workspace/deficit.step.csv',sep=''),row.names=FALSE)
		
		dir.create(path=paste("F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/Hexagons/",theGCMs[i],".deficit",sep=''),showWarnings = TRUE,recursive = TRUE)

		startTime <- Sys.time()
		workspace2 <- 'F:\\PNWCCVA_Data2\\HexSim\\'
		command <- paste('cd "',workspace2,'\\currentHexSim\\" && HexMapConverter.exe "',workspace2,'\\scratch_workspace\\deficit.step.csv" true true 3131 2075 true "',workspace2,'\\Workspaces\\spotted_frog_v2\\Spatial Data\\Hexagons\\',theGCMs[i],'.deficit"',sep='')
		shell(command)
		
		file.copy(from=paste(outWorkspace,theGCMs[i],'.deficit/',theGCMs[i],'.deficit.1.hxn',sep=''), to=paste(outWorkspace,theGCMs[i],'.deficit/',theGCMs[i],'.deficit.',(10+j),'.hxn',sep=''))
		cat(Sys.time()-startTime, 'minutes or seconds to create Hexmap', '\n') # 1.09 minutes...
		
		# stop('cbw')

	}
}
