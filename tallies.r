

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
	spp.folder <- 'lynx_v1',
	scenario.name <- 'lynx.041b',
	tally.type <- 'n',
	start.year <- 10,
	stop.year <- 36
	)

# tally(
	# hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/',
	# hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim',
	# spp.folder <- 'spotted_frog_v2',
	# scenario.name <- 'rana.lut.65b3',
	# tally.type <- 'd',
	# start.year <- 14,
	# stop.year <- 14
	# )


