
workspace <- 'C:/Users/cbwilsey/Documents/PostDoc/'
hexsimWorkspace <- 'sage_grouse_v2'
setwd(paste(workspace,'Scripts/',sep=''))


deficit <- read.csv(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/deficit.step0.csv',sep=''),header=TRUE)
print(head(deficit))
smz <- read.csv(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/mgmt.zones.step0.csv',sep=''),header=TRUE)
print(head(smz))
sage <- read.csv(paste(workspace,'HexSim/Workspaces/',hexsimWorkspace,'/Spatial Data/lf.sage.step0.csv',sep=''),header=TRUE)

theTable <- data.frame(deficit,smz$extract.vector,sage$extractedData)
colnames(theTable) <- c('hex','deficit','smz','sage')

theTable2 <- theTable[theTable$sage==1,]

boxplot(theTable2$deficit~theTable2$smz)


