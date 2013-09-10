
library(RColorBrewer)

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


table.census.traits <- function(workspace, scenario, merge.table)
{
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.1.csv',sep=''))
	# cat(test,'\n')
	if (test==FALSE) { return('Cannot find file.') }
	census <- read.csv(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.1.csv',sep=''),header=TRUE)
	# print(head(census))
	census2 <- census[,7:dim(census)[2]]

	census2 <- census2[,(merge.table$Trait.Index + 1)]
	colnames(census2) <- merge.table$ECO_ID_U
	
	census3 <- data.frame(census[,1:6],census2)
	# print(head(census3))
	write.csv(census3,paste(workspace,scenario,'/',scenario,'-[1]/',scenario,'.eco.csv',sep=''))
	# return(census3)
}	
	
plot.census.traits <- function(workspace, max.t, scenarios, eco.region, y.max, main.text)
{	
	png(paste(workspace,'Analysis/',scenarios[1],'.',eco.region,'.png',sep=''))
	years <- seq(11,max.t,1) - 10 + 2000
	all.years <- seq(min(years)-20,max(years),1)
	plot(1~1,type='n',ylim=c(0,y.max),xlim=range(all.years),ylab='# of females',xlab='year',main=main.text)
	
	for (i in 1:length(scenarios))
	{
		census3 <- read.csv(paste(workspace,'Results/',scenarios[i],'/',scenarios[i],'-[1]/',scenarios[i],'.eco.csv',sep=''),header=TRUE,row.names=1)
		if (i!=1) { lines(census3[11:max.t,(eco.region+6)] ~ years, lwd=2, col=rev(brewer.pal(7,name='Set1')[-6])[i]) }
		if (i==1) { lines(census3[11:30,(eco.region+6)] ~ all.years[1:20], lwd=3, col=rev(brewer.pal(7,name='Set1')[-6])[i]) }
	}
	legend(x=years[10],y=y.max,lwd=2,bty='n',legend=scenarios,col=rev(brewer.pal(7,name='Set1')[-6]))
	dev.off()
}

ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)

folder <- 'lynx_v1'
scenarios <- c('lynx.041b','lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
# c(0,0,0,12241,173,0,0,2211,17163,1631,3016,0,5548,0,0,0,1610,16,0,3954,26993,7614,927,1,616,0,0,75,1,0,0,0,129,0,92)
y.max <- c(0,0,0,20000,750,0,0,5000,27000,4700,4500,10,9500,5,1000,350,3500,350,10,6000,50000,11000,1700,20,4000,0,0,750,250,0,0,10,350,5,500)
fig.titles <- c('boreal cycling, CRU','boreal cycling, CCSM3','boreal cycling, CGCM3','boreal cycling, GISS-ER','boreal cycling, MIROC','boreal cycling, HADCM3')
max.t <- 108

# folder <- 'wolverine_v1'
# scenarios <- c('gulo.017.baseline','gulo.017.a2.ccsm3','gulo.017.a2.cgcm3','gulo.017.a2.giss-er','gulo.017.a2.miroc','gulo.017.a2.hadcm3')
# # c(0,0,0,1633,87,0,0,338,1928,454,351,35,764,0,0,0,272,40,0,780,262,0,38,0,0,0,0,0,0,0,0,0,11,0,12)
# y.max <- c(10,10,10,2750,150,10,10,400,3000,800,500,50,1200,10,10,10,500,75,5,1400,600,0,200,0,5,0,0,10,8,0,0,0,20,5,35)
# fig.titles <- c('CRU','CCSM3','CGCM3','GISS-ER','MIROC','HADCM3')
# max.t <- 110

for (i in scenarios)
{
	table.census.traits(
		workspace=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',folder,'/Results/',sep=''), 
		scenario=i, 
		merge.table=ecoregion.table
		)
}

for (i in 1:dim(ecoregion.table)[1])
# for (i in 1)
{
	plot.census.traits(
		workspace=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',folder,'/',sep=''), 
		max.t=max.t, 
		scenarios=scenarios, 
		eco.region=i,
		y.max=y.max[i], 
		# main.text=paste(ecoregion.table$ECO_NAME[i],'\nboreal cycling',sep='')
		main.text=ecoregion.table$ECO_NAME[i]
		)
}

