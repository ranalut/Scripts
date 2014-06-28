
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
theScenarios <- c('','clim.','veg.')
base.name <- 'sagr.136'
thresholds <- as.character(c(0.59,0.505,0.858)) # Map thresholds

workspace <- 'sage_grouse_v3'
workspace <- paste('//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/Hexsim/Workspaces/',workspace,'/Scenarios/', sep='')

base.scenario <- paste(workspace,base.name,'.xml',sep='')

base <- readLines(base.scenario)
stop('cbw')
print(base[c(
			2934,3003,3019,3035,3051,3067,3083,3099,3444 # hab.v2.initial
			2939, # 0.59
			2943,2969,3214,3437 # hab.v2.baseline (need to switch to a time series for base scenario)
			2978, # '      <attractionCoefficients>-1.00000 0.20000 0.20000 1.00000</attractionCoefficients>'
			3223 # '      <attractionCoefficients>-1.00000 0.20000 0.59000 1.00000</attractionCoefficients>'
			)])

for (i in theGCMs)
{
	for (j in 1:length(theScenarios))
	{
		# Substitute Spatial Data
		temp <- gsub(pattern='hab.ccsm3',replacement=paste('hab.v2.',theScenarios[j],i,sep=''),x=base, ignore.case=TRUE)
		# Initialization map: paste('hab.v2.',theScenarios[j],'initial',sep='')
		
		# Map threshold in Range
		# Map threshold in Movement
		temp <- gsub(pattern='0.625',replacement=thresholds[j],x=temp, ignore.case=TRUE)
		
		print(temp[c(45,61,93,162,209)])# ; stop('cbw')
		writeLines(temp, paste(workspace,base.name,'hab.v2.',theScenarios[j],i,'.xml',sep=''))
		# stop('cbw')
	}
}
