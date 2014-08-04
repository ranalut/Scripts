
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
theScenarios <- c('','clim.','veg.')
base.name <- 'squirrel.11.' # 'krat.05.' # 'rabbit.020.'
thresholds <- as.character(c(0.56,0.51,0.838)) # as.character(c(0.55,0.495,0.772)) # as.character(c(0.63,0.55,0.656))
workspace <- 'town_squirrel_v1' # 'krat_v1' # 'rabbit_v1'
workspace <- paste('//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/Hexsim/Workspaces/',workspace,'/Scenarios/', sep='')

base.scenario <- paste(workspace,base.name,'all.ccsm3.xml',sep='')

base <- readLines(base.scenario)
print(base[c(45,61,93,162,209)])

for (i in theGCMs)
{
	for (j in 1:3)
	{
		temp <- gsub(pattern='hab.v2.ccsm3',replacement=paste('hab.v2.',theScenarios[j],i,sep=''),x=base, ignore.case=TRUE)
		temp <- gsub(pattern='0.63',replacement=thresholds[j],x=temp, ignore.case=TRUE)
		print(temp[c(45,61,93,162,209)])# ; stop('cbw')
		writeLines(temp, paste(workspace,base.name,'hab.v2.',theScenarios[j],i,'.xml',sep=''))
		# stop('cbw')
	}
}
