
library(RColorBrewer)
source('scenario.vector.r')

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

table.census.traits <- function(workspace, scenario, merge.table, reps, census.no, trait.name, years)
{
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[',reps,']/',scenario,'.',census.no,'.csv',sep=''))
	# cat(test,'\n')
	if (test==FALSE) { print('Cannot find file.'); return(NA) }
	census <- read.csv(paste(workspace,scenario,'/',scenario,'-[',reps,']/',scenario,'.',census.no,'.csv',sep=''),header=TRUE)
	# print(census[(years[1]+1),]); stop('cbw')
	census2 <- census[,7:dim(census)[2]]

	census2 <- census2[,(merge.table$trait.index + 1)]
	colnames(census2) <- paste(trait.name,merge.table$shape.index,sep='')
	
	census3 <- data.frame(census[,3:5],census2)
	census3 <- census3[(years[1]+1):(years[2]+1),]
	# print(census3); stop('cbw')
	
	the.means <- as.data.frame(round(apply(census3,MARGIN=2,FUN=mean)))
	colnames(the.means) <- 'the.mean'
	# print(the.means); stop('cbw')
	
	# census3 <- data.frame(census[,1:6],census2)
	# print(head(census3))
	write.csv(the.means, paste(workspace,scenario,'/',scenario,'-[',reps,']/',scenario,'.',trait.name,'.',years[1],'.',years[2],'.csv',sep=''))
	# return(census3)
}

the.change <- function(workspace, baseline, fut.scenarios, reps, trait.name, base.years, years, type)
{
	# Baseline Mean
	scenario <- baseline
	output <- read.csv(paste(workspace ,scenario,'/',scenario,'-[1]/',scenario,'.',trait.name,'.',base.years[1],'.',base.years[2],'.csv',sep=''),header=TRUE, row.names=1)
	# print(head(output)); stop('cbw')
	for (i in 2:reps)
	{
		temp <- read.csv(paste(workspace ,scenario,'/',scenario,'-[',i,']/',scenario,'.',trait.name,'.',base.years[1],'.',base.years[2],'.csv',sep=''),header=TRUE, row.names=1)
		output <- cbind(output,temp)
	}
	# print(head(output)); stop('cbw')
	temp.sum <- as.numeric(apply(output,MARGIN=1,mean))
	output$base.mean <- temp.sum
	write.csv(output,paste(workspace ,scenario,'/mean.',scenario,'.',trait.name,'.',base.years[1],'.',base.years[2],'.csv',sep=''))
	base.mean <- output$base.mean
	
	# Future Scenarios
	for (j in fut.scenarios)
	{
		scenario <- j
		output <- read.csv(paste(workspace ,scenario,'/',scenario,'-[1]/',scenario,'.',trait.name,'.',years[1],'.',years[2],'.csv',sep=''),header=TRUE, row.names=1)
		for (i in 2:reps)
		{
			temp <- read.csv(paste(workspace ,scenario,'/',scenario,'-[',i,']/',scenario,'.',trait.name,'.',years[1],'.',years[2],'.csv',sep=''),header=TRUE, row.names=1)
			output <- cbind(output,temp)
		}
		# print(head(output)); stop('cbw')
		temp.sum <- as.numeric(apply(output,MARGIN=1,mean))
		output$rep.mean <- temp.sum
		
		if (type=='p') { output$p.change <- round(100 * ((output$rep.mean - base.mean) / base.mean)) }
		if (type=='abs') { output$abs.change <- round(output$rep.mean - base.mean) }
		print(head(output))
		write.csv(output,paste(workspace,scenario,'/',type,'.change.',scenario, '.',trait.name,'.',years[1],'.',years[2],'.csv',sep=''))
	}
	# return(output)
}	

huc.table <- data.frame(shape.index=seq(1,1549,1),trait.index=seq(1,1549,1))
pro.area.table <- data.frame(shape.index=seq(1,1252,1),trait.index=seq(1,1252,1))
ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)
colnames(ecoregion.table) <- c('shape.index','ECO_NAME','trait.index')

folder <- 'wolverine_v1'
scenarios <- scenarios.vector(
				# base.sim='gulo.023.',
				base.sim='gulo.023.a2.',
				# gcms='baseline',
				gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'),
				# other=''
				other=c('','.biomes','.swe')
				)
# for (i in scenarios)
# {
	# for (j in 1:5)
	# {
		# table.census.traits(
			# workspace=paste('H:/HexSim/Workspaces/',folder,'/Results/',sep=''), 
			# scenario=i, 
			# merge.table=huc.table,
			# reps=j,
			# census.no=2,
			# trait.name='huc',
			# years=c(100,109)
			# )
		# cat(i,j,'\n')
		# # stop('cbw')
	# }
# }

the.change(workspace=paste('H:/HexSim/Workspaces/',folder,'/Results/',sep=''), baseline='gulo.023.baseline', fut.scenarios=scenarios, reps=5, trait.name='huc', base.years=c(41,50), years=c(41,50), type='abs')

stop('cbw')

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

