
library(randomForest)

source('export.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
spp.folder <- 'rabbit_v1'

map.names <- c('pyra2','all.water','ave.def.mam.ccsm3','ave.fire.ccsm3','ave.mtco.ccsm3','ave.mtwa.ccsm3','ccsm3.hist.biome','lulc.hist.a2')
time.steps <- c(rep(1,6),30,32)

for (i in 1:length(map.names))
{
	export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, spp.folder=spp.folder, hexmap.name=map.names[i],time.step=time.steps[i]) # stop('cbw')
}

# Build random forest model

the.data <- read.csv(paste(hexsim.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[1],'.csv',sep=''))
for (i in 2:length(map.names))
{
	temp <- read.csv(paste(hexsim.wksp,spp.folder,'/Analysis/',map.names[i],'.csv',sep=''),row.names=1)
	the.data <- cbind(the.data,temp)
}
colnames(the.data) <- c('hexid','pyra2','water','def.mam','fire','mtco','mtwa','biomes','lulc')
the.data <- the.data[the.data$water!=1 & the.data$def.mam!=0,]

# all.pts <- sample(the.data$hexid, size=10000)


