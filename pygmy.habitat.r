
# Build habitat maps for the pygmy rabbit.

library(randomForest)

source('export.hexmaps.r')
source('import.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
spp.folder <- 'rabbit_v1'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')

index <- 1
theGCM <- theGCMs[index]
map.names <- c('all.water',paste(c('ave.def.mam.','ave.fire.','ave.mtco.','ave.mtwa.'),theGCM,sep=''),paste(theGCM,'.biomes.a2',sep=''),'lulc.hist.a2') # 'pyra2',
col.names <- c('hexid','water','def.mam','fire','mtco','mtwa','biomes','lulc') # 'pyra2',

time.step.adj <- c(rep(0,5),29,29)
markers <- c(index,rep('',5),index)

# dir.create(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/temp.',theGCM,'/',sep=''))

for (n in c(seq(1,110,1),1))
{
	time.steps <- n + time.step.adj
	if (time.steps[length(time.steps)] < 32) { time.steps[length(time.steps)] <- 32 }
	time.steps[1] <- 1 # Water only has one hexmap.
	print(time.steps)
	
	for (i in 1:length(map.names))
	{
		export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name=map.names[i],time.step=time.steps[i],marker=markers[i]) # stop('cbw')
	}
	cat('exported maps...')
	
	# Assemble data
	the.data <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[1],markers[1],'.csv',sep=''))
	for (i in 2:length(map.names))
	{
		temp <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[i],markers[i],'.csv',sep=''),row.names=1)
		the.data <- cbind(the.data,temp)
	}
	file.remove(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names,markers,'.csv',sep=''))
	
	colnames(the.data) <- col.names
	the.data <- the.data[the.data$water!=1 & the.data$def.mam!=0,]
	the.data <- the.data[-1,]
	the.data$obs <- the.data$pyra2
	# the.data$obs[the.data$pyra2>=667] <- 1
	# the.data$obs[the.data$pyra2<667] <- 0
	# the.data$obs <- factor(the.data$obs,levels=c(0,1))
	the.data$biomes <- factor(the.data$biomes,levels=seq(0,11,1))
	the.data$lulc <- factor(the.data$lulc, levels=c(0,2,6,13,14,18))
	cat('assembled data...')
	
	# Load Model
	load(file='l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.v1.rdata')
	
	pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob',progress='window')

	write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]),'l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.pred.csv',row.names=FALSE)
	cat('completed prediction\n')
	
	hexmap.name <- paste('hab.',theGCM,sep='')
	import.hexmaps(hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, csv.name='rf.model.pred', hexmap.name=paste('temp.', hexmap.name, sep=''))
	
	dir.create(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,'/',sep=''))
	file.copy(
		from=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/temp.',hexmap.name,'/temp.',hexmap.name,'.1.hxn',sep=''),
		to=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,'/',hexmap.name,'.',n,'.hxn',sep='')
		)
	cat('hexmap imported\n')
	
	file.remove(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/temp.',hexmap.name,'/temp.',hexmap.name,'.1.hxn',sep=''))
	# unlink(paste(hexsim.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/temp.',hexmap.name,'/',sep=''))
	
	# if (n%%2==0) { stop('cbw') }
}

