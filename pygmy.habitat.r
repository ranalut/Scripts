
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
spp.folder <- 'rabbit_v1'
ver <- 2

theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
markers.all <- letters[1:3] # c('aa','bb','cc')
scenarios.all <- c('','clim.','veg.')

for (t in 1:3)
{
	# index <- seq(1,5,1)
	markers <- rep(paste('-',markers.all[t],sep=''),7) # rep('-a',7) # rep('',7) # c(index,rep('',5),index) # rep('-b',7) 
	scenario <- scenarios.all[t] # 'clim.' # '' # 'lulc.' # 'veg.'

	# Load Model
	load(file=paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,letters[t],'.rdata',sep=''))
	
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
			
			if (scenario=='') { export.maps <- c(2:7) }
			if (scenario=='clim.') { time.steps['biomes'] <- 30; time.steps['lulc'] <- 32; time.steps['ave.fire'] <- 1; export.maps <- c(2,4:5) } # Only climate changes.
			# if (scenario=='lulc.') { time.steps['biomes'] <- 30; time.steps[c('def.mam','fire','mtco','mtwa')] <- 1; export.maps <- 7 } # Only lulc changes.
			if (scenario=='veg.') { time.steps[c('def.mam','mtco','mtwa')] <- 1; export.maps <- c(3,6,7) } # Only veg changes.
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
			
			# Predictions
			pred.spp.distn <- predict(rf.model, newdata=the.data, type='prob')

			write.csv(data.frame(hexid=the.data$hexid,Pred=pred.spp.distn[,2]),paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.model.v',ver,'.pred',markers[1],'.csv',sep=''),row.names=FALSE)
			file.remove(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[export.maps],markers[export.maps],'.csv',sep=''))
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
			
			# if (n%%2==0) { stop('cbw') }
		}
	}
}