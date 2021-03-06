
setwd('c:/users/cbwilsey/documents/github/scripts/')
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)

source('data.prep.r')
source('map.plot.r')
source('extract.number.r')

# extract.number <- function(x,var.name) { temp <- as.numeric(strsplit(x,split=var.name)[[1]][2]); return(temp) }

create.figure <- function(workspace, species.folder, baseline.scenario, future.scenario, spatial.variable, baseline.time, time.window, historical.cutoffs, future.cutoffs, data.type, legend.label)
{
	# ================================================================================================
	# Spatial Data
	political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	study.area <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/study_area2_buffered3',IDvar='Id',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	
	if (spatial.variable=='huc') { huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all_hucs2_included_areas_km2',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE) }
	
	# ==================================================================================================
	# Plotting data
	if (data.type=='abundance') { historical.data <- data.prep.2(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/mean.',baseline.scenario,'.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='abundance',var.name=spatial.variable, column.name='base.mean') }
	if (data.type=='productivity') { historical.data <- data.prep(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/',baseline.scenario,'.report.productivity.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='productivity',var.name=spatial.variable) }
	print(dim(historical.data))
	
	fut.data <- list()
	gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
	for (i in 1:5)
	{
		if (data.type=='abundance') { fut.data[[i]] <- data.prep.2(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/abs.change.',future.scenario[1],gcms[i],future.scenario[2],'.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='abundance',var.name=spatial.variable, column.name='rep.mean') }
		if (data.type=='productivity') { fut.data[[i]] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/',future.scenario[1],gcms[i],future.scenario[2],'.report.productivity.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='productivity',var.name=spatial.variable) }
		print(dim(fut.data[[i]]))
	}

	# =====================================================================================================
	# Plotting, making a figure
	if (is.null(dev.list())) { dev.new() } # This may start giving an error for an invalid screen number.  Quit R and start over if this happens. 
	png(paste(workspace,species.folder,'/analysis/dist.',future.scenario[1],data.type,'.',time.window[1],future.scenario[2],'.png',sep=''), width=1250, height=800)
		
		split.screen(
			figs=matrix( # L, R, B, T; Ordered upper left corner to upper right, then bottom row.
				c(0,0.31,0.5,1,
				0.31,0.62,0.5,1,
				0.62,1,0.5,1,
				0,0.31,0,0.5,
				0.31,0.62,0,0.5,
				0.62,1,0,0.5),
				ncol=4,byrow=TRUE)
				) 
		# stop('cbw')
		cutoffs <- historical.cutoffs
		for (i in 1:5)
		{
			if (i %in% c(1,2,4,5))
			{
				screen(n=i)
				map.plot(
					the.data=fut.data[[i]],
					distribution.data=historical.data,
					cutoffs=cutoffs,
					model.name=paste(time.window[2],c('CCSM3','CGCM3.1','GISS-ER','MIROC3.2','UKMO-\nHadCM3'),sep='\n')[i], 
					add.legend=FALSE,
					include.axes=TRUE,	
					spatial.data=huc,
					color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
					margins=c(3,3,0.5,0.5),
					political=political,
					ocean=ocean,
					study.area=study.area,
					data.type=data.type
					)
				close.screen(i)
			}
			else
			{
				screen(i,new=TRUE)
				map.plot(
					the.data=fut.data[[i]], 
					distribution.data=historical.data,
					cutoffs=cutoffs,
					model.name=paste(time.window[2],c('CCSM3','CGCM3.1','GISS-ER','MIROC3.2','UKMO-\nHadCM3'),sep='\n')[i], 
					add.legend=FALSE,
					include.axes=TRUE,	
					spatial.data=huc,
					color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
					margins=c(3,3,0.5,6.5),
					label.text=ifelse(data.type=='abundance','      delta','      births-\n      deaths'), 
					political=political,
					ocean=ocean,
					study.area=study.area,
					data.type=data.type
					)
				close.screen(i)
			}
		}
		cutoffs <- historical.cutoffs
		if (data.type=='abundance') { color.ramp <- brewer.pal((length(cutoffs)-1),name='YlGn') }
		else { color.ramp <- brewer.pal((length(cutoffs)-1),name='PRGn') }
		screen(6,new=TRUE)
		map.plot(
			the.data=historical.data,
			distribution.data=historical.data,
			cutoffs=cutoffs,
			model.name=ifelse(data.type=='abundance','BASELINE\nABUNDANCE','BASELINE'), 
			add.legend=ifelse(data.type=='abundance',TRUE,FALSE), 
			include.axes=TRUE,	
			spatial.data=huc,
			color.ramp=color.ramp,
			margins=c(3,3,0.5,6.5),
			label.text=legend.label,
			political=political,
			ocean=ocean,
			study.area=study.area,
			data.type=data.type
			)
		close.screen(6)
	dev.off()

}

# =======================================================================================
# Function Call Townsend Squirrel
# create.figure(
	# workspace='F:/pnwccva_data2/HexSim/Workspaces/',
	# species.folder='town_squirrel_v1',
	# baseline.scenario='squirrel.016.110.baseline', # 'rana.lut.104.100.baseline'
	# future.scenario=c('squirrel.016.110.',''), # '.swe', '.def', '.biomes'
	# data.type='abundance',
	# spatial.variable='huc',
	# baseline.time='31.40',
	# time.window=c('51.60','LATE-2000s'), # c('51.60','MID-2100s'), c('99.109','LATE-2100s'),
	# historical.cutoffs=c(0,5,20,55,150,400,1000,3000,10000),
	# future.cutoffs=c(-2000,-500,-100,-20,-5,0,5,20,100,500,2000),
	# legend.label='    populations' # '      females'
	# )

# =======================================================================================
# Function Call Spotted Frog
create.figure(
	workspace='H:/HexSim/Workspaces/',
	species.folder='spotted_frog_v2',
	baseline.scenario='rana.lut.105.125.baseline', # 'rana.lut.104.100.baseline'
	future.scenario=c('rana.lut.105.125.',''), # c('rana.lut.104.100.','.swe')
	data.type='abundance',
	spatial.variable='huc',
	baseline.time='31.40',
	time.window=c('51.60','MID-2000s'), # c('51.60','MID-2100s'), c('99.109','LATE-2100s'),
	historical.cutoffs=c(0,5,20,90,400,1800,5300),
	future.cutoffs=c(-2000,-500,-100,-20,-5,0,5,20,100,500,2000),
	legend.label='    populations' # '      females'
	)

# # =======================================================================================
# Function Call Lynx
# create.figure(
	# workspace='I:/HexSim/Workspaces/',
	# species.folder='lynx_v1',
	# baseline.scenario='lynx.050.baseline', # run .35 separately
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
	# future.scenario=c('gulo.023.a2.',''), # '' '.swe' '.biomes'
	# data.type='abundance', # 'productivity', # 'abundance'
	# spatial.variable='huc',
	# baseline.time='41.50', # '41.50', # '21.50',
	# time.window=c('51.60','MID-2100s'), # c('31.60','MID-2100s'), # c('81.109','LATE-2100s'), '100.109', '51.60'
	# historical.cutoffs=c(0,2,5,10,25,50,175), # c(-100,-25,-10,-5,-2,0,2,5,10,25,100), # c(0,5,10,25,50,75,100,150),
	# future.cutoffs=c(-125,-25,-10,-5,-2,0,2,5,10,25,125) # c(-100,-25,-10,-5,-2,0,2,5,10,25,100)
	# )
