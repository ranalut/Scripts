
library(maptools)
library(sp)
library(RColorBrewer)

# temp <- read.dbf('H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions/mostly_in_study_grid_ecoregions.dbf',as.is=TRUE)

eco <- readShapePoly(fn='H:/SpatialData/SpatialData/tnc-terr-ecoregions121409/mostly_in_study_grid_ecoregions',IDvar='ECO_ID_U',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
# print(head(eco))

bd.data <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/lynx.041b/lynx.041b-[1]/eco.BirthsDeaths.table.csv',header=TRUE, stringsAsFactors=FALSE)
colnames(bd.data) <- c('ECO_ID_U','BD')
# print(head(bd.data))

eco@data <- merge(eco@data,bd.data)

make.colors <- function(x, min.value, max.value)
{
	# print(x)
	if (x >= 0)
	{
		output <- rgb(44,123,182,alpha=(x/max.value),max=255)
	}
	else
	{
		output <- rgb(215,25,28,alpha=(x/min.value),max=255)
	}
	# print(output)
	return(output)
}

# mycolors <- as.vector(sapply(X=bd.data$BD, FUN=make.colors, min.value=-10000, max.value=10000))
mycolors <- rgb(red=c(215,253,255,171,44), green=c(25,174,255,217,123), blue=c(28,97,191,233,182), alpha=0.5, max=255)

# plot(eco,col=rainbow(eco@data$BD))
# spplot(eco,zcol=eco@data$BD - min(eco@data$BD))
# print(spplot(eco, zcol='BD')
# print(spplot(eco, zcol='BD', at=do.breaks(c(-10000,10000),10), col.regions=paste(brewer.pal(10,name='RdYlBu'),50,sep='')))

p1 <- spplot(eco, zcol='BD', at=do.breaks(c(-10000,10000),10), col.regions=paste(brewer.pal(10,name='RdYlBu'),50,sep=''))
p2 <- spplot(eco, zcol='BD', at=do.breaks(c(-10000,10000),10), col.regions=paste(brewer.pal(10,name='RdYlBu'),50,sep=''))

print(p1,more=T)
print(p2)

