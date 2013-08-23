

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


plot.census.traits <- function(workspace, max.t, scenario,y.max, low.mean, high.mean, merge.table,main.text)
{
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.1.csv',sep=''))
	cat(test,'\n')
	if (test==FALSE) { return('Cannot find file.') }
	census <- read.csv(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.1.csv',sep=''),header=TRUE)
	
	census2 <- census[,7:dim(census)[2]]
	# max.pop <- as.vector(apply(census2, MARGIN=2, FUN=max))
	# max.pop.test <- max.pop > 50
	# max.pop.test[is.na(max.pop.test)==TRUE] <- FALSE
	census2 <- census2[,(merge.table$Trait.Index + 1)]
	colnames(census2) <- merge.table$ECO_NAME
	mean.pop <- as.vector(apply(census2[11:max.t,], MARGIN=2, FUN=mean))
	mean.pop.test <- mean.pop > low.mean & mean.pop < high.mean
	mean.pop.test[is.na(mean.pop.test)==TRUE] <- FALSE
	
	census3 <- data.frame(census[,1:6],census2[,mean.pop.test==TRUE])
	
	plot(1~1,type='n',ylim=c(0,y.max),xlim=c(11,max.t),ylab='population',xlab='time step',main=main.text)
	
	for (i in seq(7,dim(census3)[2],1))
	{
		lines(census3[11:max.t,i] ~ census$Time.Step[11:max.t], lwd=2, col=rainbow((dim(census3)[2]-6))[i-6])
	}
	legend(x=11,y=y.max,lwd=2,bty='n',legend=colnames(census3[,7:dim(census3)[2]]),col=rainbow((dim(census3)[2]-6)))
}
ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)

pdf('f:/pnwccva_data2/hexsim/workspaces/lynx_v1/Analysis/lynx.041b.census.pdf',height=16,width=6,pointsize=8)
	par(mfrow=c(6,3))
	# CCSM3
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b', max.t=36, y.max=50000, low.mean=2500, high.mean=50000, merge.table=ecoregion.table,main.text='boreal cycling, CRU')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b', max.t=36, y.max=5000, low.mean=500, high.mean=2500, merge.table=ecoregion.table,main.text='boreal cycling, CRU')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b', max.t=36, y.max=500, low.mean=10, high.mean=500, merge.table=ecoregion.table,main.text='boreal cycling, CRU')
	
	# CCSM3
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.ccsm3', max.t=108, y.max=50000, low.mean=2500, high.mean=50000, merge.table=ecoregion.table,main.text='boreal cycling, CCSM3')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.ccsm3', max.t=108, y.max=5000, low.mean=500, high.mean=2500, merge.table=ecoregion.table,main.text='boreal cycling, CCSM3')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.ccsm3', max.t=108, y.max=500, low.mean=10, high.mean=500, merge.table=ecoregion.table,main.text='boreal cycling, CCSM3')

	# CGCM3.1
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.cgcm3', max.t=108, y.max=50000, low.mean=2500, high.mean=50000, merge.table=ecoregion.table,main.text='boreal cycling, CGCM3')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.cgcm3', max.t=108, y.max=5000, low.mean=500, high.mean=2500, merge.table=ecoregion.table,main.text='boreal cycling, CGCM3')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.cgcm3', max.t=108, y.max=500, low.mean=10, high.mean=500, merge.table=ecoregion.table,main.text='boreal cycling, CGCM3')

	# GISS-ER
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b2.giss-er', max.t=108, y.max=50000, low.mean=2500, high.mean=50000, merge.table=ecoregion.table,main.text='boreal cycling, GISS-ER')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b2.giss-er', max.t=108, y.max=5000, low.mean=500, high.mean=2500, merge.table=ecoregion.table,main.text='boreal cycling, GISS-ER')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b2.giss-er', max.t=108, y.max=500, low.mean=10, high.mean=500, merge.table=ecoregion.table,main.text='boreal cycling, GISS-ER')

	# MIROC
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.miroc', max.t=108, y.max=50000, low.mean=2500, high.mean=50000, merge.table=ecoregion.table,main.text='boreal cycling, MIROC')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.miroc', max.t=108, y.max=5000, low.mean=500, high.mean=2500, merge.table=ecoregion.table,main.text='boreal cycling, MIROC')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b.miroc', max.t=108, y.max=500, low.mean=10, high.mean=500, merge.table=ecoregion.table,main.text='boreal cycling, MIROC')

	# HADCM3
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b2.hadcm3', max.t=108, y.max=50000, low.mean=2500, high.mean=50000, merge.table=ecoregion.table,main.text='boreal cycling, HADCM3')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b2.hadcm3', max.t=108, y.max=5000, low.mean=500, high.mean=2500, merge.table=ecoregion.table,main.text='boreal cycling, HADM3')
	plot.census.traits(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/', scenario='lynx.041b2.hadcm3', max.t=108, y.max=500, low.mean=10, high.mean=500, merge.table=ecoregion.table,main.text='boreal cycling, HADM3')
dev.off()
