
consolidate.results <- function(workspace, scenario, models, models2, theGCMs, reps, spatial.ref, spatial.name)
{
	the.data <- read.csv(paste(workspace,'Results/',scenario,models[1],theGCMs[1],'/',scenario,models[1],theGCMs[1],'-[',1,']/',scenario,models[1],theGCMs[1],'.',spatial.ref,'.csv',sep=''),header=TRUE)
	records <- dim(the.data)[1]
	the.data <- data.frame(model=rep(models2[1],records),gcm=rep(theGCMs[1],records),replicate=rep(1,records),the.data[,-1])

	for (i in 1:length(models))
	{
		for (j in 1:length(theGCMs))
		{
			for (k in 1:reps)
			{
				if (i==1 & j==1 & k==1) { next(k) }
				# cat(i,j,k,'\n',sep=' ')
				temp <- read.csv(paste(workspace,'Results/',scenario,models[i],theGCMs[j],'/',scenario,models[i],theGCMs[j],'-[',k,']/',scenario,models[i],theGCMs[j],'.',spatial.ref,'.csv',sep=''),header=TRUE)
				if (dim(temp)[1] < records) { temp <- add.records(max.r=records, mat=temp) }
				temp <- data.frame(model=rep(models2[i],records),gcm=rep(theGCMs[j],records),replicate=rep(k,records),temp[,-1])
				the.data <- rbind(the.data, temp)
			}
		}
	}
	write.csv(the.data[,-dim(the.data)[2]], paste(workspace,'Analysis/',scenario,'all.',spatial.name,'.csv',sep=''))
}	

consolidate.results.2 <- function(workspace, scenario, models, models2, theGCMs, reps, spatial.ref, spatial.name)
{
	the.data <- read.csv(paste(workspace,'Results/',scenario,theGCMs[1],models[1],'/',scenario,theGCMs[1],models[1],'-[',1,']/',scenario,theGCMs[1],models[1],'.',spatial.ref,'.csv',sep=''),header=TRUE)
	records <- dim(the.data)[1]
	the.data <- data.frame(model=rep(models2[1],records),gcm=rep(theGCMs[1],records),replicate=rep(1,records),the.data[,-1])

	for (i in 1:length(models))
	{
		for (j in 1:length(theGCMs))
		{
			for (k in 1:reps)
			{
				if (i==1 & j==1 & k==1) { next(k) }
				# cat(i,j,k,'\n',sep=' ')
				test <- file.exists(paste(workspace,'Results/',scenario,theGCMs[j],models[i],'/',scenario,theGCMs[j],models[i],'-[',k,']/',scenario,theGCMs[j],models[i],'.',spatial.ref,'.csv',sep=''))
				if (test==FALSE) { next(k) }
				temp <- read.csv(paste(workspace,'Results/',scenario,theGCMs[j],models[i],'/',scenario,theGCMs[j],models[i],'-[',k,']/',scenario,theGCMs[j],models[i],'.',spatial.ref,'.csv',sep=''),header=TRUE)
				if (dim(temp)[1] < records) { temp <- add.records(max.r=records, mat=temp) }
				temp <- data.frame(model=rep(models2[i],records),gcm=rep(theGCMs[j],records),replicate=rep(k,records),temp[,-1])
				the.data <- rbind(the.data,temp)
				# cat('k ')
			}
			# cat('\n')
		}
		# cat(models[i],'\n')
	}
	write.csv(the.data[,-dim(the.data)[2]], paste(workspace,'Analysis/',scenario,'all.',spatial.name,'.csv',sep=''))
}