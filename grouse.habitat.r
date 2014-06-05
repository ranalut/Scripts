
# Build habitat maps for the pygmy rabbit.
library(randomForest)

source('export.hexmaps.r')
source('import.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/'
hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'H:/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
output.wksp2 <- 'H:\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

data.folder <- 'rabbit_v1'
spp.folder <- 'sage_grouse_v3'
ver <- 2
markers <- rep('-c',7)

theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
scenarios.all <- c('','clim.','veg.')

for (k in 1:5)
{
	index <- k
	theGCM <- theGCMs[index]
	map.names <- c('all.water',paste(c('ave.def.mam.','ave.fire.','ave.mtco.','ave.mtwa.'),theGCM,sep=''),paste(theGCM,'.biomes.a2',sep=''),'lulc.a2') # 'pyra2',
	col.names <- c('hexid','water','def.mam','fire','mtco','mtwa','biomes','lulc') # 'pyra2',

	time.step.adj <- c(rep(0,5),29,29)

	for (n in c(seq(1,110,1),1))
	{
		time.steps <- n + time.step.adj
		names(time.steps) <- col.names[-1]
		# print(time.steps)
		if (time.steps['lulc'] < 32) { time.steps['lulc'] <- 32 }
		time.steps['water'] <- 1 # Water only has one hexmap.
		export.maps <- c(2:7)
		print(time.steps)# ; stop('cbw')
		
		if (n==1)
		{
			for (i in 1:length(map.names))
			{
				export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2,output.wksp2=output.wksp2,spp.folder=data.folder,hexmap.name=map.names[i],time.step=time.steps[i],marker=markers[i]) # stop('cbw')
			}
		}
		else
		{
		   for (i in export.maps)
			{
				export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2,output.wksp2=output.wksp2,spp.folder=data.folder, hexmap.name=map.names[i],time.step=time.steps[i],marker=markers[i]) # stop('cbw')
			}
		}
		cat('exported maps...')
		
		# Assemble data
		the.data <- read.csv(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[1],markers[1],'.csv',sep=''))
		cat(col.names[2],' ')
		
		for (i in 2:length(map.names))
		{
			temp <- read.csv(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[i],markers[i],'.csv',sep=''),row.names=1)
			the.data <- cbind(the.data,temp)
			cat(col.names[i+1],' ')
		}
		
		colnames(the.data) <- col.names
		the.data <- the.data[the.data$water!=1 & the.data$def.mam!=0 & the.data$lulc!=0 & the.data$biomes!=0,]
		the.data <- the.data[-1,]
		# the.data$obs <- the.data$pyra2
		the.data$biomes <- factor(the.data$biomes,levels=seq(0,11,1))
		the.data$lulc <- factor(the.data$lulc, levels=c(0,2,6,13,14,18))
		cat('assembled data\n')
		
		for (t in 1:3)
		{
			scenario <- scenarios.all[t] # 'clim.' # '' # 'lulc.' # 'veg.'

			# Load Model
			load(file=paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,letters[t],'.rdata',sep=''))
			print(rf.model$call)
					
			# Predictions
			pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob')

			write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]),paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,'.pred',markers[1],'.csv',sep=''),row.names=FALSE)
			
			cat('completed prediction\n')
			
			# Build Hexmaps
			hexmap.name <- paste('hab.v',ver,'.',scenario,theGCM,sep='')
			cat(hexmap.name,'\n')
			import.hexmaps(hexsim.wksp2=hexsim.wksp2, output.wksp2=output.wksp2, spp.folder=spp.folder, csv.name=paste('rf.model.v',ver,'.pred',markers[1],sep=''), hexmap.name=paste('temp.', hexmap.name, sep=''))
			
			dir.create(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,'/',sep=''))
			file.copy(
				from=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/temp.',hexmap.name,'/temp.',hexmap.name,'.1.hxn',sep=''),
				to=paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/',hexmap.name,'/',hexmap.name,'.',n,'.hxn',sep=''),overwrite=TRUE
				)
			cat('hexmap imported\n')
			
			file.remove(paste(output.wksp,'Workspaces/',spp.folder,'/Spatial Data/Hexagons/temp.',hexmap.name,'/temp.',hexmap.name,'.1.hxn',sep=''))
		}
		
		# if (n%%2==0) { stop('cbw') }
		file.remove(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[export.maps],markers[export.maps],'.csv',sep=''))
	}
}
