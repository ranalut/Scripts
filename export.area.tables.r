
source('export.hexmaps.r')
source('import.hexmaps.r')

# Extract the hexmap data
hexsim.wksp <- 'H:/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'H:\\HexSim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'H:/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
output.wksp2 <- 'H:\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

data.folder <- 'rabbit_v1'
spp.folder <- 'sage_grouse_v3' # 'town_squirrel_v1' # 'rabbit_v1' # 'krat_v1' # 'sage_grouse_v3' # 'rabbit_v1'
spp.file <- 'current' # 'town' # 'krat' # 'current' # 'pyra2'
# threshold <- 1 # 27 # 33 # 1 # 667 # Minimum area requirement

ver <- 2
markers <- rep('-a',7)

theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
scenarios.all <- c('','clim.','veg.')
output <- data.frame(year=NA,model=NA,gcm=NA,class=NA,km2=NA)

for (k in 1:5)
{
	index <- k
	theGCM <- theGCMs[index]
	map.names <- c('all.water',paste('ave.def.mam.',theGCM,sep=''),paste(theGCM,'.biomes.a2',sep=''),'lulc.a2')
	col.names <- c('hexid','water','def.mam','biomes','lulc')

	time.step.adj <- c(rep(0,2),29,29)
	
	for (n in c(1,seq(10,110,10)))
	{
		# Settings
		time.steps <- n + time.step.adj
		names(time.steps) <- col.names[-1]
		# print(time.steps)
		if (time.steps['lulc'] < 32) { time.steps['lulc'] <- 32 }
		time.steps['water'] <- 1 # Water only has one hexmap.
		time.steps['def.mam'] <- 1 # Only exporting this to remove NAs
		export.maps <- c(3:4)
		print(time.steps)# ; stop('cbw')
		
		# Export Hexmaps
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
		
		# Assemble data into one table
		the.data <- read.csv(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[1],markers[1],'.csv',sep=''))
		cat(col.names[2],' ')
		
		for (i in 2:length(map.names))
		{
			temp <- read.csv(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[i],markers[i],'.csv',sep=''),row.names=1)
			the.data <- cbind(the.data,temp)
			cat(col.names[i+1],' ')
		}
		
		# Clean up the data
		colnames(the.data) <- col.names
		the.data <- the.data[the.data$water!=1 & the.data$def.mam!=0 & the.data$lulc!=0 & the.data$biomes!=0,]
		the.data <- the.data[-1,]
		cat('assembled data\n')
		
		# Summarize the areas c(year,model,gcm,class,area)
		# Grasslands
		cells <- length(the.data$biomes[the.data$biomes==8])
		output <- rbind(output,c(n,'veg',theGCM,'grassland',round(cells*86.6/100)))
		
		# Grasslands
		cells <- length(the.data$biomes[the.data$biomes==9])
		output <- rbind(output,c(n,'veg',theGCM,'shrublands',round(cells*86.6/100)))
		
		# Developed Land-uses (Urban, Ag, Mining)
		cells <- length(the.data$lulc[the.data$lulc%in%c(2,6,13,14)])
		output <- rbind(output,c(n,'lulc',theGCM,'developed',round(cells*86.6/100)))
		
		# stop('cbw')
		
		write.csv(output[-1,], paste(output.wksp,'workspaces/',spp.folder,'/analysis/veg.lulc.area.table.csv',sep=''))
				
		# if (n%%2==0) { stop('cbw') }
		file.remove(paste(output.wksp,'workspaces/',data.folder,'/Analysis/',map.names[export.maps],markers[export.maps],'.csv',sep=''))
	}
}

