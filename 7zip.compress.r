
# Compress log files to 7zip files.

source('scenario.vector.r')

scenarios <- scenarios.vector(
					base.sim='lynx.050.', 
					gcms=c('baseline','ccsm3','cgcm3','giss-er','hadcm3','miroc'), 
					other=c('','.35')
					)

for (i in scenarios)
{				
	start.time <- Sys.time()
	command <- paste('I: && cd I:\\HexSim\\Workspaces\\lynx_v1\\Results\\ && 7z a logs.',i,'.7z -r ',i,'\\*.log -mx=5 -mmt=on -ms=off',sep='')
	# print(command); stop('cbw')

	shell(command)
	# stop('cbw')
	print(i)
	print(start.time-Sys.time())
}