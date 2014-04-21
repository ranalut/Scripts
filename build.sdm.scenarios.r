
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
theScenarios <- c('','clim.','lulc.','veg.')
base.name <- 'rabbit.020.'
workspace <- '//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/Hexsim/Workspaces/rabbit_v1/Scenarios/'
base.scenario <- paste(workspace,'rabbit.020.all.ccsm3.xml',sep='')

base <- readLines(base.scenario)
print(base[c(61,93,162,209)])

for (i in theGCMs)
{
	for (j in theScenarios)
	{
		temp <- gsub(pattern='hab.ccsm3',replacement=paste('hab.',j,i,sep=''),x=base, ignore.case=TRUE)
		print(temp[c(61,93,162,209)])# ; stop('cbw')
		writeLines(temp, paste(workspace,'rabbit.020.hab.',i,'.',j,'.xml',sep=''))
		stop('cbw')
	}
}

