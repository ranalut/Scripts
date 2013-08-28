

# For tower...
tally <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, tally.type, start.year, stop.year)
{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,':',stop.year,':true,false "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	if (tally.type=='d') { command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,':',stop.year,':true,true "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	}
	shell(command)
}

# For Lawler-Compute...
tally2 <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, tally.type, start.year, stop.year)
{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,':',stop.year,':true,false "',hexsim.wksp2,'\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	if (tally.type=='d') { command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,':',stop.year,':true,true "',hexsim.wksp2,'\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	}
	shell(command)
}

tally2(
	hexsim.wksp <- 'D:/Data/wilsey/',
	hexsim.wksp2 <- 'D:\\Data\\wilsey',
	spp.folder <- 'lynx_v1',
	scenario.name <- 'lynx.041b2.hadcm3',
	tally.type <- 'b',
	start.year <- 87,
	stop.year <- 105
	)
cat('done b\n')
tally2(
	hexsim.wksp <- 'D:/Data/wilsey/',
	hexsim.wksp2 <- 'D:\\Data\\wilsey',
	spp.folder <- 'lynx_v1',
	scenario.name <- 'lynx.041b2.hadcm3',
	tally.type <- 'd',
	start.year <- 88,
	stop.year <- 106
	)
cat('done d\n')
tally2(
	hexsim.wksp <- 'D:/Data/wilsey/',
	hexsim.wksp2 <- 'D:\\Data\\wilsey',
	spp.folder <- 'lynx_v1',
	scenario.name <- 'lynx.042.hadcm3',
	tally.type <- 'b',
	start.year <- 87,
	stop.year <- 105
	)
cat('done b\n')
tally2(
	hexsim.wksp <- 'D:/Data/wilsey/',
	hexsim.wksp2 <- 'D:\\Data\\wilsey',
	spp.folder <- 'lynx_v1',
	scenario.name <- 'lynx.042.hadcm3',
	tally.type <- 'd',
	start.year <- 88,
	stop.year <- 106
	)
cat('done d\n')

# tally(
	# hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
	# hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim',
	# spp.folder <- 'lynx_v1',
	# scenario.name <- 'lynx.041b',
	# tally.type <- 'b',
	# start.year <- 10,
	# stop.year <- 36
	# )
# cat(Sys.time(),'done b\n')
# tally(
	# hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
	# hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim',
	# spp.folder <- 'lynx_v1',
	# scenario.name <- 'lynx.041b',
	# tally.type <- 'd',
	# start.year <- 10,
	# stop.year <- 36
	# )
# cat(Sys.time(),'done d\n')


scenarios <- c('lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
	
for (i in scenarios)
{
	tally(
		hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
		hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim',
		spp.folder <- 'lynx_v1',
		scenario.name <- i,
		tally.type <- 'n',
		start.year <- 81,
		stop.year <- 108
		)
	print(i)
}

