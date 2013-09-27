

# # For tower...
# tally <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, tally.type, start.year, stop.year)
# {
	# command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,'-',stop.year,':true,false "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	# if (tally.type=='d') { command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,'-',stop.year,':true,true "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
	# }
	# shell(command)
# }

# For Lawler-Compute...
report2 <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, report.type, start.year, stop.year, population,trait,rep.no)
{
	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -',report.type,':',start.year,':',stop.year,':"',population,'":"',trait,'" "',hexsim.wksp2,'\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[',rep.no,']\\',scenario.name,'.log"',sep='')
	# print(command); stop('cbw')
	shell(command)
}


# scenarios <- c('lynx.041b.ccsm3','lynx.041b.cgcm3','lynx.041b2.giss-er','lynx.041b.miroc','lynx.041b2.hadcm3')
base.sim <- 'gulo.023.a2.'
gcms <- c('ccsm3','cgcm3','giss-er','hadcm3','miroc')
other <- c('','.biomes','.swe')
scenarios <- NA
for (i in gcms)
{
	for (j in other)
	{
		scenarios <- c(scenarios, paste(base.sim,i,j,sep=''))
	}
}
scenarios <- scenarios[-1]
print(scenarios)
# stop('cbw')

for (i in scenarios)
{
	for (j in 1:3)
	{
	report2(
		hexsim.wksp='D:/Data/wilsey/',
		hexsim.wksp2='D:\\Data\\wilsey',
		spp.folder='wolverine_v1',
		scenario.name=i,
		report.type='productivity',
		start.year=45,
		stop.year=74,
		population='wolverine',
		trait='HucID',
		rep.no=j
		)
	# stop('cbw')
	report2(
		hexsim.wksp='D:/Data/wilsey/',
		hexsim.wksp2='D:\\Data\\wilsey',
		spp.folder='wolverine_v1',
		scenario.name=i,
		report.type='productivity',
		start.year=74,
		stop.year=109,
		population='wolverine',
		trait='HucID',
		rep.no=j
		)
	cat(i,' rep ',j,'\n')
	}
}

