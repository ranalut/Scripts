library(foreign)
source('esri.friendly.names.r')

post.processing.lynx <- function(workspace,scenario,models2,theGCMs,reps,spatial.name,ref.field,ref.values,out.name)
{
	gcm.names <- c('ccsm3','cgcm3','giss','miroc','hadcm3')
	shp <- c('represented_ecoregions','watersheds','protected_areas','sagr_mgmt_zones')
	names(shp) <- c('eco','huc','pa','smz')
	out.dir <- paste('h:/outputs/',out.name,'/',sep='')
	dir.create(out.dir,recursive=TRUE)
	
	the.data <- read.csv(paste(workspace,'Analysis/',scenario,'all.',spatial.name,'.csv',sep=''), header=TRUE, row.names=1)
	to.drop <- match(c("replicate","Population.Size","Group.Members","Floaters","Lambda","Trait.Index..0"),colnames(the.data))
	the.data <- the.data[,-to.drop]

	# Average across replicates and pull out and save outputs for each model x GCM combination...
	the.data.2 <- aggregate(. ~ model + gcm + Time.Step, data=the.data, FUN=mean)
	# print(the.data.2[1:20,]); print(unique(the.data.2$replicate)); stop('cbw')

	for (i in 1:length(theGCMs))
	{
		for (j in 1:length(models2))
		{
			temp <- the.data.2[the.data.2$gcm==theGCMs[i] & the.data.2$model==models2[j],]
			# print(head(temp))
			rownames(temp) <- paste('Y',temp$Time.Step + 1990,sep='')
			to.drop <- match(c("Time.Step","model","gcm"),colnames(temp))
			temp <- temp[,-to.drop]
			temp <- t(temp)
			temp <- temp[,-c(1:6)]
			temp <- round(temp)
			temp <- data.frame(ref.values, temp)
			colnames(temp) <- c(ref.field,colnames(temp)[-1]) # print(head(temp))
			temp$Y2000s <- round(apply(temp[,c(paste('Y',seq(1997,2005,1),sep=''))],1,mean))
			temp$Y2020s <- round(apply(temp[,c(paste('Y',seq(2024,2032,1),sep=''))],1,mean))
			temp$Y2050s <- round(apply(temp[,c(paste('Y',seq(2051,2060,1),sep=''))],1,mean))
			temp$Y2090s <- round(apply(temp[,c(paste('Y',seq(2087,2095,1),sep=''))],1,mean))
			temp$d2020s <- temp$Y2020s - temp$Y2000s
			temp$d2050s <- temp$Y2050s - temp$Y2000s
			temp$d2090s <- temp$Y2090s - temp$Y2000s
			
			# areas <- read.dbf(paste('h:/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
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
	the.data.3 <- aggregate(. ~ model + Time.Step, data=the.data.3, FUN=mean)
	
	for (i in 1:length(models2))
	{
		temp <- the.data.3[the.data.3$model==models2[i],]
		# print(head(temp))
		rownames(temp) <- paste('Y',temp$Time.Step + 1990,sep='')
		to.drop <- match(c("Time.Step","model"),colnames(temp))
		temp <- temp[,-to.drop]
		temp <- t(temp)
		temp <- temp[,-c(1:6)]
		temp <- round(temp)
		temp <- data.frame(ref.values, temp)
		colnames(temp) <- c(ref.field,colnames(temp)[-1]) # print(head(temp))
		temp$Y2000s <- round(apply(temp[,c(paste('Y',seq(1997,2005,1),sep=''))],1,mean))
		temp$Y2020s <- round(apply(temp[,c(paste('Y',seq(2024,2032,1),sep=''))],1,mean))
		temp$Y2050s <- round(apply(temp[,c(paste('Y',seq(2051,2060,1),sep=''))],1,mean))
		temp$Y2090s <- round(apply(temp[,c(paste('Y',seq(2087,2095,1),sep=''))],1,mean))
		temp$d2020s <- temp$Y2020s - temp$Y2000s
		temp$d2050s <- temp$Y2050s - temp$Y2000s
		temp$d2090s <- temp$Y2090s - temp$Y2000s
		
		# areas <- read.dbf(paste('h:/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
		# temp <- merge(temp,areas[,c('AREA_SQKM',ref.field)],by=ref.field)
			
		write.dbf(temp,paste(out.dir,out.name,'_',spatial.name,'_',models2[i],'_ave_',esri.friendly(scenario,drop.last=1),'.dbf',sep=''))
		# print(head(temp)); stop('cbw')
	}
	
	# Average across GCMs and save output for each model...
	to.drop <- match(c("gcm"),colnames(the.data.2))
	the.data.3b <- the.data.2[,-to.drop]
	the.data.3b <- aggregate(. ~ model + Time.Step, data=the.data.3b, FUN=sd)
	
	for (i in 1:length(models2))
	{
		temp <- the.data.3b[the.data.3b$model==models2[i],]
		rownames(temp) <- paste('Y',temp$Time.Step + 1990,sep='')
		to.drop <- match(c("Time.Step","model"),colnames(temp))
		temp <- temp[,-to.drop]
		temp <- t(temp)
		temp <- temp[,-c(1:6)]
		temp <- round(temp)
		temp <- data.frame(ref.values, temp)
		colnames(temp) <- c(ref.field,colnames(temp)[-1]) 
		temp$Y2000s <- round(apply(temp[,c(paste('Y',seq(1997,2005,1),sep=''))],1,mean))
		temp$Y2020s <- round(apply(temp[,c(paste('Y',seq(2024,2032,1),sep=''))],1,mean))
		temp$Y2050s <- round(apply(temp[,c(paste('Y',seq(2051,2060,1),sep=''))],1,mean))
		temp$Y2090s <- round(apply(temp[,c(paste('Y',seq(2087,2095,1),sep=''))],1,mean))
		temp$d2020s <- temp$Y2020s - temp$Y2000s
		temp$d2050s <- temp$Y2050s - temp$Y2000s
		temp$d2090s <- temp$Y2090s - temp$Y2000s
		
		# areas <- read.dbf(paste('h:/outputs/pnwccva_',shp[spatial.name],'_albers.dbf',sep=''),as.is=TRUE)
		# temp <- merge(temp,areas[,c('AREA_SQKM',ref.field)],by=ref.field)
					
		write.dbf(temp,paste(out.dir,out.name,'_',spatial.name,'_',models2[i],'_sd_',esri.friendly(scenario,drop.last=1),'.dbf',sep=''))
		# print(head(temp)); stop('cbw')
	}
}
