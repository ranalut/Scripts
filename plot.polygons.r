
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)

source('data.prep.r')
source('map.plot.r')

extract.number <- function(x,var.name) { temp <- as.numeric(strsplit(x,split=var.name)[[1]][2]); return(temp) }

create.figure <- function(workspace, species.folder, baseline.scenario, future.scenario, spatial.variable, baseline.time, time.window, historical.cutoffs, future.cutoffs, data.type)
{
	# ================================================================================================
	# Spatial Data
	political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	study.area <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/study_area2_buffered3',IDvar='Id',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	
	if (spatial.variable=='huc') { huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all_hucs2_included_areas_km2',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE) }
	
	# ==================================================================================================
	# Plotting data
	if (data.type=='abundance') { historical.data <- data.prep(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/mean.',baseline.scenario,'.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='abundance',var.name=spatial.variable) }
	if (data.type=='productivity') { historical.data <- data.prep(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/',baseline.scenario,'.report.productivity.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='productivity',var.name=spatial.variable) }
	print(dim(historical.data))
	
	fut.data <- list()
	gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
	for (i in 1:5)
	{
		if (data.type=='abundance') { fut.data[[i]] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/abs.change.',future.scenario[1],gcms[i],future.scenario[2],'.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='abundance',var.name=spatial.variable) }
		if (data.type=='productivity') { fut.data[[i]] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario[1],gcms[i],future.scenario[2],'/',future.scenario[1],gcms[i],future.scenario[2],'.report.productivity.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='productivity',var.name=spatial.variable) }
		print(dim(fut.data[[i]]))
	}

	# =====================================================================================================
	# Plotting, making a figure
	if (is.null(dev.list())) { dev.new() } # This may start giving an error for an invalid screen number.  Quit R and start over if this happens. 
	png(paste(workspace,species.folder,'/analysis/',future.scenario[1],data.type,'.',time.window[1],future.scenario[2],'.png',sep=''), width=1200, height=800)
		
		split.screen(
			figs=matrix( # L, R, B, T; Ordered upper left corner to upper right, then bottom row.
				c(0,0.32,0.5,1,
				0.32,0.64,0.5,1,
				0.64,1,0.5,1,
				0,0.32,0,0.5,
				0.32,0.64,0,0.5,
				0.64,1,0,0.5),
				ncol=4,byrow=TRUE)
				) 
		# stop('cbw')
		cutoffs <- future.cutoffs
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
					color.ramp=brewer.pal((length(cutoffs)-1),name='PRGn'),
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
					add.legend=TRUE,
					include.axes=TRUE,	
					spatial.data=huc,
					color.ramp=brewer.pal((length(cutoffs)-1),name='PRGn'),
					margins=c(3,3,0.5,4.5),
					label.text='  births-\n  deaths', # '  delta',
					political=political,
					ocean=ocean,
					study.area=study.area,
					data.type=data.type
					)
				close.screen(i)
			}
		}
		cutoffs <- historical.cutoffs
		screen(6,new=TRUE)
		map.plot(
			the.data=historical.data,
			distribution.data=historical.data,
			cutoffs=cutoffs,
			model.name='BASELINE', # 'BASELINE\nABUNDANCE', 
			add.legend=FALSE, # TRUE,
			include.axes=TRUE,	
			spatial.data=huc,
			color.ramp=brewer.pal((length(cutoffs)-1),name='PRGn'), # brewer.pal((length(cutoffs)-1),name='YlGn'),
			margins=c(3,3,0.5,4.5),
			label.text='  females',
			political=political,
			ocean=ocean,
			study.area=study.area,
			data.type=data.type
			)
		close.screen(6)
	dev.off()

}

# =======================================================================================
# Function Call
create.figure(
	workspace='H:/HexSim/Workspaces/',
	species.folder='wolverine_v1',
	baseline.scenario='gulo.023.baseline',
	future.scenario=c('gulo.023.a2.',''), # '' '.swe' '.biomes'
	data.type='productivity', # 'abundance'
	spatial.variable='huc',
	baseline.time='21.50',
	time.window=c('81.109','LATE-2100s'), # c('100.109','LATE-2100s'), #'100.109', #'41.50'
	historical.cutoffs=c(-1,-0.5,-0.25,-0.10,-0.05,0.05,0.10,0.25,0.5,1), # c(-75,-50,-30,-15,-5,5,15,30,50,75), # c(0,5,10,25,50,75,100,150),
	future.cutoffs=c(-1,-0.5,-0.25,-0.10,-0.05,0.05,0.10,0.25,0.5,1) # c(-75,-50,-30,-15,-5,5,15,30,50,75) # c(-125,-75,-30,-15,-5,0,5,15,30,75,125)
	)
