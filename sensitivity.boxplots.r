
setwd('c:/users/cbwilsey/documents/github/scripts/')
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)

source('data.prep.r')
source('extract.number.r')

# extract.number <- function(x,var.name) { temp <- as.numeric(strsplit(x,split=var.name)[[1]][2]); return(temp) }

sensitive.boxplots <- function(workspace, species.folder, baseline.scenario, baseline.time, future.scenario, spatial.variable, time.window, data.type, legend.label, suffix, the.labels, leg.x, leg.y, ylab)
{
	# Plotting data
	if (data.type=='abundance') { historical.data <- as.numeric(data.prep(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/mean.',baseline.scenario,'.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='abundance',var.name=spatial.variable)[,'variable']) }
	# if (data.type=='productivity') { historical.data <- data.prep(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/',baseline.scenario,'.report.productivity.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='productivity',var.name=spatial.variable) }
	# print(head(historical.data))

	fut.data <- list()
	gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
	for (j in 1:length(suffix))
	{
		place.holders <- seq(-5,-1,1) + j*6
		# print(place.holders)
		for (i in 1:5)
		{
			# cat('gcm',gcms[i],'\n')
			if (data.type=='abundance') { fut.data[[place.holders[i]]] <- as.vector(data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario,gcms[i],suffix[j],'/abs.change.',future.scenario,gcms[i],suffix[j],'.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='abundance',var.name=spatial.variable)[,'variable']) }
			# if (data.type=='productivity') { fut.data[,i] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/',future.scenario[1],gcms[i],future.scenario[2],'.report.productivity.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='productivity',var.name=spatial.variable) }
			# print(head(fut.data[[i]]))
			
			# print(fut.data[[i]][historical.data==0 & fut.data[[i]]>0])
			fut.data[[place.holders[i]]] <- fut.data[[place.holders[i]]][historical.data != 0 | (historical.data==0 & fut.data[[place.holders[i]]]>0)]
			# print(length(fut.data[[i]]))
			# print(fut.data[[place.holders[i]]]); stop('cbw')
			# fut.data[fut.data==0] <- NA
		}
		if (j<length(suffix)) { fut.data[[(j*6)]] <- NA	}
	}
	
	# =====================================================================================================
	# Plotting, making a figure
	# if (is.null(dev.list())) { dev.new() } # This may start giving an error for an invalid screen number.  Quit R and start over if this happens. 
	png(paste(workspace,species.folder,'/analysis/sensitive.',future.scenario[1],data.type,'.',time.window[1],'.png',sep=''), width=400, height=400)
		par(mar=c(3,6,1,1))
		boxplot(fut.data, border=brewer.pal(6,name='Set1'), col=brewer.pal(6,name='Set1'), range=0, xaxt='n', bty='n', ylab=ylab) # boxwex=0.5, 
		at.spots <- (seq(1,length(suffix),1) * 6) - 3
		axis(side=1, at=at.spots, labels=the.labels, tick=FALSE)
		abline(h=0)
		legend(leg.x,leg.y, c('CCSM3','CGCM3.1','GISS-ER','MIROC3.2','UKMO-HadCM3'), fill=brewer.pal(6,name='Set1'), border=brewer.pal(6,name='Set1'), bty='n')
	dev.off()
}

# =======================================================================================
# Function Call Townsend Squirrel
sensitive.boxplots(
	workspace='F:/pnwccva_data2/HexSim/Workspaces/',
	species.folder='town_squirrel_v1',
	baseline.scenario='squirrel.016.110.baseline', 
	future.scenario=c('squirrel.016.110.'),
	data.type='abundance',
	spatial.variable='huc',
	baseline.time='31.40',
	time.window=c('99.109','LATE-2000s'), # c('51.60','MID-2100s'), c('99.109','LATE-2100s'),
	legend.label='    populations', # '      females'
	suffix=c('','.swe','.def'),
	the.labels=c('FULL MODEL','SWE ONLY','DEFICIT ONLY'),
	leg.x=5.5, leg.y=3000, ylab='CHANGE IN # OF POPULATIONS\nRELATIVE TO BASELINE'	
	)
	
# =======================================================================================
# Function Call Spotted Frog
# sensitive.boxplots(
	# workspace='H:/HexSim/Workspaces/',
	# species.folder='spotted_frog_v2',
	# baseline.scenario='rana.lut.104.100.baseline',
	# future.scenario=c('rana.lut.104.100.'),
	# data.type='abundance',
	# spatial.variable='huc',
	# baseline.time='31.40',
	# time.window=c('51.60','MID-2000s'), # c('51.60','MID-2100s'), c('99.109','LATE-2100s'),
	# legend.label='    populations', # '      females'
	# suffix=c('','.swe','.aet'),
	# the.labels=c('FULL MODEL','SWE ONLY','AET ONLY'),
	# leg.x=6, leg.y=-1000
	# )

# # =======================================================================================
# # Function Call Lynx
# create.figure(
	# workspace='I:/HexSim/Workspaces/',
	# species.folder='lynx_v1',
	# baseline.scenario='lynx.050.baseline.35', # run .35 separately
	# future.scenario=c('lynx.050.','.35'), # run .35 separately
	# data.type='abundance', # 'productivity', # 'abundance'
	# spatial.variable='huc',
	# baseline.time='34.42',
	# time.window=c('97.105','LATE-2100s'), # c('97.105','LATE-2100s') # c('52.60','MID-2100s')
	# historical.cutoffs=c(0,5,25,200,1000),
	# future.cutoffs=c(-350,-75,-20,-5,-2,0,2,5,20,75,350)
	# )


# =======================================================================================
# Function Call Wolverine
# create.figure(
	# workspace='H:/HexSim/Workspaces/',
	# species.folder='wolverine_v1',
	# baseline.scenario='gulo.023.baseline',
	# future.scenario=c('gulo.023.a2.','.swe'), # '' '.swe' '.biomes'
	# data.type='abundance', # 'productivity', # 'abundance'
	# spatial.variable='huc',
	# baseline.time='41.50', # '41.50', # '21.50',
	# time.window=c('100.109','LATE-2100s'), # c('31.60','MID-2100s'), # c('81.109','LATE-2100s'), '100.109', '51.60'
	# historical.cutoffs=c(0,2,5,10,25,50,175), # c(-100,-25,-10,-5,-2,0,2,5,10,25,100), # c(0,5,10,25,50,75,100,150),
	# future.cutoffs=c(-125,-25,-10,-5,-2,0,2,5,10,25,125) # c(-100,-25,-10,-5,-2,0,2,5,10,25,100)
	# )
