

source('export.hexmaps.r')


# Extract the hexmap data
hexsim.wksp <- 'D:/data/wilsey/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'D:\\data\\wilsey\\hexsim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
output.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

spp.folder <- 'rabbit_v1' # 'woodpecker_v1' # 'nutcracker_v1' 
map.name <- 'distribution'
scenario <- 'rabbit.020.hab.v2.'
theGCMs <- c('ccsm3','cgcm3','giss-er','miroc','hadcm3')
model.types <- list(c('','.clim','.veg'),c('full','clim','veg'))
reps <- 25
# parameters <- list(list(1,'eco','ECO_ID_U',c(17026:17097)), list(2,'huc','PNWCCVA_ID',c(1:1549)), list(3,'pa','OBJECTID', c(1:1252)))

time.steps <- seq(10,110,10)

for (i in 1:reps)
{
	for (j in 1:length(time.steps))
	{
		# export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2, output.wksp2=output.wksp2, spp.folder=spp.folder, hexmap.name=map.name,time.step=time.steps[i]) # stop('cbw')

		export.hexmaps <- function(hexsim.wksp2=hexsim.wksp2,spp.folder=spp.folder,scenario=scenario,n=i,hexmap.name=map.name)

		
		
		
		
	}
}






