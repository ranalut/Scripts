# This script is for scenarios with 7 populations.
# See 'sage.grouse.run.hexsim.v7.r' for a version that works with a single population
# setwd('c:/users/cbwilsey/documents/postdoc/scripts/')
setwd('F:/PNWCCVA_Data2/Scripts')
library(foreign)
library(raster)

simNumber <- 			'77c'
runHexSim <- 			'y'
runTransformerRanges <- 'y'
runTransformerMove <- 	'n'
runTransformerBirths <- 'y'
runTransformerDeaths <- 'y'
runTransformerBD <- 	'y'
runTransformerO <- 		'y'
movePlot <- 			'n'
spPlot <- 				'n'
startStep <- 			17
stopStep <- 			20
n.rows <- 				1750
n.cols <- 				1859
# workspace <- 'c:/users/cbwilsey/documents/postdoc/HexSim/Workspaces/sage_grouse_v2/'
workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/'
# hexSimDir <- 'c:/users/cbwilsey/documents/postdoc/'
hexSimDir <- 'F:/PNWCCVA_Data2/'
cat('scenario number',simNumber,'\n')

command <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && HexSimEngine64.exe ',workspace,'Scenarios/sagr.',simNumber,'.xml',sep='')
if (runHexSim=='y') { shell(command, translate=TRUE) }

command1 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -ranges ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command2 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -movement ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command3 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:b:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command4 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:d:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command5 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:n:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command6 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:u:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
if (runTransformerRanges=='y') { shell(command1, translate=TRUE) }
if (runTransformerMove=='y') { shell(command2, translate=TRUE) }
if (runTransformerBirths=='y') { shell(command3, translate=TRUE) }
if (runTransformerDeaths=='y') { shell(command4, translate=TRUE) }
if (runTransformerBD=='y') { shell(command5, translate=TRUE) }
if (runTransformerO=='y') { shell(command6, translate=TRUE) }
# stop('cbw')

# c('Time.Step','g.plains','wyoming','s.g.basin','snake.r','n.g.basin','columbia','colorado')

theRanges <- list()
theCensus <- list()

sink(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_output.txt',sep=''),append=TRUE)
for (i in 1:7)
{ 
	theRanges[[i]] <- read.table(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_ranges_sage_grouse',i,'.csv',sep=''),sep=',',fill=TRUE,skip=1,stringsAsFactors=FALSE,col.names=paste('V',seq(1,1000,1),sep=''))
	theRanges[[i]] <- theRanges[[i]][,1:9]
	colnames(theRanges[[i]]) <- c('Replicate','TimeStep','EventName','EventType','PopID','GroupID','GroupSize','Resources','NumberHexagons')

	theCensus[[i]] <- read.csv(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.',(i-1),'.csv',sep=''),header=TRUE)
}

cat('\n# Group Report and Census Outputs ============================================\n')
for (j in startStep:stopStep)
{	
	cat('\ntimestep',j,'\n')
	for (i in 1:7)
	{
		cat('SMZ',i,'timestep',j,'groups',length(theRanges[[i]]$GroupID[theRanges[[i]]$TimeStep==j & theRanges[[i]]$EventType=='   Movement']),'mean indiv.',round(mean(theRanges[[i]]$GroupSize[theRanges[[i]]$TimeStep==j & theRanges[[i]]$EventType=='   Movement'],na.rm=TRUE),1),'max',max(theRanges[[i]]$GroupSize[theRanges[[i]]$TimeStep==j & theRanges[[i]]$EventType=='   Movement'],na.rm=TRUE),'\n',sep='\t')
	}
	cat(c('\nsmz',colnames(theCensus[[i]][,2:6])),'\n')
	for (i in 1:7)
	{
		cat(c(i,as.numeric(theCensus[[i]][theCensus[[i]]$Time.Step==j,2:6])),'\n')
	}
}
sink()
cat('scenario number',simNumber,'\n')
# stop('cbw')

# par(mfrow=c(2,2))
# for (i in startStep:stopStep)
# { 
	# # hist(theRanges[theRanges$TimeStep==i,'GroupSize'])
	# cat('No. of groups',length(theRanges[theRanges$TimeStep==i,'GroupID']),'mean individuals',mean(theRanges[theRanges$TimeStep==i,'GroupSize'],na.rm=TRUE),'max individuals',max(theRanges[theRanges$TimeStep==i,'GroupSize'],na.rm=TRUE),'\n',sep=' ')
# }
# cat('scenario number',simNumber,'\n')

# =======================================================================================
# Movement

if (movePlot=='y') 
{
	theMove <- read.table(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_move_sage_grouse1.csv',sep=''),sep=',',fill=TRUE,skip=1,stringsAsFactors=FALSE)
	colnames(theMove) <- c('Replicate','Time.Step','Event.Name','Pop.ID','Individual.ID','IndivTraitIndex','Num.Dispersal','Hex.Dispersed','Meters.Displaced','No.Explore','Hex.Explored','Outcome')
	# print(head(theMove)); stop('cbw')
	par(mfrow=c(2,2))
	modelData <- as.vector(theMove$Meters.Displaced[(theMove$Outcome=='       join' | theMove$Outcome=='      start') & theMove$Event.Name==' Annual dispersal' & theMove$Time.Step==stopStep])
	hist(modelData, breaks=seq(0,65000,250), main='The Model - All Indiv.',xlab='meters')
	modelData <- as.vector(theMove$Meters.Displaced[theMove$Outcome=='      start' & theMove$Event.Name==' Annual dispersal' & theMove$Time.Step==stopStep])
	hist(modelData, breaks=seq(0,65000,250), main='The Model - Start.',xlab='meters')
	modelData <- as.vector(theMove$Meters.Displaced[theMove$Outcome=='       join' & theMove$Event.Name==' Annual dispersal' & theMove$Time.Step==stopStep])
	hist(modelData, breaks=seq(0,65000,250), main='The Model - Join',xlab='meters')
	# stop('cbw')
}

# =======================================================================================
# Mapping

# stop('cbw')
# Join Births, Deaths, B-Ds to hexagon grid
if (spPlot=='y')
{
	theCentroids <- read.dbf(paste(workspace,'Spatial Data/albers_centroids_1km.dbf',sep=''), as.is=TRUE)
	theCentroids <- theCentroids[,c('Hex_ID','POINT_X','POINT_Y')]

	theBirths <- read.csv(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_Births_sage_grouse_Tallies.csv',sep=''),header=TRUE)
	theDeaths <- read.csv(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_Deaths_sage_grouse_Tallies.csv',sep=''),header=TRUE)
	theBD <- read.csv(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_BirthsMinusDeaths_sage_grouse_Tallies.csv',sep=''),header=TRUE)

	theData <- data.frame(births=theBirths$Value,deaths=theDeaths$Value,bd=theBD$Value)
	# write.dbf(theHexagons, paste(workspace,'Results/albers_test3_hexagons_1km.dbf',sep=''))

	centroid.grid <- SpatialPointsDataFrame(coords=theCentroids[,c('POINT_X','POINT_Y')], proj4string=CRS('+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +ellps=clrk66 +units=m +no_defs'), data=theData)
	
	png(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'_plot.png',sep=''),pointsize=24)
	spplot(centroid.grid, zcol='deaths', col.regions=c('white','white',rep('blue',5)),cuts=c(0,0.01,10,20,30,40,50))
	# spplot(centroid.grid, zcol=c('births','deaths','bd'), col.regions=c('white','white',rep('blue',5)),cuts=c(0,0.01,10,20,30,40,50))
	dev.off()
	
	stop('cbw')
}
