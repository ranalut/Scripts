
deficit <- function(aet.file, pet.file, file.path.out)
{

	aet <- raster(aet.file, crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')
	pet <- raster(pet.file, crs='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0')

	deficit <- aet - pet
	# print('deficit'); print(Sys.time()-startTime)
	rm(aet)
	rm(pet)

	writeRaster(deficit, file.path.out, varname='deficit_mam',overwrite=TRUE)
}

the.time <- Sys.time()

# Historical

# file.folder <- 'H:/bioclimate/annual/CRU_TS2.1_1901-2000/'

# for (i in seq(1901,2000,1))
# {
	# deficit(
		# aet.file=paste(file.folder,'aet_mam_v1/wna30sec_CRU_TS_2.10_aet_mam_v1_',i,'.nc',sep=''),
		# pet.file=paste(file.folder,'pet_mam_v1/wna30sec_CRU_TS_2.10_pet_mam_v1_',i,'.nc',sep=''),
		# file.path.out=paste(file.folder,'deficit_mam_v1/deficit_mam_',i,'.nc',sep='')
		# )
	# cat('year ',i,'\n')
# }
# stop('cbw')


# Future
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

file.folder <- 'H:/bioclimate/annual/a2/'

for (i in seq(2001,2099,1))
{
	for (j in theGCMs)
	{
		deficit(
			aet.file=paste(file.folder,'aet_mam_a2_v1/wna30sec_a2_',j,'_aet_mam_v1_',i,'.nc',sep=''),
			pet.file=paste(file.folder,'pet_mam_a2_v1/wna30sec_a2_',j,'_pet_mam_v1_',i,'.nc',sep=''),
			file.path.out=paste(file.folder,'deficit_mam_a2_v1/',j,'_deficit_mam_',i,'.nc',sep='')
			)
		cat('a2 year ',i,' GCM ',j,' ',(Sys.time()-the.time),'\n')
		# stop('cbw')
	}
}

file.folder <- 'H:/bioclimate/annual/a1b/'

for (i in seq(2001,2099,1))
{
	for (j in theGCMs)
	{
		deficit(
			aet.file=paste(file.folder,'aet_mam_a1b_v1/wna30sec_a2_',j,'_aet_mam_v1_',i,'.nc',sep=''),
			pet.file=paste(file.folder,'pet_mam_a1b_v1/wna30sec_a2_',j,'_pet_mam_v1_',i,'.nc',sep=''),
			file.path.out=paste(file.folder,'deficit_mam_a1b_v1/',j,'_deficit_mam_',i,'.nc',sep='')
			)
		cat('a2 year ',i,' GCM ',j,' ',(Sys.time()-the.time),'\n')
	}
}

