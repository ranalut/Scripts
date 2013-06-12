# Snow water equivalent...

extract.swe <- function(file.path.in, file.path.out, month, max.value)
{
		the.months <- c('jan','feb','march','april','may','june','july','aug','sept','oct','nov','dec','max')
		# swe.all.months <- stack(file.path.in)
		swe.all.months <- brick(file.path.in)
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
		
		swe.single[swe.single > max.value] <- max.value
		writeRaster(swe.single, file.path.out,overwrite=TRUE, varname=paste('swe_',the.months[month],sep=''))
		# plot(swe.single)
		# cat('year',1900+j,'\n')
		# return(swe.single)
		# stop('cbw')
}

calc.swe <- function(
	all.file.paths.in,
	file.path.out,
	variable,
	month='max'
	)
{
	startTime <- Sys.time()
		
	swe.all <- stack(all.file.paths.in)
	print('swe.all'); print(Sys.time()-startTime)
	# return(swe.all)

	the.mean <- mean(swe.all, na.rm=TRUE)
	# plot(the.mean,main='Mean')
	# return(the.mean)
	print('mean'); print(Sys.time()-startTime)
	
	writeRaster(the.mean, paste(file.path.out,'/mean_',variable,'_',month,'.nc',sep=''),overwrite=TRUE, varname=paste('mean_',variable,'_',month,sep=''))
	rm(the.mean)

	the.sd <- calc(swe.all, sd, na.rm=TRUE)
	# plot(the.sd, main='SD')
	print('sd'); print(Sys.time()-startTime)
	# plot(the.sd, main='SD')
	writeRaster(the.sd, paste(file.path.out,'/sd_',variable,'_',month,'.nc',sep=''),overwrite=TRUE, varname=paste('sd_',variable,'_',month,sep=''))
	rm(the.sd)

	print('files written'); print(Sys.time()-startTime)
}
