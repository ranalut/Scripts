

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
	print(head(census))
	census2 <- census[,7:dim(census)[2]]
	# max.pop <- as.vector(apply(census2, MARGIN=2, FUN=max))
	# max.pop.test <- max.pop > 50
	# max.pop.test[is.na(max.pop.test)==TRUE] <- FALSE
	census2 <- census2[,(merge.table$Trait.Index + 1)]
	colnames(census2) <- merge.table$ECO_NAME
	print(head(census2))
	mean.pop <- as.vector(apply(census2[11:max.t,], MARGIN=2, FUN=mean))
	mean.pop.test <- mean.pop > low.mean & mean.pop < high.mean
	mean.pop.test[is.na(mean.pop.test)==TRUE] <- FALSE
	
	census3 <- data.frame(census[,1:6],census2[,mean.pop.test==TRUE])
	print(head(census3))
	plot(1~1,type='n',ylim=c(0,y.max),xlim=c(11,max.t),ylab='population',xlab='time step',main=main.text)
	
	for (i in seq(7,dim(census3)[2],1))
	{
		lines(census3[11:max.t,i] ~ census$Time.Step[11:max.t], lwd=2, col=rainbow((dim(census3)[2]-6))[i-6])
	}
	legend(x=11,y=y.max,lwd=2,bty='n',legend=colnames(census3[,7:dim(census3)[2]]),col=rainbow((dim(census3)[2]-6)))
}
ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)

# folder <- 'lynx_v1'
# scenarios <- c('lynx.041b','lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
# y.max <- c(50000,5000,500)
# low.mean <- c(2500,500,10)
# high.mean <- c(50000,2500,500)
# fig.titles <- c('boreal cycling, CRU','boreal cycling, CCSM3','boreal cycling, CGCM3','boreal cycling, GISS-ER','boreal cycling, MIROC','boreal cycling, HADCM3')
# max.t <- 108

folder <- 'wolverine_v1'
scenarios <- c('gulo.017.baseline','gulo.017.a2.ccsm3','gulo.017.a2.cgcm3','gulo.017.a2.giss-er','gulo.017.a2.miroc','gulo.017.a2.hadcm3')
y.max <- c(10000,500,100)
low.mean <- c(2500,500,10)
high.mean <- c(50000,2500,500)
fig.titles <- c('CRU','CCSM3','CGCM3','GISS-ER','MIROC','HADCM3')
max.t <- 110

# pdf(paste('f:/pnwccva_data2/hexsim/workspaces/',folder,'/Analysis/lynx.041b.census.2.pdf',sep=''),height=16,width=6,pointsize=8)
pdf(paste('f:/pnwccva_data2/hexsim/workspaces/',folder,'/Analysis/gulo.017.census.pdf',sep=''),height=16,width=6,pointsize=8)
	par(mfrow=c(6,3))
	
	# Baseline
	plot.census.traits(workspace=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',folder,'/Results/',sep=''), scenario=scenarios[1], max.t=36, y.max=y.max[1], low.mean=low.mean[1], high.mean=high.mean[1], merge.table=ecoregion.table,main.text=fig.titles[1])
	plot.census.traits(workspace=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',folder,'/Results/',sep=''), scenario=scenarios[1], max.t=36, y.max=y.max[2], low.mean=low.mean[2], high.mean=high.mean[2], merge.table=ecoregion.table,main.text=fig.titles[1])
	plot.census.traits(workspace=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',folder,'/Results/',sep=''), scenario=scenarios[1], max.t=36, y.max=y.max[3], low.mean=low.mean[3], high.mean=high.mean[3], merge.table=ecoregion.table,main.text=fig.titles[1])

	for (i in 2:6)
		{
			for (j in 1:3)
			{
				plot.census.traits(
					workspace=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',folder,'/Results/',sep=''), 
					scenario=scenarios[i], 
					max.t=max.t, 
					y.max=y.max[j], 
					low.mean=low.mean[j], 
					high.mean=high.mean[j], 
					merge.table=ecoregion.table,
					main.text=fig.titles[i]
					)
			}
		}
dev.off()

