
library(sp)
library(lattice)
# trellis.par.set(sp.theme())
source('export.hexmaps.r')
source('load.hex.grid.r')

run.hex.grid 		<- 'n'
run.export.maps		<- 'n'


# Plot CSV function
plot.csv <- function(path.csv,hex.grid=hex.grid,column,path.png, cutoffs, color.ramp, political, ocean, study.area, margins, null.value,add.legend, label.text) #narrow=TRUE
{
	the.csv <- read.csv(path.csv,header=TRUE)
	# print(head(the.csv))
	the.map <- addAttrToGeom(x=hex.grid[[2]],y=the.csv,match.ID=FALSE)
	rm(the.csv)
	the.map$Score[the.map$Score==null.value] <- NA
	the.map <- the.map[is.na(the.map$Score)==FALSE,]
	print(head(the.map)); print(unique(the.map$Score))
	
	png(path.png,width=450,height=400,pointsize=12)
		# trellis.par.set("background", list(col = "black"))
		# print(spplot(plot.data,zcol='Score',scales=list(draw=TRUE,col='white'),col.regions=c('black','red'),auto.key=FALSE))
		# print(spplot(plot.data,zcol=column,scales=list(draw=TRUE),pretty=TRUE),checkEmptyRC=FALSE,colorkey=TRUE,regions=rainbow(2))
		
		the.map@data$color <- rep(NA,length(the.map@data$Score))
		the.map@data$color[the.map@data$Score<0] <- as.character(cut(the.map@data$Score[the.map@data$Score<0], right=FALSE, breaks=cutoffs, labels=color.ramp))
		the.map@data$color[the.map@data$Score>0] <- as.character(cut(the.map@data$Score[the.map@data$Score>0], right=TRUE, breaks=cutoffs, labels=color.ramp))
			
		par(mar=margins)
		plot(political, col=rgb(189,189,189,max=255), xlim=c(-135,-107), ylim=c(38,58), axes=TRUE, cex.axis=1.25)
		plot(the.map, add=TRUE, col=the.map@data$color, border='gray')
		plot(ocean, add=TRUE, col=rgb(166,189,219,max=255))
		# if (the.range1[1]<0 & data.type=='abundance') { plot(the.map[is.na(the.map@data$Score)==TRUE & the.map@data$hist.range>0,],border='white',add=TRUE) }
		# plot(the.zeros,border='white',add=TRUE)
		plot(study.area,add=TRUE, border='red')
		plot(political, add=TRUE)
		# text(x=-130,y=40,model.name,cex=1.5)
		if (add.legend==TRUE) 
		{
			image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), breaks=cutoffs, col=color.ramp, lab.breaks=cutoffs, legend.width=2, graphics.reset=TRUE, legend.args=list(text=label.text,cex=1.5,side=1,line=2))
		}
	dev.off()
	# return(plot.data)
}

# Load HexGrid
if (run.hex.grid=='y')
{
	hex.grid <- load.hex.grid(
		centroid.file='F:/PNWCCVA_Data2/HexSim/Workspaces/centroids84.txt', #'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/centroids84.txt',  
		file.format='txt',
		proj4='+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'
		)
}

# Export Hexmaps
if (run.export.maps=='y')
{
# export.hexmaps(spp.folder='spotted_frog_v2',scenario='rana.lut.73.baseline',hexmap.name='population',time.step=110)
export.hexmaps(spp.folder='lynx_v1',scenario='lynx.040.miroc',hexmap.name='lynx.presence',n=2,time.step=120)
}

# ================================================================================================
# Spatial Data
political <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_study_area',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
ocean <- readShapePoly(fn='H:/SpatialData/SpatialData/bound0m_shp.tar/bound0m_shp/bound_p_wgs84_ocean',IDvar='BOUND_P_',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)
study.area <- readShapePoly(fn='H:/SpatialData/SpatialData/HUCs/study_area2_buffered3',IDvar='Id',proj4string=CRS('+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0'),verbose=TRUE)

# Plot HexMap
# cutoffs <- seq(0,-0.02,-0.0025)
# plot.csv(path.csv='H:/HexSim/Workspaces/spotted_frog_v2/Analysis/m.aet.jja.csv',
			# path.png='H:/HexSim/Workspaces/spotted_frog_v2/Analysis/m.aet.jja.png',
			# hex.grid=hex.grid,
			# column='Score',
			# cutoffs=cutoffs,
			# null.value=-0.5,
			# color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
			# margins=c(3,3,1,7),
			# add.legend=TRUE,
			# label.text='      slope',
			# political=political, ocean=ocean, study.area=study.area
		# )
# Plot HexMap
cutoffs <- seq(0,0.03,0.005)
plot.csv(path.csv='H:/HexSim/Workspaces/spotted_frog_v2/Analysis/m.aet.mam.csv',
			path.png='H:/HexSim/Workspaces/spotted_frog_v2/Analysis/m.aet.mam.png',
			hex.grid=hex.grid,
			column='Score',
			cutoffs=cutoffs,
			null.value=0.5,
			color.ramp=brewer.pal((length(cutoffs)-1),name='YlGn'),
			margins=c(3,3,1,7),
			add.legend=TRUE,
			label.text='      slope',
			political=political, ocean=ocean, study.area=study.area
		)
# print(spplot(it,zcol=column,scales=list(draw=TRUE),pretty=TRUE),checkEmptyRC=FALSE,colorkey=TRUE,regions=rainbow(2))