
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
theScenarios <- c('','clim.','veg.')
workspace <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/sage_grouse_v3/'
spin_up <- 5 # Add 5 yrs

for (i in theScenarios)
{
	for (j in theGCMs)
	{
		dir.create(paste(workspace,'Spatial Data/Hexagons/hab.v2b.',i,j,'/',sep=''),recursive=TRUE)
		
		for (k in seq(110,2,-1))
		{
			# Add yrs
			file.copy(
				from=paste(workspace,'Spatial Data/Hexagons/hab.v2.',i,j,'/hab.v2.',i,j,'.',k,'.hxn',sep=''),
				to=paste(workspace,'Spatial Data/Hexagons/hab.v2b.',i,j,'/hab.v2b.',i,j,'.',(k+spin_up),'.hxn',sep=''),
				overwrite=TRUE
				)
			# stop('cbw')
		}
		k <- 1
		file.copy(
				from=paste(workspace,'Spatial Data/Hexagons/hab.v2.',i,j,'/hab.v2.',i,j,'.',k,'.hxn',sep=''),
				to=paste(workspace,'Spatial Data/Hexagons/hab.v2b.',i,j,'/hab.v2b.',i,j,'.',k,'.hxn',sep=''),
				overwrite=TRUE
				)
	# stop('cbw')
	cat(i,j,'\n',sep=' ')
	}
}
