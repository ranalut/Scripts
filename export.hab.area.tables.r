
source('export.hexmaps.r')
source('import.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'H:/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'H:\\HexSim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'H:/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
output.wksp2 <- 'H:\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

spp.folder <- 'sage_grouse_v3' # 'town_squirrel_v1' # 'rabbit_v1' # 'krat_v1' # 'sage_grouse_v3' # 'rabbit_v1'
spp.file <- 'current' # 'town' # 'krat' # 'current' # 'pyra2'
thresholds <- c(0.59,0.505,0.858)

ver <- 2
markers <- rep('-b',3)

theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
scenarios.all <- c('','clim.','veg.')
output <- data.frame(year=NA,model=NA,gcm=NA,class=NA,km2=NA)

for (k in 1:5)
{
	index <- k
	theGCM <- theGCMs[index]
	map.names <- paste('hab.v2.',scenarios.all,theGCM,sep='')
	col.names <- c('hexid',paste(scenarios.all,theGCM,sep=''))

	time.step.adj <- rep(0,3)
	
	for (n in c(1,seq(10,110,10)))
	{
		# Settings
		time.steps <- n + time.step.adj
		names(time.steps) <- col.names[-1]
		# print(time.steps)
		print(time.steps)# ; stop('cbw')
		
		# Export Hexmaps
		for (i in 1:length(map.names))
		{
			export.hexmaps.spatial(hexsim.wksp2=hexsim.wksp2,output.wksp2=output.wksp2,spp.folder=spp.folder,hexmap.name=map.names[i],time.step=time.steps[i],marker=markers[i]) # stop('cbw')
		}
		cat('exported maps...')
		
		# Assemble data into one table
		the.data <- read.csv(paste(output.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[1],markers[1],'.csv',sep=''))
		cat(col.names[1+1],' ')
		
		for (i in 2:length(map.names))
		{
			temp <- read.csv(paste(output.wksp,'workspaces/',spp.folder,'/Analysis/',map.names[i],markers[i],'.csv',sep=''),row.names=1)
			the.data <- cbind(the.data,temp)
			cat(col.names[i+1],' ')
		}
		
		# Clean up the data
		colnames(the.data) <- col.names
		the.data <- the.data[-1,]
		cat('assembled data\n')
		
		# Summarize the areas c(year,model,gcm,class,area)
		# Full
		cells <- length(the.data[the.data[,2]>=thresholds[1],2])
		output <- rbind(output,c(n,'full',theGCM,'habitat',round(cells*86.6/100)))
		
		# Clim
		cells <- length(the.data[the.data[,3]>=thresholds[2],3])
		output <- rbind(output,c(n,'clim',theGCM,'habitat',round(cells*86.6/100)))
		
		# Veg
		cells <- length(the.data[the.data[,4]>=thresholds[3],4])
		output <- rbind(output,c(n,'veg',theGCM,'habitat',round(cells*86.6/100)))
		
		# stop('cbw')
		
		write.csv(output[-1,], paste(output.wksp,'workspaces/',spp.folder,'/analysis/rf.models.area.table.csv',sep=''))
				
		# if (n%%2==0) { stop('cbw') }
		file.remove(paste(output.wksp,'workspaces/',spp.folder,'/Analysis/',map.names,markers,'.csv',sep=''))
	}
}

