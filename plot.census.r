

plot.census.reps <- function(workspace, max.t=120, scenario, max.reps=10,y.max=200000,output)
{
	plot(1~1,type='n',ylim=c(0,y.max),xlim=c(1,max.t),main=workspace,ylab='population',xlab='time step')
	for (i in seq(1,max.reps,1))
	{
		test <- file.exists(paste(workspace,scenario,'/',scenario,'-[',i,']/',scenario,'.0.csv',sep=''))
		cat(test,'\n')
		if (test==FALSE) { next(i) }
		census <- read.csv(paste(workspace,scenario,'/',scenario,'-[',i,']/',scenario,'.0.csv',sep=''),header=TRUE)
		if (output=='Population.Size') { lines(census$Population.Size ~ census$Time.Step, col=rainbow(max.reps)[i]) }
		if (output=='Group.Members') { lines(census$Group.Members ~ census$Time.Step, col=rainbow(max.reps)[i]) }
	}
}

# plot.census.reps(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.040.hadcm3')
# plot.census.reps(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.040.miroc',output='Population.Size')


plot.census.traits <- function(workspace, max.t=108, scenario,y.max.1=30000,y.max.2=2500)
{
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.1.csv',sep=''))
	cat(test,'\n')
	if (test==FALSE) { return('Cannot find file.') }
	census <- read.csv(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.1.csv',sep=''),header=TRUE)
	
	census2 <- census[,7:dim(census)[2]]
	max.pop <- as.vector(apply(census2, MARGIN=2, FUN=max))
	max.pop.test <- max.pop > 50
	max.pop.test[is.na(max.pop.test)==TRUE] <- FALSE
	
	census3 <- data.frame(census[,1:6],census2[,max.pop.test==TRUE])
	
	par(mfrow=c(2,2))	
	
	plot(1~1,type='n',ylim=c(0,y.max.1),xlim=c(1,max.t),main=workspace,ylab='population',xlab='time step')
	
	for (i in seq(7,dim(census3)[2],1))
	{
		lines(census3[,i] ~ census$Time.Step, col=rainbow((dim(census3)[2]-6))[i-6])
	}
	
	plot(1~1,type='n',ylim=c(0,y.max.2),xlim=c(1,max.t),main=workspace,ylab='population',xlab='time step')
	
	for (i in seq(7,dim(census3)[2],1))
	{
		lines(census3[,i] ~ census$Time.Step, col=rainbow((dim(census3)[2]-6))[i-6])
	}
}

plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/',scenario='lynx.041b.ccsm3')
