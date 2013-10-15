
library(RColorBrewer)
source('scenario.vector.r')

table.census.traits <- function(workspace, scenario, merge.table, reps, census.no, trait.name, years)
{
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[',reps,']/',scenario,'.',census.no,'.csv',sep=''))
	# print(paste(workspace,scenario,'/',scenario,'-[',reps,']/',scenario,'.',census.no,'.csv',sep=''))
	# cat(test,'\n'); stop('cbw')
	if (test==FALSE) { print('Cannot find file.'); return(NA) }
	census <- read.csv(paste(workspace,scenario,'/',scenario,'-[',reps,']/',scenario,'.',census.no,'.csv',sep=''),header=TRUE)
	# print(census[(years[1]+1),]); stop('cbw')
	census2 <- census[,7:dim(census)[2]]
	
	if(length(grep('rana',scenario))==1)
	{
		temp.census <- list(census2[,1:1550],census2[,1551:3100],census2[,3101:4650],census2[,4651:6200],census2[,6201:7750],census2[,7751:9300])
		census2 <- temp.census[[3]] + temp.census[[4]] + temp.census[[5]] # Considering populations > 50 individuals
		# print(dim(census2)); print(census2[1,1:10]); stop('cbw')
	}
	
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
	
	# print(fut.scenarios); stop('cbw')
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

summarize.census <- function(workspace, folder, base.sim, gcms, other, census.no, trait.name, reps, fut.years, baseline, base.years, type)
{
	if (trait.name=='huc') { merge.table <- data.frame(shape.index=seq(1,1549,1),trait.index=seq(1,1549,1)) }
	# pro.area.table <- data.frame(shape.index=seq(1,1252,1),trait.index=seq(1,1252,1))
	# ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)
	# colnames(ecoregion.table) <- c('shape.index','ECO_NAME','trait.index')

	scenarios <- scenarios.vector(base.sim=base.sim, gcms=gcms, other=other)
	
	for (i in scenarios)
	{
		for (j in 1:5)
		{
			if(length(grep('base',i))>0) { temp.years <- base.years }
			else { temp.years <- fut.years }
			table.census.traits(
				workspace=paste(workspace,folder,'/Results/',sep=''), # workspace=paste('I:/HexSim/Workspaces/',folder,'/Results/',sep=''), #  
				scenario=i, 
				merge.table=merge.table,
				reps=j,
				census.no=census.no,
				trait.name=trait.name,
				years=temp.years
				)
			cat(i,j,'\n')
			# stop('cbw')
		}
	}
	
	if (length(grep('base',scenarios)) >= 1) { fut.scenarios <- scenarios[-grep('base',scenarios)] }
	else { fut.scenarios <- scenarios }
	# print(fut.scenarios); stop('cbw')
	
	the.change(workspace=paste(workspace,folder,'/Results/',sep=''), baseline=baseline, fut.scenarios=fut.scenarios, reps=reps, trait.name=trait.name, base.years=base.years, years=fut.years, type=type)
}

# # Wolverine
# summarize.census(
		# workspace='H:/HexSim/Workspaces/', 
		# folder='wolverine_v1', 
		# base.sim'gulo.023.a2.', # base.sim='lynx.050.', # base.sim='gulo.023.a2.',
		# gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'), # gcms='baseline', # gcms=c('baseline','ccsm3','cgcm3','giss-er','hadcm3','miroc'),
		# other=c('','.biomes','.swe'), # other='', # other=c('','.35') 
		# census.no=2, 
		# trait.name='huc', 
		# reps=5, 
		# fut.years=c(51,60), # c(25,51), 
		# baseline='gulo.023.baseline', 
		# base.years=c(41,50), 
		# type='abs'
		# )

# Lynx
# All year segments = list(c(16,24),c(25,33),c(34,42),c(43,51),c(52,60),c(61,69),c(70,78),c(79,87),c(88,96),c(97,105))
# 2, 30-year windows = list(c(34,60),c(79,105))
# baseline window = list(c(25,51))
# summarize.census(
		# workspace='I:/HexSim/Workspaces/', 
		# folder='lynx_v1', 
		# base.sim='lynx.050.',
		# gcms=c('baseline','ccsm3','cgcm3','giss-er','hadcm3','miroc'),
		# other='', # '', '.35' # c('','.35'), # Run .35 separately with .35 baseline (below).
		# census.no=2, 
		# trait.name='huc', 
		# reps=5, 
		# fut.years=c(97,105), 
		# baseline='lynx.050.baseline.35', # Will need to run with .35 as the baseline
		# base.years=c(34,42), 
		# type='abs'
		# )

# Spotted Frog
summarize.census(
		workspace='//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/', 
		folder='spotted_frog_v2', 
		base.sim='rana.lut.104.100.', #'rana.lut.104.90.' # 'rana.lut.104.100.'
		gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'), # gcms='baseline',
		other=c('','.aet','.swe'), # c('','.aet','.swe'), # '',
		census.no=1, 
		trait.name='huc', 
		reps=5, 
		fut.years=c(99,109), 
		baseline='rana.lut.104.100.baseline', 
		base.years=c(31,40), 
		type='abs'
		)		
	
		
