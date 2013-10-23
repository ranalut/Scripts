
setwd('c:/users/cbwilsey/documents/github/scripts/')
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)

source('data.prep.r')
source('map.plot.simple.r')
source('tally.agreement.r')

extract.number <- function(x,var.name) { temp <- as.numeric(strsplit(x,split=var.name)[[1]][2]); return(temp) }

create.figure.agreement <- function(workspace, species.folder, baseline.scenario, future.scenario, spatial.variable, baseline.time, time.window, cutoffs, data.type, no.change)
{
	# ================================================================================================
	# Spatial Data
	political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	study.area <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/study_area2_buffered3',IDvar='Id',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	
	if (spatial.variable=='huc') { huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all_hucs2_included_areas_km2',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE) }
	
	# ==================================================================================================
	# Plotting data

	fut.data <- list()
	gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
	for (i in 1:5)
	{
		if (data.type=='abundance') { fut.data[[i]] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/abs.change.',future.scenario[1],gcms[i],future.scenario[2],'.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='abundance',var.name=spatial.variable) }
		if (data.type=='productivity') { fut.data[[i]] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/',future.scenario[1],gcms[i],future.scenario[2],'.report.productivity.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='productivity',var.name=spatial.variable) }
		# print(dim(fut.data[[i]]))
	}
	
	agreement <- fut.data[[1]]
	for (i in 1:dim(fut.data[[1]])[1])
	{
		the.data <- NA
		for (j in 1:length(fut.data))
		{
			# print(head(fut.data[[j]]))
			the.data <- c(the.data,fut.data[[j]]$variable[i])
		}
		the.data <- the.data[-1]
		# print(the.data)
		if (sum(the.data==0)==length(gcms)) { agreement$variable[i] <- NA }
		else
		{
			the.data <- sapply(the.data,plus.or.minus, no.change=no.change)
			# print(the.data); stop('cbw')
			the.value <- tally.agreement(the.data)
			# print(the.value)
			agreement$variable[i] <- the.value
		}
	}

	# print(agreement)
	# return(agreement)
	# stop('cbw')
	
	# =====================================================================================================
	# Plotting, making a figure
	if (is.null(dev.list())) { dev.new() } # This may start giving an error for an invalid screen number.  Quit R and start over if this happens. 
	png(paste(workspace,species.folder,'/analysis/agree.',future.scenario[1],data.type,'.',time.window[1],future.scenario[2],'.png',sep=''), width=450, height=400)

		cutoffs <- cutoffs
		map.plot.simple(
			the.data=agreement,
			cutoffs=cutoffs,
			model.name=time.window[2], 
			add.legend=TRUE,
			include.axes=TRUE,	
			spatial.data=huc,
			color.ramp=brewer.pal((length(cutoffs)-1),name='PRGn'),
			margins=c(3,3,1,6),
			political=political,
			ocean=ocean,
			study.area=study.area,
			data.type=data.type,
			label.text='     # GCMs'
			)

	dev.off()
}
# =======================================================================================
# Function Call Spotted Frog
create.figure.agreement(
	workspace='H:/HexSim/Workspaces/',
	species.folder='spotted_frog_v2',
	baseline.scenario='rana.lut.104.100.baseline', # 'rana.lut.104.100.baseline'
	future.scenario=c('rana.lut.104.100.',''), # c('rana.lut.104.100.','.swe')
	data.type='abundance',
	spatial.variable='huc',
	baseline.time='31.40',
	time.window=c('99.109','LATE-2100s'), # c('51.60','MID-2100s'), c('99.109','LATE-2100s'),
	cutoffs=c(-5,-4,-3,-2,-1,0,1,2,3,4,5),
	no.change=20
	)

# =======================================================================================
# # Function Call Lynx
# create.figure.agreement(
	# workspace='I:/HexSim/Workspaces/',
	# species.folder='lynx_v1',
	# baseline.scenario='lynx.050.baseline', # run .35 separately
	# future.scenario=c('lynx.050.',''), # run .35 separately
	# data.type='abundance', # 'productivity', # 'abundance'
	# spatial.variable='huc',
	# baseline.time='34.42',
	# time.window=c('97.105','LATE-2100s'), # c('97.105','LATE-2100s') # c('52.60','MID-2100s')
	# cutoffs=c(-5,-4,-3,-2,-1,0,1,2,3,4,5),
	# no.change=5
	# )


# =======================================================================================
# Function Call Wolverine
# it <- create.figure.agreement(
	# workspace='H:/HexSim/Workspaces/',
	# species.folder='wolverine_v1',
	# baseline.scenario='gulo.023.baseline',
	# future.scenario=c('gulo.023.a2.',''), # '' '.swe' '.biomes'
	# data.type='abundance', # 'productivity', # 'abundance'
	# spatial.variable='huc',
	# baseline.time='41.50', # '41.50', # '21.50',
	# time.window=c('100.109','LATE-2100s'), # c('31.60','MID-2100s'), # c('81.109','LATE-2100s'), '100.109', '51.60'
	# cutoffs=c(-5,-4,-3,-2,-1,0,1,2,3,4,5),
	# no.change=2
	# )
