
library(sp)
library(lattice)
# trellis.par.set(sp.theme())
source('export.hexmaps.r')
source('load.hex.grid.r')

run.hex.grid 		<- 'n'
run.export.maps		<- 'n'


# Plot CSV function
plot.csv <- function(path.csv,hex.grid=hex.grid,column,path.png) #narrow=TRUE
{
	the.csv <- read.csv(path.csv,header=TRUE)
	# print(head(the.csv))
	plot.data <- addAttrToGeom(x=hex.grid[[2]],y=the.csv,match.ID=FALSE)
	rm(the.csv)
	print(head(plot.data)); print(unique(plot.data$Score))
	png(path.png,pointsize=12)
	trellis.par.set("background", list(col = "black"))
	print(spplot(plot.data,zcol='Score',scales=list(draw=TRUE,col='white'),col.regions=c('black','red'),auto.key=FALSE))
	# print(spplot(plot.data,zcol=column,scales=list(draw=TRUE),pretty=TRUE),checkEmptyRC=FALSE,colorkey=TRUE,regions=rainbow(2))
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

# Plot HexMap
# plot.csv(path.csv='F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Results/rana.lut.73.baseline/rana.lut.73.baseline-[1]/population/population.110.csv',hex.grid=hex.grid,column='Score')
plot.csv(path.csv='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/lynx.040.miroc/lynx.040.miroc-[2]/lynx.presence-[2]/lynx.presence.120.csv',
			path.png='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/lynx.040.miroc/lynx.040.miroc-[2]/lynx.presence-[2]/lynx.presence.120.png',
			hex.grid=hex.grid,
			column='Score'
		)

# print(spplot(it,zcol=column,scales=list(draw=TRUE),pretty=TRUE),checkEmptyRC=FALSE,colorkey=TRUE,regions=rainbow(2))