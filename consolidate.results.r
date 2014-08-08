
consolidate.results <- function(workspace, scenario, models, models2, theGCMs, reps)
{
	the.data <- read.csv(paste(workspace,'Results/',scenario,models[1],theGCMs[1],'/',scenario,models[1],theGCMs[1],'-[',1,']/',scenario,models[1],theGCMs[1],'.4.csv',sep=''),header=TRUE)
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
				temp <- read.csv(paste(workspace,'Results/',scenario,models[i],theGCMs[j],'/',scenario,models[i],theGCMs[j],'-[',k,']/',scenario,models[i],theGCMs[j],'.4.csv',sep=''),header=TRUE)
				if (dim(temp)[1] < records) { temp <- add.records(max.r=records, mat=temp) }
				temp <- data.frame(model=rep(models2[i],records),gcm=rep(theGCMs[j],records),replicate=rep(k,records),temp[,-1])
				the.data <- rbind(the.data, temp)
			}
		}
	}
	write.csv(the.data[,-dim(the.data)[2]], paste(workspace,'Analysis/',scenario,'all.csv',sep=''))
}	