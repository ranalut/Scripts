# Snow water equivalent...

extract.swe <- function(file.path,file.name,variable.folders,month)
{
	full.file.paths <- list()

	for (j in 5:100) # Begin in 1905
	# for (j in 7)
	{
		the.months <- c('jan','feb','march','april','may','june','july','aug','sept','oct','nov','dec','max')
		full.file.path <- paste(file.path,variable.folders,file.name,variable.folders,'_first_day_of_month_',(1900+j),'.nc',sep='')
		# swe.all.months <- stack(full.file.path)
		swe.all.months <- brick(full.file.path)
		# print(swe.all.months)
		# return(swe.all.months); stop('cbw')
		
		if (month==13)
		{
			swe.single <- calc(swe.all.months, max, na.rm=TRUE) 
			# This step results in 4 warnings: In FUN(newX[, i], ...) : no non-missing arguments to max; returning -Inf.
			# I can't find any -Inf in the output, so I'm ignoring it.
			# print(swe.single)
			# plot(swe.single)
		}
		else
		{
			drop.months <- seq(1,12,1)[-month]
			# print(drop.months)
			
			swe.single <- dropLayer(swe.all.months, drop.months)
			# print(swe.single)
			# plot(swe.single)
		}
		
		swe.single[swe.single > 5000] <- 5000
		writeRaster(swe.single, paste(file.path,variable.folders,'/swe_',the.months[month],'_',(1900+j),'.nc',sep=''),overwrite=TRUE, varname=paste('swe_',the.months[month],sep=''))
		plot(swe.single)
		cat('year',1900+j,'\n')
		# return(swe.single)
		# stop('cbw')
	}
}

calc.swe <- function(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
{
	# March...
	the.months <- c('jan','feb','march','april','may','june','july','aug','sept','oct','nov','dec','max')
	full.file.paths <- list()
	for (j in 1:96) { full.file.paths[[j]] <- paste(file.path,variable.folders,'/swe_',the.months[month],'_',(1904+j),'.nc',sep='') }
	swe.all <- stack(full.file.paths)
	print('swe.all'); print(Sys.time()-startTime)
	return(swe.all)

	the.mean <- mean(swe.all, na.rm=TRUE)
	plot(the.mean)
	return(the.mean)
	print('mean'); print(Sys.time()-startTime)
	
	writeRaster(the.mean, paste(file.path,variable.folders,'/mean_swe_',the.months[month],'.nc',sep=''),overwrite=TRUE, varname=paste('mean_swe_',the.months[month],sep=''))
	# rm(mean.p.pet.mam)

	the.sd <- calc(swe.all, sd, na.rm=TRUE)
	plot(the.sd)
	print('sd'); print(Sys.time()-startTime)
	writeRaster(the.sd, paste(file.path,variable.folders,'/sd_swe_',the.months[month],'.nc',sep=''),overwrite=TRUE, varname=paste('sd_swe_',the.months[month],sep=''))
	# rm(sd.p.pet.mam)

	print('files written'); print(Sys.time()-startTime)
}


# file.path <- 'D:/PNWCCVA_Data1/bioclimate/annual/CRU_TS2.1_1901-2000/'
# file.path <- 'E:/bioclimate/annual/CRU_TS2.1_1901-2000/'
# file.name <- '/wna30sec_CRU_TS_2.10_'
# variable.folders <- 'snowfall_swe_balance'
# startTime <- Sys.time()

# temp <- extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
# plot(temp)
# extract.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)

# calc.swe(file.path=file.path,file.name=file.name,variable.folders=variable.folders,month=13)
