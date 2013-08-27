
library(maptools)
library(sp)
library(RColorBrewer)

workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/'
# folder <- 'lynx_v1'
# base.scenario <- 'lynx.041b'
# scenarios <- c('lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
# cutoffs <- c(-25000,-10000,-5000,-1000,-100,0,100,1000,5000,10000,25000)
folder <- 'wolverine_v1'
base.scenario <- 'gulo.017.baseline'
scenarios <- c('gulo.017.a2.ccsm3','gulo.017.a2.cgcm3','gulo.017.a2.giss-er','gulo.017.a2.miroc','gulo.017.a2.hadcm3')
cutoffs <- c(-1000,-50,-25,-10,-5,0,5,10,25,50,100)
climate <- 'a2'

# Ecoregions
eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# print(head(eco))


# Baseline

bd.data <- read.csv(paste(workspace,folder,'/Results/',base.scenario,'/',base.scenario,'-[1]/eco.BirthsDeaths.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
colnames(bd.data) <- c('ECO_ID_U','BD')
# print(head(bd.data))

eco@data <- merge(eco@data,bd.data)

# plot(eco,col=rainbow(eco@data$BD))
# spplot(eco,zcol=eco@data$BD - min(eco@data$BD))
# print(spplot(eco, zcol='BD')

png(paste(workspace,folder,'/Analysis/',base.scenario,'BirthsDeaths.png',sep=''))
	# print(spplot(eco, zcol='BD', at=do.breaks(c(-25000,25000),10), col.regions=brewer.pal(10,name='RdYlBu')))
	print(spplot(eco, zcol='BD', at=cutoffs, col.regions=brewer.pal(10,name='RdYlBu')))
dev.off()

the.plots <- list()
for (i in 1:length(scenarios))
	{
		print(i)
		eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
		bd.data <- read.csv(paste(workspace,folder,'/Results/',scenarios[i],'/',scenarios[i],'-[1]/eco.BirthsDeaths.table.csv',sep=''),header=TRUE, stringsAsFactors=FALSE)
		colnames(bd.data) <- c('ECO_ID_U','BD')
		print(range(bd.data$BD))
		eco@data <- merge(eco@data,bd.data)

		the.plots[[i]] <- spplot(eco, zcol='BD', at=cutoffs, col.regions=paste(brewer.pal(10,name='RdYlBu'),75,sep=''))
	}
png(paste(workspace,folder,'/Analysis/',climate,base.scenario,'BirthsDeaths.png',sep=''))
	for (i in 1:(length(the.plots)-1)) { print(the.plots[[i]],more=T) }
	print(the.plots[[length(the.plots)]])
dev.off()

