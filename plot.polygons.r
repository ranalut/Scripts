
library(maptools)
library(sp)
library(RColorBrewer)
library(latticeExtra)

workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/'
# folder <- 'lynx_v1'
# # base.scenario <- 'lynx.041b'
# # scenarios <- c('lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
# base.scenario <- 'lynx.042'
# scenarios <- c('lynx.042.ccsm3','lynx.042.cgcm3.1','lynx.042.giss-er','lynx.042.miroc','lynx.042.hadcm3')
# cutoffs <- c(-2000,-1000,-500,-250,-100,0,100,250,500,1000,2000)

folder <- 'wolverine_v1'
base.scenario <- 'gulo.017.baseline'
scenarios <- c('gulo.017.a2.ccsm3','gulo.017.a2.cgcm3','gulo.017.a2.giss-er','gulo.017.a2.miroc','gulo.017.a2.hadcm3')
cutoffs <- c(-100,-75,-50,-25,-10,0,10,25,50,75,100)
cutoffs <- c(-150,-100,-75,-50,-25,-10,10,25,50,75,100,150)
climate <- 'a2'

# Spatial Layers
# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/lynx_wolverine_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# print(head(eco))

political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

model.names <- c('CCSM3','CGCM3','GISS-ER','MIROC','HADCM3')

# Baseline

bd.data <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/eco.BirthsDeaths.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
colnames(bd.data) <- c('ECO_ID_U','BD')

# census3 <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/',base.scenario,'.eco.csv',sep=''),header=TRUE,row.names=1)
# start.pop <- census3[11,7:dim(census3)[2]]
# # print(as.numeric(substring(colnames(start.pop),first=2)))
# start.pop <- data.frame(ECO_ID_U=as.numeric(substring(colnames(start.pop),first=2)),population=as.numeric(start.pop[1,]))
# # print(start.pop)
# # stop('cbw')

# bd.data$BD[bd.data$BD < cutoffs[1]] <- cutoffs[1] + 1
# bd.data$BD[bd.data$BD > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
print(range(bd.data$BD))
# # print(head(bd.data))

eco@data <- merge(eco@data,bd.data)
# eco@data <- merge(eco@data,start.pop)
# eco@data$bdpop <- eco@data$BD / eco@data$population
# print(range(eco@data$bdpop))
# print(eco@data)
p1 <- spplot(eco, zcol='BD', at=cutoffs, col.regions=brewer.pal(11,name='PRGn'), xlim=c(-137,-102), ylim=c(38,58)) + layer(sp.polygons(political,alpha=0.5)) + layer(sp.polygons(ocean,fill=rgb(166,189,219,max=255))) + layer(sp.text(loc=c(-130,40),txt='HISTORICAL',cex=1.5))
print(p1); stop('cbw')
png(paste(workspace,folder,'/Analysis/',base.scenario,'BD_baseline.png',sep=''),width=350,height=350)
	print(p1)
dev.off()

the.plots <- list()
for (i in 1:length(scenarios))
	{
		print(i)
		# eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
		eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/lynx_wolverine_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
		bd.data <- read.csv(paste(workspace,folder,'/Results/',scenarios[i],'/',scenarios[i],'-[1]/eco.BirthsDeaths.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
		colnames(bd.data) <- c('ECO_ID_U','BD')
		bd.data$BD[bd.data$BD < cutoffs[1]] <- cutoffs[1] + 1
		bd.data$BD[bd.data$BD > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1
		print(range(bd.data$BD))
		eco@data <- merge(eco@data,bd.data)

		# the.plots[[i]] <- spplot(eco, zcol='BD', at=cutoffs, col.regions=paste(brewer.pal(10,name='PRGn'),75,sep='')) + layer(sp.polygons(political,alpha=0.5))
		the.plots[[model.names[i]]] <- spplot(eco, zcol='BD', at=cutoffs, col.regions=brewer.pal(10,name='PRGn'), xlim=c(-137,-102), ylim=c(38,58)) + layer(sp.polygons(political,alpha=0.5)) + layer(sp.polygons(ocean,fill=rgb(166,189,219,max=255))) # + layer(sp.text(loc=c(-130,40),txt=model.names[i],cex=1.5))
		# print(the.plots[[i]])
	}
the.plot <- c(p1,the.plots[[1]],the.plots[[2]],the.plots[[3]],the.plots[[4]],the.plots[[5]], layout=c(3,2))

png(paste(workspace,folder,'/Analysis/',base.scenario,'BirthsDeaths3.png',sep=''),width=1050,height=700)
	print(the.plot)
dev.off()

