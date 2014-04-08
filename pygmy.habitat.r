
# Build habitat maps for the pygmy rabbit.

library(randomForest)

source('export.hexmaps.r')
source('import.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
spp.folder <- 'rabbit_v1'
map.names <- c('all.water','ave.def.mam.ccsm3','ave.fire.ccsm3','ave.mtco.ccsm3','ave.mtwa.ccsm3','ccsm3.hist.biome','lulc.hist.a2') # 'pyra2',
col.names <- c('hexid','water','def.mam','fire','mtco','mtwa','biomes','lulc') # 'pyra2',

time.step.adj <- c(rep(0,6),29,29)

for (n in 1:110)
{
	time.steps <- n + time.step.adj
	if (time.steps[length(time.steps)] < 32) { time.steps[length(time.steps)] <- 32 }
	
	for (i in 1:length(map.names))
	{
		export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name=map.names[i],time.step=time.steps[i]) # stop('cbw')
	}

	# Assemble data
	the.data <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[1],'.csv',sep=''))
	for (i in 2:length(map.names))
	{
		temp <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[i],'.csv',sep=''),row.names=1)
		the.data <- cbind(the.data,temp)
	}
	colnames(the.data) <- col.names
	the.data <- the.data[the.data$water!=1 & the.data$def.mam!=0,]
	the.data <- the.data[-1,]
	the.data$obs <- the.data$pyra2
	# the.data$obs[the.data$pyra2>=667] <- 1
	# the.data$obs[the.data$pyra2<667] <- 0
	# the.data$obs <- factor(the.data$obs,levels=c(0,1))
	the.data$biomes <- factor(the.data$biomes,levels=seq(0,11,1))
	the.data$lulc <- factor(the.data$lulc, levels=c(0,2,6,13,14,18))

	# Load Model
	load(file='l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.v1.rdata')
	
	pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob')

	write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]),'l:/space_lawler/shared/wilsey/postdoc/hexsim/workspaces/rabbit_v1/analysis/rf.model.pred.csv',row.names=FALSE)
	
	import.hexmaps <- function(hexsim.wksp2='F:\\PNWCCVA_Data2\\HexSim',hexsim.wksp1,spp.folder,csv.name,hexmap.name,time.step)
	
	file.copy(from=paste(hexsim.wksp1,'/Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,'/',hexmap.name,'.1.hxn',sep=''),
		to=paste(hexsim.wksp1,'/Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,'/',hexmap.name,'.',n,'.hxn',sep='')
		)
}

