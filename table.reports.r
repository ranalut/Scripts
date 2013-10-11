
library(RColorBrewer)
source('scenario.vector.r')

table.report.traits <- function(workspace, scenario, merge.table, reps, report, report.output, trait.name, years, population)
{	
	# print(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,report,population,'_',years[1],'_',years[2],'_[HucID].csv',sep=''))
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,report,population,'_',years[1],'_',years[2],'_[HucID].csv',sep=''))
	# cat(test,'\n'); stop('cbw')
	if (test==FALSE) { print('Cannot find file.'); return(NA) }
	the.data <- read.csv(paste(workspace,scenario,'/',scenario,'-[1]/',scenario,report,population,'_',years[1],'_',years[2],'_[HucID].csv',sep=''),header=TRUE)
	# print(head(the.data))
	the.data <- the.data[,c(1,4)]
	colnames(the.data) <- c('Trait.Index','rep1')
	# print(head(the.data)); stop('cbw')
	
	for (i in seq(2,reps,1))
	{
		test <- file.exists(paste(workspace,scenario,'/',scenario,'-[',i,']/',scenario,report,population,'_',years[1],'_',years[2],'_[HucID].csv',sep=''))
		# cat(test,'\n'); stop('cbw')
		if (test==FALSE) { print('Cannot find file.'); return(NA) }
		temp <- read.csv(paste(workspace,scenario,'/',scenario,'-[',i,']/',scenario,report,population,'_',years[1],'_',years[2],'_[HucID].csv',sep=''),header=TRUE)
		temp <- temp[,c(1,4)]
		colnames(temp) <- c('Trait.Index',paste('rep',i,sep=''))
		# print(head(temp))
		the.data <- merge(the.data, temp, all=TRUE, by='Trait.Index')
	}
	# print(head(the.data)); stop('cbw')
	the.data$the.mean <- as.numeric(apply(X=the.data[,-1],MARGIN=1,FUN=mean, na.rm=TRUE))
	
	the.means <- the.data[,c(1,7)]
	colnames(the.means) <- c('CBW_CODE','variable')
	# print(head(the.means)); stop('cbw')
	write.csv(the.means, paste(workspace,scenario,'/',scenario,report.output,trait.name,'.',years[1],'.',years[2],'.csv',sep=''))
	# return(census3)
}


huc.table <- data.frame(shape.index=seq(1,1549,1),trait.index=seq(1,1549,1))
pro.area.table <- data.frame(shape.index=seq(1,1252,1),trait.index=seq(1,1252,1))
ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)
colnames(ecoregion.table) <- c('shape.index','ECO_NAME','trait.index')

folder <- 'wolverine_v1' # 'lynx_v1' # 'wolverine_v1'
scenarios <- scenarios.vector(
				base.sim='gulo.023.',# base.sim='lynx.050.', # base.sim='gulo.023.a2.',# base.sim='gulo.023.',
				gcms='baseline', # gcms='baseline', # gcms=c('baseline','ccsm3','cgcm3','giss-er','hadcm3','miroc')
				other='' #other=c('','.35') # other=c('','.biomes','.swe')# other=''
				)
for (i in scenarios)
{
	table.report.traits(
		workspace=paste('H:/HexSim/Workspaces/',folder,'/Results/',sep=''), # workspace=paste('H:/HexSim/Workspaces/',folder,'/Results/',sep=''), 
		scenario=i, 
		merge.table=huc.table,
		reps=5,
		report='_REPORT_productivity_',
		report.output='.report.productivity.',
		trait.name='huc',
		years=c(21,50),
		population='wolverine'
		)
	cat(i,j,'\n')
	# stop('cbw')
	
}
