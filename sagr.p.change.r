
scenario <- 'sagr.136.hab.v2b.' # 'sagr.175.hab.v2b.' # 'sagr.169.hab.v2b.' # 'sagr.136.hab.v2b.'
workspace <- "C:/Users/cwilsey/Box Sync/PNWCCVA/SAGR/" # 'h:/hexsim/workspaces/sage_grouse_v3/'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
# classes <- c('grassland','shrublands','developed')
models <- c('','clim.','veg.')
models2 <- c('full','clim','veg')
reps <- 5
years <- c(10,60,110)
smz <- c('great plains','wyoming basin','s great basin','snake river plain','n great basin','columbia basin','colorado plateau')

the.data <- read.csv(paste(workspace,'Analysis/',scenario,'all.csv',sep=''),header=TRUE, row.names=1)
sink(paste(workspace,'Analysis/p.change.txt',sep='')); sink()
for (n in 1:7)
{
	temp <- the.data[,c('model','gcm','replicate','Time.Step',paste('Trait.Index..',n,sep=''))]
	colnames(temp) <- c('model','gcm','replicate','ts','pop')
	temp <- aggregate(pop ~ model + gcm + ts, data=temp, FUN=mean)
	# sink(); print(head(temp)); stop('cbw')
	temp <- aggregate(pop ~ model + ts, data=temp, FUN=mean)
	# sink(); print(head(temp)); stop('cbw')
	temp <- temp[temp$ts %in% years,]
	start.pop <- rep(temp[1:3,'pop'],3)
	temp$change <- round((100 * (temp$pop - start.pop) / start.pop)) 
	
	sink(paste(workspace,'Analysis/p.change.txt',sep=''),append=TRUE)
		cat(smz[n],' #################################\n')
		print(temp)
	sink()
}




