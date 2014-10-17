

map.consolidator <- function(x,
							hexsim.wksp2,
							output.wksp2,
							output.wksp,
							spp.folder,
							map.name,
							parameters,
							base.map
							)
{
	# print(x)
	x <- gsub(pattern=' ',replacement='',x)
	# print(x)
	full.scenario <- paste(x['scenario'], x['model_1'],x['gcm'],sep='')
	print(full.scenario)
	export.hexmaps.temp(
					hexsim.wksp=hexsim.wksp2,
					output.wksp2=output.wksp2,
					spp.folder=spp.folder,
					scenario=full.scenario,
					n=x['rep'],
					time.step=x['year'],
					hexmap.name=map.name
					)

	temp <- read.csv(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/temp.csv',sep=''),header=TRUE)
	file.remove(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/temp.csv',sep=''))

	temp <- data.frame(base.map[,2],temp[,2])
	colnames(temp) <- c('space','year')
	# print(head(temp))

	temp <- aggregate(. ~ space, data=temp, FUN=sum)
	temp[,2] <- round(temp[,2])
	# print(head(temp))

	v.temp <- as.vector(temp[,2])
	v.temp <- c(x['model_2'],x['gcm'],x['rep'],x['year'],v.temp)
	names(v.temp) <- c('model','gcm','rep','year',temp[,1])
	# print(v.temp); stop('cbw')

	if (file.exists(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',x['scenario'], parameters[2],'.csv',sep=''))==FALSE)
	{
		write.csv(t(v.temp),paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',scenario, parameters[2],'.csv',sep=''),quote=FALSE)
	}
	else
	{
		write.table(t(v.temp),paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',scenario, parameters[2],'.csv',sep=''), append=TRUE,quote=FALSE,sep=',',col.names=FALSE)
	}
	# stop('cbw')	
}
