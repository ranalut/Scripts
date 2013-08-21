

# For tower...
tally <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, tally.type, start.year, stop.year)
{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,':',stop.year,':true,false "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	shell(command)
}

# For Lawler-Compute...
tally2 <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, tally.type, start.year, stop.year)
{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,':',stop.year,':true,false "',hexsim.wksp2,'\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	shell(command)
}


tally2(
	hexsim.wksp <- 'D:/Data/wilsey/',
	hexsim.wksp2 <- 'D:\\Data\\wilsey',
	spp.folder <- 'wolverine_v1',
	scenario.name <- 'gulo.017.a2.miroc',
	tally.type <- 'n',
	start.year <- 81,
	stop.year <- 110
	)
	
# tally(
	# hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
	# hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim',
	# spp.folder <- 'lynx_v1',
	# scenario.name <- i,
	# tally.type <- 'n',
	# start.year <- 81,
	# stop.year <- 108
	# )

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

