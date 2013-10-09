
library(maptools)
library(sp)
library(RColorBrewer)
library(fields)

extract.number <- function(x,var.name) { temp <- as.numeric(strsplit(x,split=var.name)[[1]][2]); return(temp) }

data.prep <- function(data.file, type, var.name)
{
	
	if (type=='productivity')
	{
		the.data <- read.csv(data.file,header=TRUE, stringsAsFactors=FALSE)
		the.data <- the.data[,c(1,4)]
		colnames(the.data) <- c('CBW_CODE','variable')
		return(the.data)
	}
	if (type=='abundance')
	{
		the.data <- read.csv(data.file, stringsAsFactors=FALSE, row.names=1, skip=4, header=FALSE)
		last.col <- dim(the.data)[2]
		# print(head(the.data))
		the.data$CBW_CODE <- sapply(rownames(the.data),FUN=extract.number,simplify=TRUE,var.name=var.name)
		# print(head(the.data))
		the.data <- the.data[,c(last.col,(last.col+1))]
		colnames(the.data) <- c('variable','CBW_CODE')
		# print(head(the.data))
		# print(table(the.data$variable))
		return(the.data)
	}
}

# Function to produce a plot, must be wrapped in png() and layout() functions
map.plot <- function(baseline.data, distribution.data, cutoffs, spatial.data, political, ocean, model.name, add.legend, include.axes, color.ramp, margins, label.text=NA)
{
	the.range <- range(baseline.data$variable); print(the.range)
	baseline.data$variable[baseline.data$variable < cutoffs[1]] <- cutoffs[1] + 1
	baseline.data$variable[baseline.data$variable > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
	baseline.data$variable[baseline.data$variable==0] <- NA
	
	baseline.map <- merge(spatial.data,baseline.data,all.x=FALSE)
	
	colnames(distribution.data)[1] <- 'hist.range'
	baseline.map <- merge(baseline.map,distribution.data,all.x=TRUE)
	# print(head(baseline.map@data))
	
	baseline.map@data$color <- as.character(cut(baseline.map@data$variable, breaks=cutoffs, labels=color.ramp))
	# baseline.map@data$color <- as.character(colorRampPalette(color.ramp)(baseline.map@data$variable))
	# print(head(baseline.map@data$color)); stop('cbw')
	
	par(mar=margins)
	plot(political, col=rgb(189,189,189,max=255), xlim=c(-135,-107), ylim=c(38,58), axes=include.axes, cex.axis=1.25)
	plot(baseline.map, add=TRUE, col=baseline.map@data$color, border='gray')
	plot(ocean, add=TRUE, col=rgb(166,189,219,max=255))
	if (the.range[1]<0) { plot(baseline.map[is.na(baseline.map@data$variable)==TRUE & baseline.map@data$hist.range>0,],border='white',add=TRUE) }
	plot(political, add=TRUE)
	text(x=-130,y=40,model.name,cex=1.5)
	
	if (add.legend==TRUE) 
	{ 
		# color.legend(xl,yb,xr,yt)
		image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), breaks=cutoffs, col=color.ramp, lab.breaks=cutoffs, legend.width=3, graphics.reset=TRUE, legend.args=list(text=label.text,cex=1.5,side=1,line=2.25))
		# image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), col=as.character(colorRampPalette(color.ramp)(baseline.map@data$variable)), legend.width=3, graphics.reset=TRUE, legend.args=list(text=label.text,cex=1.5,side=1,line=2.25))
		# image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), col=color.ramp, lab.breaks=cutoffs, legend.width=3, legend.args=list(text=label.text,cex=1.5,side=1,line=2.25)) # nlevel=length(color.ramp), graphics.reset=TRUE)
	}
}	

create.figure <- function(workspace, species.folder, baseline.scenario, future.scenario, spatial.variable, baseline.time, time.window, historical.cutoffs, future.cutoffs)
{
	# Spatial Data
	political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
	ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

	historical.data <- data.prep(data.file=paste(workspace,species.folder,'/Results/',baseline.scenario,'/mean.',baseline.scenario,'.',spatial.variable,'.',baseline.time,'.csv',sep=''),type='abundance',var.name=spatial.variable)
	if (spatial.variable=='huc') { huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all.hucs2.included',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE) }

	fut.data <- list()
	gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
	for (i in 1:5)
	{
		fut.data[[i]] <- data.prep(data.file=paste(workspace,species.folder,'/Results/',future.scenario,gcms[i],'/abs.change.',future.scenario,gcms[i],'.',spatial.variable,'.',time.window[1],'.csv',sep=''),type='abundance',var.name=spatial.variable)
		# print(head(fut.data[[i]]))
	}

	if (is.null(dev.list())) { dev.new() } # This may start giving an error for an invalid screen number.  Quit R and start over if this happens. 
	png(paste(workspace,species.folder,'/analysis/',future.scenario,'abs.change.',time.window[1],'.png',sep=''), width=1200, height=800)
		
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
					baseline.data=fut.data[[i]],
					distribution.data=historical.data,
					cutoffs=cutoffs,
					model.name=paste(time.window[2],c('CCSM3','CGCM3.1','GISS-ER','MIROC3.2','UKMO-\nHadCM3'),sep='\n')[i], 
					add.legend=FALSE,
					include.axes=TRUE,	
					spatial.data=huc,
					color.ramp=brewer.pal((length(cutoffs)-1),name='PRGn'),
					margins=c(3,3,0.5,0.5),
					political=political,
					ocean=ocean
					)
				close.screen(i)
			}
			else
			{
				screen(i,new=TRUE)
				map.plot(
					baseline.data=fut.data[[i]], 
					distribution.data=historical.data,
					cutoffs=cutoffs,
					model.name=paste(time.window[2],c('CCSM3','CGCM3.1','GISS-ER','MIROC3.2','UKMO-\nHadCM3'),sep='\n')[i], 
					add.legend=TRUE,
					include.axes=TRUE,	
					spatial.data=huc,
					color.ramp=brewer.pal((length(cutoffs)-1),name='PRGn'),
					margins=c(3,3,0.5,4.5),
					label.text='  delta',
					political=political,
					ocean=ocean
					)
				close.screen(i)
			}
		}
		cutoffs <- historical.cutoffs
		screen(6,new=TRUE)
		map.plot(
			baseline.data=historical.data,
			distribution.data=historical.data,
			cutoffs=cutoffs,
			model.name='BASELINE\nABUNDANCE', 
			add.legend=TRUE,
			include.axes=TRUE,	
			spatial.data=huc,
			color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
			margins=c(3,3,0.5,4.5),
			label.text='  females',
			political=political,
			ocean=ocean
			)
		close.screen(6)
	dev.off()

}

create.figure(
	workspace='H:/HexSim/Workspaces/',
	species.folder='wolverine_v1',
	baseline.scenario='gulo.023.baseline',
	future.scenario='gulo.023.a2.',
	spatial.variable='huc',
	baseline.time='41.50',
	time.window=c('100.109','LATE-2100s'), #'100.109', #'41.50'
	historical.cutoffs=c(0,5,10,25,50,75,100,150),
	future.cutoffs=c(-125,-75,-30,-15,-5,0,5,15,30,75,125)
	)
