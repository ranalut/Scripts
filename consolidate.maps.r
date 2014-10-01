
# Extract the hexmap data
hexsim.wksp <- 'D:/data/wilsey/HexSim/' # 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # 'D:/data/wilsey/HexSim/' # 'H:/HexSim/' # 'F:/PNWCCVA_Data2/HexSim/' # 'D:/data/wilsey/HexSim/'
hexsim.wksp2 <- 'D:\\data\\wilsey\\hexsim' # 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # 'D:\\data\\wilsey\\hexsim' # 'H:\\HexSim' # 'F:\\PNWCCVA_Data2\\HexSim' # 'D:\\data\\wilsey\\hexsim'
output.wksp <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/' # '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/'
output.wksp2 <- 'L:\\Space_Lawler\\Shared\\Wilsey\\Postdoc\\HexSim' # '\\\\cfr.washington.edu\\main\\Space\\Lawler\\Shared\\Wilsey\\PostDoc\\HexSim'

base.map <- read.csv(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',parameters[[map]][2],'.csv',sep=''))
base.map[1,2] <- 0
base.map$Step_1 <= round(base.map$Step_1)

for (p in 1:3) # Loop through 3 model types.
{
	for (k in theGCMs)
	{
		full.scenario <- paste(scenario, model.types[[1]][p],k,sep='')
		print(full.scenario)
		
		for (i in 1:reps)
		{
			for (j in 1:length(time.steps))
			{
				export.hexmaps.temp(hexsim.wksp2=hexsim.wksp2,output.wksp2=output.wksp2,spp.folder=spp.folder,scenario=full.scenario,n=i,time.step=time.steps[j],hexmap.name=map.name)

				temp <- read.csv(paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/temp.csv',sep=''),header=TRUE)
				
				temp <- data.frame(base.map[,2],temp[,2])
				colnames(temp) <- c('space','year')
				# print(head(temp))
				
				temp <- aggregate(. ~ space, data=temp, FUN=sum)
				temp[,2] <- round(temp[,2])
				# print(head(temp))
				
				v.temp <- as.vector(temp[,2])
				v.temp <- c(model.types[[2]][p],k,i,time.steps[j],v.temp)
				names(v.temp) <- c('model','gcm','rep','year',temp[,1])
				
				if (k==theGCMs[1] & i==1 & j==1)
				{
					write.csv(t(v.temp),paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',scenario, model.types[[1]][p],parameters[[map]][2],'.csv',sep=''),quote=FALSE)
				}
				else
				{
					write.table(t(v.temp),paste(output.wksp,'Workspaces/',spp.folder,'/Analysis/',scenario, model.types[[1]][p],parameters[[map]][2],'.csv',sep=''), append=TRUE,quote=FALSE,sep=',',col.names=FALSE)
				}
				# stop('cbw')	
			}
		}
	}
}





