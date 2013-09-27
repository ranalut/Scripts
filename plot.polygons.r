
library(maptools)
library(sp)
library(RColorBrewer)
library(latticeExtra)

workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/'

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

# Spatial Layers
# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/lynx_wolverine_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
huc <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/all.hucs2',IDvar='CBW_CODE',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# print(head(eco))

political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

model.names <- c('CCSM3','CGCM3','GISS-ER','MIROC','HADCM3')

# Baseline

# bd.data <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/eco.BirthsDeaths',version.number,'.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
# colnames(bd.data) <- c('ECO_ID_U','BD')
bd.data <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/','gulo.019_REPORT_productivity_wolverine_31_40_[HucID].csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
# colnames(bd.data) <- c('ECO_ID_U','BD')
colnames(bd.data)[c(1,4)] <- c('CBW_CODE','BD')
bd.data$BD[bd.data$BD < cutoffs[1]] <- cutoffs[1] + 1
bd.data$BD[bd.data$BD > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
print(range(bd.data$BD))
# print(as.vector(bd.data$BD))
# print(head(bd.data))

#eco@data <- merge(eco@data,bd.data)
huc <- merge(huc,bd.data,all.x=FALSE)
# print(eco@data)
# print(huc@data)
# p1 <- spplot(eco, zcol='BD', at=cutoffs, col.regions=brewer.pal(11,name='PRGn'), xlim=c(-137,-102), ylim=c(38,58)) + layer(sp.polygons(political,alpha=0.5)) + layer(sp.polygons(ocean,fill=rgb(166,189,219,max=255))) + layer(sp.text(loc=c(-130,40),txt='HISTORICAL',cex=1.5))

p1 <- spplot(huc, zcol='BD', at=cutoffs, col.regions=brewer.pal(9,name='PRGn'), xlim=c(-137,-102), ylim=c(38,58)) + layer(sp.polygons(political,alpha=0.5)) + layer(sp.polygons(ocean,fill=rgb(166,189,219,max=255))) + layer(sp.text(loc=c(-130,40),txt='HISTORICAL',cex=1.5))
# print(p1); stop('cbw')
png(paste(workspace,folder,'/Analysis/',base.scenario,'BD_baseline.png',sep=''),width=500,height=500)
	print(p1)
dev.off()
stop('cbw')

the.plots <- list()
for (i in 1:length(scenarios))
	{
		print(i)
		# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
		eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/lynx_wolverine_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
		bd.data <- read.csv(paste(workspace,folder,'/Results/',scenarios[i],'/',scenarios[i],'-[1]/eco.BirthsDeaths',version.number,'.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
		colnames(bd.data) <- c('ECO_ID_U','BD')
		bd.data$BD[bd.data$BD < cutoffs[1]] <- cutoffs[1] + 1
		bd.data$BD[bd.data$BD > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
		print(range(bd.data$BD))
		eco@data <- merge(eco@data,bd.data)

		# the.plots[[i]] <- spplot(eco, zcol='BD', at=cutoffs, col.regions=paste(brewer.pal(10,name='PRGn'),75,sep='')) + layer(sp.polygons(political,alpha=0.5))
		the.plots[[model.names[i]]] <- spplot(eco, zcol='BD', at=cutoffs, col.regions=brewer.pal(11,name='PRGn'), xlim=c(-137,-102), ylim=c(38,58)) + layer(sp.polygons(political,alpha=0.5)) + layer(sp.polygons(ocean,fill=rgb(166,189,219,max=255))) # + layer(sp.text(loc=c(-130,40),txt=model.names[i],cex=1.5))
		png(paste(workspace,folder,'/Analysis/',scenarios[i],'.BD.png',sep=''),width=500,height=500)
			print(the.plots[[model.names[i]]])
		dev.off()

		# print(the.plots[[i]])
	}
the.plot <- c(p1,the.plots[[1]],the.plots[[2]],the.plots[[3]],the.plots[[4]],the.plots[[5]], layout=c(3,2))

png(paste(workspace,folder,'/Analysis/',base.scenario,'BirthsDeaths4.png',sep=''),width=1050,height=700)
	print(the.plot)
dev.off()

