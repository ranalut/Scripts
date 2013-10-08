
library(maptools)
library(sp)
library(RColorBrewer)
library(latticeExtra)
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
		return(the.data)
	}
}

# Function to produce a plot, must be wrapped in png() and layout() functions
map.plot <- function(baseline.data, cutoffs, spatial.data, political, ocean, model.name, legend.only, include.axes,color.ramp)
{
	baseline.data$variable[baseline.data$variable < cutoffs[1]] <- cutoffs[1] + 1
	baseline.data$variable[baseline.data$variable > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
	print(range(baseline.data$variable))

	baseline.map <- merge(spatial.data,baseline.data,all.x=FALSE)
	
	baseline.map@data$color <- as.character(cut(baseline.map@data$variable, breaks=cutoffs, labels=color.ramp))
	# print(head(baseline.map@data$color)); stop('cbw')
	
	if (legend.only==FALSE)
	{
		par(mar=c(3,3,0,0))
		plot(political, col=rgb(189,189,189,max=255), xlim=c(-135,-107), ylim=c(38,58), axes=include.axes, cex.axis=1.5)
		plot(baseline.map, add=TRUE, col=baseline.map@data$color, border='gray')
		plot(ocean, add=TRUE, col=rgb(166,189,219,max=255))
		plot(political, add=TRUE)
		text(x=-130,y=40,model.name,cex=2)
	}
	if (legend.only==TRUE) 
	{ 
		plot(political,border='white')
		image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), breaks=cutoffs,col=color.ramp, lab.breaks=cutoffs, graphics.reset=TRUE) #[-c(1,length(cutoffs))]) # nlevel=9
	}
}	

# workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/'
workspace <- 'H:/HexSim/Workspaces/'
baseline.data <- data.prep(data.file=paste(workspace,'wolverine_v1/Results/gulo.023.baseline/mean.gulo.023.baseline.huc.41.50.csv',sep=''),type='abundance',var.name='huc')
huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all.hucs2.included',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

fut.data <- list()
gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
for (i in 1:5)
{
	fut.data[[i]] <- data.prep(data.file=paste(workspace,'wolverine_v1/Results/gulo.023.a2.',gcms[i],'/abs.change.gulo.023.a2.',gcms[i],'.huc.41.50.csv',sep=''),type='abundance',var.name='huc')
	# print(head(fut.data[[i]]))
}

png('h:/hexsim/workspaces/wolverine_v1/analysis/gulo.023.a2.abs.change.41.50.png', width=1400, height=600)
	layout(matrix(c(7,1,2,3,8,7,4,5,6,8),byrow=TRUE,ncol=5), widths=c(0.3,1,1,1,0.3))

	cutoffs <- c(0,5,10,15,20,25,50,75)
	map.plot(
		baseline.data=baseline.data, 
		cutoffs=cutoffs,
		model.name='HISTORICAL', 
		legend.only=FALSE,
		include.axes=TRUE,	
		spatial.data=huc,
		color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
		political=political,
		ocean=ocean
		)
	
	cutoffs <- c(-60,-30,-20,-10,-1,1,10,20,30,60)
	for (i in 1:5)
	{
		map.plot(
			baseline.data=fut.data[[i]], 
			cutoffs=cutoffs,
			model.name=c('CCSM3','CGCM3.1','GISS-ER','MIROC','HadCM3')[i], 
			legend.only=FALSE,
			include.axes=TRUE,	
			spatial.data=huc,
			color.ramp=brewer.pal((length(cutoffs)-1),name='RdYlBu'),
			political=political,
			ocean=ocean
			)
	}
	
	cutoffs <- c(0,5,10,15,20,25,50,75)		
	map.plot(
		baseline.data=baseline.data, 
		cutoffs=cutoffs,
		model.name='HISTORICAL', 
		legend.only=TRUE,
		include.axes=FALSE,	
		spatial.data=huc,
		color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
		political=political,
		ocean=ocean
		)
		
	cutoffs <- c(-60,-30,-20,-10,-1,1,10,20,30,60)
	map.plot(
		baseline.data=baseline.data, 
		cutoffs=cutoffs,
		model.name='HISTORICAL', 
		legend.only=TRUE,
		include.axes=FALSE,	
		spatial.data=huc,
		color.ramp=brewer.pal((length(cutoffs)-1),name='RdYlBu'),
		political=political,
		ocean=ocean
		)

dev.off()
stop('cbw')

change.panel.plots(
	baseline.data=baseline.data, 
	fut.data=fut.data, 
	cutoffs=c(-75,-50,-25,-15,-5,5,15,25,50,75), 
	spatial.data=huc, 
	political=political, 
	ocean=ocean, 
	model.names=c('CCSM3','CGCM3','GISS-ER','MIROC','HADCM3'), 
	output.png='h:/hexsim/workspaces/wolverine_v1/analysis/gulo.023.a2.abs.change.41.50.png'
	)

stop('cbw')

# ==============================================
	
	the.plots <- list()
	for (i in 1:length(fut.data))
		{
			print(i)
			fut.data[[i]]$variable[fut.data[[i]]$variable < cutoffs[1]] <- cutoffs[1] + 1
			fut.data[[i]]$variable[fut.data[[i]]$variable > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
			print(range(fut.data[[i]]$variable))
			# print(as.vector(fut.data[[i]]$variable))
			# print(head(fut.data[[i]]))

			temp.map <- merge(spatial.data,fut.data[[i]],all.x=FALSE)

			# the.plots[[i]] <- spplot(eco, zcol='variable', at=cutoffs, col.regions=paste(brewer.pal(10,name='PRGn'),75,sep='')) + layer(sp.polygons(political,alpha=0.5))
			the.plots[[model.names[i]]] <- spplot(temp.map, zcol='variable', at=cutoffs, col.regions=brewer.pal(11,name='RdYlBu'), xlim=c(-137,-105), ylim=c(38,58)) + layer(sp.polygons(political,alpha=0.5)) + layer(sp.polygons(ocean,fill=rgb(166,189,219,max=255))) # + layer(sp.text(loc=c(-130,40),txt=model.names[i],cex=1.5)) 'PRGn'
			
			# png(paste(workspace,folder,'/Analysis/',scenarios[i],'.variable.png',sep=''),width=500,height=500)
				# print(the.plots[[model.names[i]]])
			# dev.off()

			# print(the.plots[[i]])
		}
	the.plot <- c(p1,the.plots[[1]],the.plots[[2]],the.plots[[3]],the.plots[[4]],the.plots[[5]], layout=c(3,2))

	png(output.png,width=1050,height=700)
		print(the.plot)
	dev.off()


	
# baseline.data <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/eco.BirthsDeaths',version.number,'.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
# colnames(baseline.data) <- c('ECO_ID_U','variable')
baseline.data <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/','gulo.019_REPORT_productivity_wolverine_31_40_[HucID].csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
# colnames(baseline.data) <- c('ECO_ID_U','variable')
colnames(baseline.data)[c(1,4)] <- c('CBW_CODE','variable')
	

# Spatial Layers
# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/lynx_wolverine_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all.hucs2',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# print(head(eco))
political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

model.names <- c('CCSM3','CGCM3','GISS-ER','MIROC','HADCM3')


folder <- 'wolverine_v1'


# The plots should all use the same function.  I need to get the data to be in the same format for both productivity (b-d) and census (absolute value or % change).






# folder <- 'lynx_v1'
# base.scenario <- 'lynx.041b'
# scenarios <- c('lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
# # base.scenario <- 'lynx.042'
# # scenarios <- c('lynx.042.ccsm3','lynx.042.cgcm3.1','lynx.042.giss-er','lynx.042.miroc','lynx.042.hadcm3')
# cutoffs <- c(-2000,-1000,-500,-250,-100,-25,25,100,250,500,1000,2000)
# version.number <- 2

folder <- 'wolverine_v1'
base.scenario <- 'gulo.019'
scenarios <- c('gulo.017.a2.ccsm3','gulo.017.a2.cgcm3','gulo.017.a2.giss-er','gulo.017.a2.miroc','gulo.017.a2.hadcm3')
cutoffs <- c(-75,-50,-25,-15,-5,5,15,25,50,75)
climate <- 'a2'
version.number <- ''



