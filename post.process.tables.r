
post.processing <- function(workspace,scenario,models2,theGCMs,reps,spatial.name)
{
	the.data <- read.csv(paste(workspace,'Analysis/',scenario,'all.',spatial.name,'.csv',sep=''), header=TRUE, row.names=1)
	to.drop <- match(c("replicate","Population.Size","Group.Members","Floaters","Lambda","Trait.Index..0"),colnames(the.data))
	the.data <- the.data[,-to.drop]
	# the.data <- the.data[,-c("Population.Size","Group.Members","Floaters","Lambda","Trait.Index..0")]
	
	the.data.2 <- aggregate(. ~ model + gcm + Time.Step, data=the.data, FUN=mean)
	print(the.data.2[1:20,]); print(unique(the.data.2$replicate)); stop('cbw')

	# Pull out and save each model output...
	
	
	
}
