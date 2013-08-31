
copy.tally <- function(in.dir, out.dir, hexsim.wksp,spp.folder,scenario,target)
{
	file.names <- dir(in.dir)
	the.files <- grep(target,file.names,value=TRUE)
	for (i in the.files)
	{
		# cat(paste(in.dir,i,sep=''),'\n')
		# cat(paste(out.dir,i,sep=''),'\n')
		file.copy(from=paste(in.dir,i,sep=''), to=paste(out.dir,i,sep=''), overwrite=TRUE)
	}
}

# scenario <- 'gulo.017.baseline'
# copy.tally(
		# in.dir=paste('D:/Data/wilsey/wolverine_v1/Results/',scenario,'/',scenario,'-[1]/',sep=''),
		# out.dir=paste('S:/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/wolverine_v1/Results/',scenario,'/',scenario,'-[1]/',sep=''), 
		# target='TALLY'
		# )
# stop('cbw')

wksp <- 'lynx_v1'
# scenarios <- c('lynx.041b','lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
scenarios <- c('lynx.042','lynx.042.ccsm3','lynx.042.cgcm3.1','lynx.042.giss-er','lynx.042.miroc','lynx.042.hadcm3')
# wksp <- 'wolverine_v1'
# scenarios <- c('gulo.017.baseline','gulo.017.a2.ccsm3','gulo.017.a2.cgcm3','gulo.017.a2.giss-er','gulo.017.a2.miroc','gulo.017.a2.hadcm3')

for (k in scenarios)
# for (k in 'lynx.041b')
{
	copy.tally(
		# in.dir=paste('//cfr.washington.edu/main/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/',wksp,'/Results/',k,'/',k,'-[1]/',sep=''),
		in.dir=paste('D:/Data/wilsey/',wksp,'/Results/',k,'/',k,'-[1]/',sep=''),
		# out.dir=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/',wksp,'/Results/',k,'/',k,'-[1]/',sep=''),
		out.dir=paste('S:/Space/Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/',wksp,'/Results/',k,'/',k,'-[1]/',sep=''),		
		target='eco.BirthsDeaths'
		)
}
