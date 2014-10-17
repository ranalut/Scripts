library(foreign)
source('esri.friendly.names.r')

post.processing.hab.maps <- function(workspace,scenario,models2,theGCMs,spatial.name,ref.field,ref.values,out.name)
{
	gcm.names <- c('ccsm3','cgcm3','giss','miroc','hadcm3')
	shp <- c('represented_ecoregions','watersheds','protected_areas','sagr_mgmt_zones')
	names(shp) <- c('eco','huc','pa','smz')
	# out.dir <- paste('h:/outputs/',out.name,'/',sep='')
	out.dir <- paste('l:/space_lawler/shared/wilsey/postdoc/outputs/',out.name,'/',sep='')
	dir.create(out.dir,recursive=TRUE)
	
	the.data <- read.csv(paste(workspace,'Analysis/',scenario,'all.',spatial.name,'.csv',sep=''), header=TRUE)
	# print(colnames(the.data)); print(head(the.data)); stop('cbw')
	to.drop <- match(c("X","X0"),colnames(the.data))
	the.data <- the.data[,-to.drop]
	the.data.2 <- the.data
	
	for (i in 1:length(theGCMs))
	{
		for (j in 1:length(models2))
		{
			temp <- the.data.2[the.data.2$gcm==theGCMs[i] & the.data.2$model==models2[j],]
			# print(head(temp))
			rownames(temp) <- paste('Y',temp$year + 1990,sep='')
			to.drop <- match(c("year","model","gcm"),colnames(temp))
			temp <- temp[,-to.drop]
			temp <- t(temp)
			# temp <- temp[,-c(1:10,112:116)]
			temp <- temp * 0.866 # Convert to km2
			temp <- round(temp)
			# print(head(temp)); print(tail(temp))
			temp <- data.frame(as.integer(gsub('X','',rownames(temp))), temp)
			colnames(temp) <- c(ref.field,colnames(temp)[-1])
			# print(head(temp)); stop('cbw')
			temp$d2020 <- temp$Y2020 - temp$Y2000
			temp$d2050 <- temp$Y2050 - temp$Y2000
			temp$d2100 <- temp$Y2100 - temp$Y2000
			
			# areas <- read.dbf(paste('h:/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
			# areas <- read.dbf(paste('l:/space_lawler/shared/wilsey/postdoc/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
			# temp <- merge(temp,areas[,c('AREA_SQKM',ref.field)],by=ref.field)
			# print(head(temp)); stop('cbw')
			
			gcm.name <- match(theGCMs[i],theGCMs)
			gcm.name <- gcm.names[gcm.name]
			write.dbf(temp,paste(out.dir,out.name,'_',spatial.name,'_',models2[j],'_',gcm.name,'_',esri.friendly(scenario,drop.last=1),'.dbf',sep=''))
			# stop('cbw')
		}
	}
	
	# Average across GCMs and save output for each model...
	to.drop <- match(c("gcm"),colnames(the.data.2))
	the.data.3 <- the.data.2[,-to.drop]
	the.data.3 <- aggregate(. ~ model + year, data=the.data.3, FUN=mean)
	
	for (i in 1:length(models2))
	{
		temp <- the.data.3[the.data.3$model==models2[i],]
		# print(head(temp))
		rownames(temp) <- paste('Y',temp$year + 1990,sep='')
		to.drop <- match(c("year","model"),colnames(temp))
		temp <- temp[,-to.drop]
		temp <- t(temp)
		# temp <- temp[,-c(1:10,112:116)]
		temp <- temp * 0.866 # Convert to km2
		temp <- round(temp)
		temp <- data.frame(as.integer(gsub('X','',rownames(temp))), temp)
		colnames(temp) <- c(ref.field,colnames(temp)[-1]) # print(head(temp))
		temp$d2020 <- temp$Y2020 - temp$Y2000
		temp$d2050 <- temp$Y2050 - temp$Y2000
		temp$d2100 <- temp$Y2100 - temp$Y2000
			
		# areas <- read.dbf(paste('l:/space_lawler/shared/wilsey/postdoc/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
		# temp <- merge(temp,areas[,c('AREA_SQKM',ref.field)],by=ref.field)
			
		write.dbf(temp,paste(out.dir,out.name,'_',spatial.name,'_',models2[i],'_ave_',esri.friendly(scenario,drop.last=1),'.dbf',sep=''))
		# print(head(temp)); stop('cbw')
	}
	
	# Average across GCMs and save output for each model...
	to.drop <- match(c("gcm"),colnames(the.data.2))
	the.data.3b <- the.data.2[,-to.drop]
	the.data.3b <- aggregate(. ~ model + year, data=the.data.3b, FUN=sd)
	
	for (i in 1:length(models2))
	{
		temp <- the.data.3b[the.data.3b$model==models2[i],]
		rownames(temp) <- paste('Y',temp$year + 1990,sep='')
		to.drop <- match(c("year","model"),colnames(temp))
		temp <- temp[,-to.drop]
		temp <- t(temp)
		# temp <- temp[,-c(1:10,112:116)]
		temp <- temp * 0.866 # Convert to km2
		temp <- round(temp)
		temp <- data.frame(as.integer(gsub('X','',rownames(temp))), temp)
		colnames(temp) <- c(ref.field,colnames(temp)[-1]) 
		temp$d2020 <- temp$Y2020 - temp$Y2000
		temp$d2050 <- temp$Y2050 - temp$Y2000
		temp$d2100 <- temp$Y2100 - temp$Y2000
		
		# areas <- read.dbf(paste('l:/space_lawler/shared/wilsey/postdoc/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
		# temp <- merge(temp,areas[,c('AREA_SQKM',ref.field)],by=ref.field)
					
		write.dbf(temp,paste(out.dir,out.name,'_',spatial.name,'_',models2[i],'_sd_',esri.friendly(scenario,drop.last=1),'.dbf',sep=''))
		# print(head(temp)); stop('cbw')
	}
	# stop('cbw')
}
