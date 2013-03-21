
library(ncdf)
library(rgdal)
library(raster)
library(foreign)

workspace <- 'F:/PNWCCVA_Data2/'
setwd(paste(workspace,'Scripts/',sep=''))

# ===============================================================
# Centroids for sampling...

# theCentroids <- read.dbf(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/albers_centroids_1km_wgs84.dbf',sep=''), as.is=TRUE)
# theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]
# hex.grid <- SpatialPoints(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')) #,data=theCentroids)


# ===============================================================
# Calculating Deficit from AET and PET and writing deficit to netCDF files...

# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
# file.name <- '/wna30sec_CRU_TS_2.10_'

# variable.folders <- c('aet_jja_v1','aet_mam_v1','aet_son_v1','pet_jja_v1','pet_mam_v1','pet_son_v1')
# output.names <- c('_jja','_mam','_son')

# full.file.paths1 <- list()
# full.file.paths2 <- list()

# for (i in 1:3)
# {
	# startTime <- Sys.time()

	# for (j in 1:100)
	# {
		# full.file.paths1[[j]] <- paste(file.path,variable.folders[i],file.name,variable.folders[i],'_',(1900+j),'.nc',sep='')
		# full.file.paths2[[j]] <- paste(file.path,variable.folders[(i+3)],file.name,variable.folders[(i+3)],'_',(1900+j),'.nc',sep='')
	# }
	
	# aet <- stack(full.file.paths1)
	# print('aet'); print(Sys.time()-startTime)
	
	# pet <- stack(full.file.paths2)
	# print('pet'); print(Sys.time()-startTime)
	
	# deficit <- aet - pet
	# print('deficit'); print(Sys.time()-startTime)
	# rm(aet)
	# rm(pet)
	
	# # writeRaster(deficit, paste(file.path,'deficit',output.names[i],'.nc',sep=''),overwrite=TRUE)
	
	# mean.deficit <- mean(deficit, na.rm=TRUE)
	# print('mean'); print(Sys.time()-startTime)
	
	# sd.deficit <- calc(deficit, sd, na.rm=TRUE)
	# print('sd'); print(Sys.time()-startTime)
	
	# writeRaster(mean.deficit, paste(file.path,'mean_deficit',output.names[i],'.nc',sep=''),overwrite=TRUE)
	# writeRaster(sd.deficit, paste(file.path,'sd_deficit',output.names[i],'.nc',sep=''),overwrite=TRUE)
	
	# print('files written'); print(Sys.time()-startTime)
# }

# stop('cbw')

# =========================================================
# Snow water equivalent in spring...

file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.name <- '/wna30sec_CRU_TS_2.10_'

variable.folders <- 'snowfall_swe_balance'
full.file.paths <- list()

startTime <- Sys.time()

for (j in 5:100) # Begin in 1905
{
	full.file.path <- paste(file.path,variable.folders,file.name,variable.folders,'_first_day_of_month_',(1900+j),'.nc',sep='')
	swe.all.months <- stack(full.file.path)
	# print(swe.all.months); stop('cbw')
	swe.march <- dropLayer(swe.all.months, c(1,2,4:12))
	# print(swe.march); stop('cbw')
	swe.april <- dropLayer(swe.all.months, c(1,2,3,5:12))
	swe.may <- dropLayer(swe.all.months, c(1:4,6:12))
	
	writeRaster(swe.march, paste(file.path,variable.folders,'/swe_march_',(1900+j),'.nc',sep=''),overwrite=TRUE, varname='swe_march')
	writeRaster(swe.april, paste(file.path,variable.folders,'/swe_april_',(1900+j),'.nc',sep=''),overwrite=TRUE, varname='swe_april')
	writeRaster(swe.may, paste(file.path,variable.folders,'/swe_may_',(1900+j),'.nc',sep=''),overwrite=TRUE, varname='swe_may')
	
	cat('year',1900+j,'\n')
}
stop('cbw')

# March...
full.file.paths <- list()
for (j in 1:96) { full.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_march_',(1904+j),'.nc',sep='') }
swe.march.all <- stack(full.file.paths)
print('swe.march.all'); print(Sys.time()-startTime)
# print(swe.march.all); stop('cbw')

mean.swe.march <- mean(swe.march.all, na.rm=TRUE)
print('mean'); print(Sys.time()-startTime)
writeRaster(mean.swe.march, paste(file.path,variable.folders,'/mean_swe_march.nc',sep=''),overwrite=TRUE, varname='mean_swe_march')
# rm(mean.p.pet.mam)

sd.swe.march <- calc(swe.march.all, sd, na.rm=TRUE)
print('sd'); print(Sys.time()-startTime)
writeRaster(sd.swe.march, paste(file.path,variable.folders,'/sd_swe_march.nc',sep=''),overwrite=TRUE, varname='sd_swe_march')
# rm(sd.p.pet.mam)

print('files written'); print(Sys.time()-startTime)

# April...
full.file.paths <- list()
for (j in 1:96) { full.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_april_',(1904+j),'.nc',sep='') }
swe.april.all <- stack(full.file.paths)
print('swe.april.all'); print(Sys.time()-startTime)
# print(swe.april.all); stop('cbw')

mean.swe.april <- mean(swe.april.all, na.rm=TRUE)
print('mean'); print(Sys.time()-startTime)
writeRaster(mean.swe.april, paste(file.path,variable.folders,'/mean_swe_april.nc',sep=''),overwrite=TRUE, varname='mean_swe_april')
# rm(mean.p.pet.mam)

sd.swe.april <- calc(swe.april.all, sd, na.rm=TRUE)
print('sd'); print(Sys.time()-startTime)
writeRaster(sd.swe.april, paste(file.path,variable.folders,'/sd_swe_april.nc',sep=''),overwrite=TRUE, varname='sd_swe_april')
# rm(sd.p.pet.mam)

print('files written'); print(Sys.time()-startTime)

# May...
full.file.paths <- list()
for (j in 1:96) { full.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_may_',(1904+j),'.nc',sep='') }
swe.may.all <- stack(full.file.paths)
print('swe.may.all'); print(Sys.time()-startTime)
# print(swe.may.all); stop('cbw')

mean.swe.may <- mean(swe.may.all, na.rm=TRUE)
print('mean'); print(Sys.time()-startTime)
writeRaster(mean.swe.may, paste(file.path,variable.folders,'/mean_swe_may.nc',sep=''),overwrite=TRUE, varname='mean_swe_may')
# rm(mean.p.pet.mam)

sd.swe.may <- calc(swe.may.all, sd, na.rm=TRUE)
print('sd'); print(Sys.time()-startTime)
writeRaster(sd.swe.may, paste(file.path,variable.folders,'/sd_swe_may.nc',sep=''),overwrite=TRUE, varname='sd_swe_may')
# rm(sd.p.pet.mam)

print('files written'); print(Sys.time()-startTime)


# =================================================================
# Extracting Precip - PET values from netcdf arrays and summarizing for spring months...

# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
# file.name <- '/wna30sec_CRU_TS_2.10_'

# variable.folders <- 'water_deficit'
# full.file.paths <- list()


# startTime <- Sys.time()

# for (j in 1:100)
# {
	# full.file.path <- paste(file.path,'water_deficit',file.name,variable.folders,'_',(1900+j),'.nc',sep='')
	# p.pet.all.months <- stack(full.file.path)
	# p.pet.spring <- dropLayer(p.pet.all.months, c(1,2,6:12))
	# # print(p.pet.mam); stop('cbw')
	# p.pet.spring <- sum(p.pet.spring)
	# writeRaster(p.pet.spring, paste(file.path,'water_deficit/p_pet_mam_',1900+j,'.nc',sep=''),overwrite=TRUE, varname='p_pet_mam')
	# # if (j==1) { p.pet.mam <- p.pet.spring }
	# # else { p.pet.mam <- addLayer(p.pet.mam, p.pet.spring) }
	# cat('year',1900+j,'\n')
# }
# # stop('cbw')

# full.file.paths <- list()
# for (j in 1:100)
# {
	# full.file.paths[[j]] <- paste(file.path,'water_deficit/p_pet_mam_',(1900+j),'.nc',sep='')
# }

# p.pet.mam <- stack(full.file.paths)

# print('p.pet.mam'); print(Sys.time()-startTime)
# # print(p.pet.mam); stop('cbw')

# mean.p.pet.mam <- mean(p.pet.mam, na.rm=TRUE)
# print('mean'); print(Sys.time()-startTime)
# writeRaster(mean.p.pet.mam, paste(file.path,'mean_p_pet_mam.nc',sep=''),overwrite=TRUE, varname='mean_p_pet_mam')
# # rm(mean.p.pet.mam)

# sd.p.pet.mam <- calc(p.pet.mam, sd, na.rm=TRUE)
# print('sd'); print(Sys.time()-startTime)
# writeRaster(sd.p.pet.mam, paste(file.path,'sd_p_pet_mam.nc',sep=''),overwrite=TRUE, varname='sd_p_pet_mam')
# # rm(sd.p.pet.mam)

# print('files written'); print(Sys.time()-startTime)



# # biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),band=1)
# biomes <- raster(paste(workspace,'VegProjections/wna30sec_1961-1990_biomes_DRAFT_v1.nc',sep=''),varname='biome')
