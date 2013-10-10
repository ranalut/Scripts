
library(RColorBrewer)
source('scenario.vector.r')

merge.report.traits <- function(workspace, scenario, r, report, trait.name, years, population)
{	
	# print(paste(workspace,scenario,'/',scenario,'-[',r,']/',scenario,report,population,'_',years[[1]][1],'_',years[[1]][2],'_[HucID].csv',sep=''))
	test <- file.exists(paste(workspace,scenario,'/',scenario,'-[',r,']/',scenario,report,population,'_',years[[1]][1],'_',years[[1]][2],'_[HucID].csv',sep=''))
	# cat(test,'\n'); stop('cbw')
	if (test==FALSE) { print('Cannot find file.'); return(NA) }
	the.data <- read.csv(paste(workspace,scenario,'/',scenario,'-[',r,']/',scenario,report,population,'_',years[[1]][1],'_',years[[1]][2],'_[HucID].csv',sep=''),header=TRUE)
	# print(head(the.data))
	the.data <- the.data[,c(1,4)]
	colnames(the.data) <- c('Trait.Index','rep1')
	# print(head(the.data)); stop('cbw')
	
	for (i in seq(2,length(years),1))
	{
		test <- file.exists(paste(workspace,scenario,'/',scenario,'-[',r,']/',scenario,report,population,'_',years[[i]][1],'_',years[[i]][2],'_[HucID].csv',sep=''))
		# cat(test,'\n'); stop('cbw')
		if (test==FALSE) { print('Cannot find file.'); return(NA) }
		temp <- read.csv(paste(workspace,scenario,'/',scenario,'-[',r,']/',scenario,report,population,'_',years[[i]][1],'_',years[[i]][2],'_[HucID].csv',sep=''),header=TRUE)
		temp <- temp[,c(1,4)]
		colnames(temp) <- c('Trait.Index',paste('rep',i,sep=''))
		# print(head(temp))
		the.data <- merge(the.data, temp, all=TRUE, by='Trait.Index')
	}
	# print(head(the.data)); stop('cbw')
	the.data$the.sum <- as.numeric(apply(X=the.data[,-1],MARGIN=1,FUN=sum, na.rm=TRUE))
	
	the.sum <- the.data[,c(1,dim(the.data)[2])]
	colnames(the.sum) <- c('CBW_CODE','variable')
	the.sum <- data.frame(the.sum$CBW_CODE,births=rep(NA,dim(the.sum)[1]),deaths=rep(NA,dim(the.sum)[1]),the.sum$variable)
	#print(head(the.means)); stop('cbw')
	write.csv(the.sum, paste(workspace,scenario,'/',scenario,'-[',r,']/',scenario,report,population,'_',years[[1]][1],'_',years[[length(years)]][2],'_[',trait.name,'].csv',sep=''))
	# return(census3)
}


huc.table <- data.frame(shape.index=seq(1,1549,1),trait.index=seq(1,1549,1))
pro.area.table <- data.frame(shape.index=seq(1,1252,1),trait.index=seq(1,1252,1))
ecoregion.table <- read.csv('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)
colnames(ecoregion.table) <- c('shape.index','ECO_NAME','trait.index')

folder <- 'wolverine_v1'
scenarios <- scenarios.vector(
				base.sim='gulo.023.a2.', # base.sim='gulo.023.',
				gcms=c('ccsm3','cgcm3','giss-er','hadcm3','miroc'), # gcms='baseline',
				other=c('','.biomes','.swe') # other=''
				)
for (i in scenarios)
{
	for (j in 1:5)
	{
		merge.report.traits(
			workspace=paste('H:/HexSim/Workspaces/',folder,'/Results/',sep=''), # workspace=paste('H:/HexSim/Workspaces/',folder,'/Results/',sep=''), 
			scenario=i, 
			r=j,
			report='_REPORT_productivity_',
			trait.name='HucID',
			years=list(c(31,40),c(41,50),c(51,60)),
			population='wolverine'
			)
		cat(i,j,'\n')
		# stop('cbw')
	}
}
