
# setwd('c:/users/cbwilsey/documents/postdoc/scripts/')
# setwd('F:/PNWCCVA_Data2/Scripts')
library(foreign)
library(raster)

simNumber <- 			'150'
repl <- 				1
runHexSim <- 			'n'
runTransformerRanges <- 'n'
runTransformerMove <- 	'n'
runTransformerBirths <- 'n'
runTransformerDeaths <- 'n'
runTransformerBD <- 	'n'
movePlot <- 			'y'
spPlot <- 				'n'
startStep <- 			2
stopStep <- 			2
n.rows <- 				1750
n.cols <- 				1859
# workspace <- 'c:/users/cbwilsey/documents/postdoc/HexSim/Workspaces/sage_grouse_v2/'
workspace <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/sage_grouse_v3/' 
# workspace <- 'H:/HexSim/Workspaces/sage_grouse_v3/' # 'F:/PNWCCVA_Data2/HexSim/Workspaces/sage_grouse_v2/'
# hexSimDir <- 'c:/users/cbwilsey/documents/postdoc/'
# hexSimDir <- 'H:/' # 'F:/PNWCCVA_Data2/'
hexSimDir <- 'D:/Data/wilsey/'
cat('scenario number',simNumber,'\n')

command <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && HexSimEngine64.exe ',workspace,'Scenarios/sagr.',simNumber,'.xml',sep='')
if (runHexSim=='y') { shell(command, translate=TRUE) }

command1 <- paste('D: && cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -ranges ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'-[',repl,']/sagr.',simNumber,'.log',sep='')
command2 <- paste('D: && cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -movement ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'-[',repl,']/sagr.',simNumber,'.log',sep='')
command3 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:b:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command4 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:d:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
command5 <- paste('cd ',hexSimDir,'HexSim/currentHexSim/ && OutputTransformer.exe -csv:n:',n.rows,':',n.cols,':true:',startStep,'-',stopStep,':True,False ',workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'.log',sep='')
if (runTransformerRanges=='y') { shell(command1, translate=TRUE) }
if (runTransformerMove=='y') { shell(command2, translate=TRUE) }
if (runTransformerBirths=='y') { shell(command3, translate=TRUE) }
if (runTransformerDeaths=='y') { shell(command4, translate=TRUE) }
if (runTransformerBD=='y') { shell(command5, translate=TRUE) }

# stop('cbw')

mgmt.zones <- read.csv(paste(workspace,'Spatial Data/mgmt.zones.step0.csv',sep=''),header=TRUE)
theRanges.orig <- read.table(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'-[',repl,']/sagr.',simNumber,'_REPORT_ranges_sage_grouse.csv',sep=''),sep=',',fill=TRUE,skip=1,stringsAsFactors=FALSE,col.names=paste('V',seq(1,1000,1),sep=''))
print('read in zones and ranges')

theRanges <- theRanges.orig[,1:9]
colnames(theRanges) <- c('Replicate','TimeStep','EventName','EventType','PopID','GroupID','GroupSize','Resources','NumberHexagons')
# print(theRanges[1:10,])
# theRanges <- data.frame(theRanges,groupZone)

theCensus <- read.csv(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'-[',repl,']/sagr.',simNumber,'.0.csv',sep=''),header=TRUE)
print('Census Numbers')
print(theCensus[,2:6])
cat('scenario number',simNumber,'\n')

theCensus2 <- read.csv(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'-[',repl,']/sagr.',simNumber,'.4.csv',sep=''),header=TRUE)
theCensus2 <- theCensus2[,(6+seq(2,8,1))] # theCensus2[,(6+seq(4,16,2))]
theCensus2 <- data.frame(seq(0,stopStep,1),theCensus2)
colnames(theCensus2) <- c('Time.Step','g.plains','wyoming','s.g.basin','snake.r','n.g.basin','columbia','colorado')
print(theCensus2)
theLambdas <- round(theCensus2[-1,-1]/theCensus2[-dim(theCensus2)[1],-1],3)
theLambdas <- data.frame(seq(1,stopStep,1),theLambdas)
colnames(theLambdas) <- c('Time.Step','g.plains','wyoming','s.g.basin','snake.r','n.g.basin','columbia','colorado')
print(theLambdas)


# par(mfrow=c(2,2))
for (i in startStep:stopStep)
{ 
	# hist(theRanges[theRanges$TimeStep==i,'GroupSize'])
	cat('No. of groups',length(theRanges[theRanges$TimeStep==i,'GroupID']),'mean individuals',mean(theRanges[theRanges$TimeStep==i,'GroupSize'],na.rm=TRUE),'max individuals',max(theRanges[theRanges$TimeStep==i,'GroupSize'],na.rm=TRUE),'\n',sep=' ')
}
cat('scenario number',simNumber,'\n')
# stop('cbw')

if (movePlot=='y') 
{
	theMove <- read.table(paste(workspace,'Results/sagr.',simNumber,'/sagr.',simNumber,'-[',repl,']/sagr.',simNumber,'_REPORT_move_sage_grouse.csv',sep=''),sep=',',fill=TRUE,skip=1,stringsAsFactors=FALSE)
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

find.grp.mgmt.zone <- function(x,mgmt.zones,time.step)
{
	it <- as.numeric(x[10])
	output <- mgmt.zones[it,2]
	# print(output); stop('cbw')
	return(output)
}

theRanges.end <- theRanges.orig[as.numeric(theRanges.orig[,2])==stopStep,]
groupZone <- as.numeric(apply(X=theRanges.end,MARGIN=1,FUN=find.grp.mgmt.zone, mgmt.zones=mgmt.zones, time.step=stopStep))
leks <- table(groupZone)
# names(leks) <- c('none','g.plains','wyoming','s.g.basin','snake.r','n.g.basin','columbia','colorado')
# cat(leks,'\n')
print(leks)
# sagebrush.area <- c(0,55697,125729,108233,157937,75851,13337,17205)
# names(sagebrush.area) <- c('none','g.plains','wyoming','s.g.basin','snake.r','n.g.basin','columbia','colorado')
# cat(sagebrush.area,'\n')

theRanges.zones <- theRanges.end[,1:9]
colnames(theRanges.zones) <- c('Replicate','TimeStep','EventName','EventType','PopID','GroupID','GroupSize','Resources','NumberHexagons')
theRanges.zones <- data.frame(theRanges.zones,smz=groupZone)
the.smz <- c('g.plains','wyoming ','s.g.basin','snake.r ','n.g.basin','columbia','colorado')

# current <- read.csv('H:/HexSim/Workspaces/sage_grouse_v3/Analysis/current.csv',header=TRUE)
current <- read.csv(paste(workspace,'Analysis/hab.v2.baseline.csv',sep=''),header=TRUE)
hab.smz <- data.frame(mgmt.zones,current[,2])
colnames(hab.smz) <- c('hex_id','zone','current')
hab.smz$current <- ifelse(hab.smz$current>=0.59,1,0)
hab.smz$count <- 1
areas <- aggregate(count~zone+current,hab.smz,sum)
areas <- areas[areas$current==1 & areas$zone>0,]
areas$km2 <- areas$count * 86.6/10000 # Per 100km2
leks.table <- data.frame(zone=as.integer(names(leks)),leks=as.integer(leks))
areas <- merge(areas,leks.table,all.x=TRUE)
areas$dens100km2 <- areas$leks/areas$km2
print(areas)

for (i in 1:7)
{ 
	cat('SMZ',the.smz[i],'groups',length(theRanges.zones[theRanges.zones$smz==i,'GroupID']),'mean indiv.',round(mean(theRanges.zones[theRanges.zones$smz==i,'GroupSize'],na.rm=TRUE),1),'max',max(theRanges.zones[theRanges.zones$smz==i,'GroupSize'],na.rm=TRUE),'\n',sep='\t')
}
cat('scenario number',simNumber,'\n')
