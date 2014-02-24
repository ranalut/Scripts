
# Script for parameterizing a linear model for change in lambda relative to an environmental variable.

calc.slope <- function(workspace, distribution, subset.map=NULL, subset.value, variable, spread, output)
{
	spp.dist <- read.csv(paste(workspace,'Analysis/',distribution,sep=''),header=TRUE)
	colnames(spp.dist) <- c('hexid','pa')
	print(head(spp.dist)); print(dim(spp.dist))
	
	if (is.null(subset.map)==FALSE)
	{
		subset.dist <- as.numeric(read.csv(paste(workspace,'Analysis/',subset.map,sep=''),header=TRUE)[,2])
		print(length(subset.dist))
		spp.dist$pa[subset.dist!=subset.value] <- 0
	}
	
	if (spread==FALSE)
	{
		spp.dist$variable <- as.numeric(read.csv(paste(workspace,'Analysis/',variable,sep=''),header=TRUE)[,2])
		print(head(spp.dist)); print(dim(spp.dist))
		
		spp.dist <- spp.dist[spp.dist$pa!=0,]
		print(dim(spp.dist))
		
		# spp.dist <- spp.dist[sample(seq(1,dim(spp.dist)[1],1),size=10000),] # Did not make a difference.  Would need to be geographically balanced to make a difference.  Stratified sampling by elevation or something.
		
		hist(spp.dist$variable)
		quantiles <- quantile(spp.dist$variable,probs=c(0.02,0.05,0.5,0.95,0.98))
		print(quantiles)
		sink(paste(workspace,'Analysis/',output,sep=''))
			cat(c(0.02,0.05,0.5,0.95,0.98),'\n',quantiles)
		sink()
		return(spp.dist)
	}
	
	if (spread==TRUE)
	{
		spp.dist$variable1 <- as.numeric(read.csv(paste(workspace,'Analysis/',variable[1],sep=''),header=TRUE)[,2])
		print(head(spp.dist)); print(dim(spp.dist))
		spp.dist$variable2 <- as.numeric(read.csv(paste(workspace,'Analysis/',variable[2],sep=''),header=TRUE)[,2])
		print(head(spp.dist)); print(dim(spp.dist))
				
		spp.dist <- spp.dist[spp.dist$pa!=0,]
		print(dim(spp.dist))
		
		spp.dist$spread <- spp.dist$variable2 - spp.dist$variable1
		hist(spp.dist$spread)
		quantiles <- quantile(spp.dist$spread,probs=c(0.02,0.05,0.5,0.95,0.98))
		print(quantiles)
		sink(paste(workspace,'Analysis/',output,sep=''))
			cat(c(0.02,0.05,0.5,0.95,0.98),'\n',quantiles)
		sink()
		return(spp.dist)
	}
}

test1 <- calc.slope(
	workspace='D:/data/wilsey/hexsim/workspaces/spotted_frog_v2/', # 'S:/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/spotted_frog_v2/', 
	distribution='initial.v3.csv', 
	subset.map='biomes.aet.v1.csv',
	subset.value=1, # Range = 1, Basin = -1
	variable='q50.aet.jja.61.90.csv', 
	spread=FALSE,
	output='q50.quant.aet.jja.2.txt'
	)

test2 <- calc.slope(
	workspace='D:/data/wilsey/hexsim/workspaces/spotted_frog_v2/', # 'S:/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/spotted_frog_v2/', 
	distribution='initial.v3.csv', 
	subset.map='biomes.aet.v1.csv',
	subset.value=-1, # Range = 1, Basin = -1
	variable='q50.aet.mam.61.90.csv', 
	spread=FALSE,
	output='q50.quant.aet.mam.2.txt'
	)
	
	
# stop('cbw')	

# test2 <- calc.slope(
	# workspace='S:/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/spotted_frog_v2/', 
	# distribution='initial.v3.csv', 
	# subset.map='biomes.aet.v1.csv',
	# subset.value=1, # Range = 1, Basin = -1
	# variable=c('q5.aet.jja.61.90.csv','q95.aet.jja.61.90.csv'), 
	# spread=TRUE,
	# output='spread.quant.aet.jja.txt'
	# )
