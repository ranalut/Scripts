# Snow water equivalent...

# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.path <- 'E:/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.name <- '/wna30sec_CRU_TS_2.10_'
variable.folders <- 'snowfall_swe_balance'

extract.swe <- function(file.path,file.name,variable.folders,month)
{
	full.file.paths <- list()

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
}

calc.swe <- function()
{
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
}


# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.path <- 'E:/bioclimate/annual/CRU_TS2.1_1901-2000/'
file.name <- '/wna30sec_CRU_TS_2.10_'
variable.folders <- 'snowfall_swe_balance'
startTime <- Sys.time()


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

