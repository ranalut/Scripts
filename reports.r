
## For tower...
# tally <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, tally.type, start.year, stop.year)
# {
#	 command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,'-',stop.year,':true,false "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
#	 if (tally.type=='d') { command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -csv:',tally.type,':3131:2075:true:',start.year,'-',stop.year,':true,true "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
#	 }
#	 shell(command)
# }

## For Lawler-Compute...
#report2 <- function(hexsim.wksp, hexsim.wksp2, spp.folder, scenario.name, report.type, start.year, stop.year, population,trait,rep.no)
#{
#	command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -',report.type,':',start.year,':',stop.year,':"',population,'":"',trait,'" "',hexsim.wksp2,'\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[',rep.no,']\\',scenario.name,'.log"',sep='')
#	# print(command); stop('cbw')
#	shell(command)
#}

# # For Space...
# report3 <- function(hexsim.wksp2, spp.folder, scenario.name, report.type, start.year, stop.year, population,trait,rep.no)
# {
	# command <- paste('D: && cd "D:\\data\\wilsey\\hexsim\\currentHexSim" && OutputTransformer.exe -',report.type,':',start.year,':',stop.year,':"',population,'":"',trait,'" "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[',rep.no,']\\',scenario.name,'.log"',sep='')
	# # print(command); stop('cbw')
	# shell(command)
# }

# For H drive on tower...
report4 <- function(hexsim.wksp1, hexsim.wksp2, spp.folder, scenario.name, report.type, start.year, stop.year, population, trait,rep.no)
{
	startTime <- Sys.time()
	command <- paste(substr(hexsim.wksp1,1,2),' && cd "',hexsim.wksp1,'\\currentHexSim" && OutputTransformer.exe -',report.type,':',start.year,':',stop.year,':"',population,'":"',trait,'" "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[',rep.no,']\\',scenario.name,'.log"',sep='')
	# print(command); stop('cbw')
	shell(command)
	print(Sys.time()-startTime)
}


# base.sim <- 'gulo.023.a2.' # base.sim <- 'gulo.023.'
base.sim <- 'lynx.050.'
gcms <- c('baseline') # c('ccsm3','cgcm3','giss-er','hadcm3','miroc') # c('baseline')
# gcms <- 'ccsm3'
other <- c('','.35') # other <- '' # other <- c('','.biomes','.swe')

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
# years <- list(c(11,20),c(21,30),c(31,40),c(41,50),c(51,60),c(61,70),c(71,80),c(81,90),c(91,100),c(101,109)) # years <- list(c(11,20),c(21,30),c(31,40),c(41,50)) # Wolverine
# years <- list(c(16,24),c(25,33),c(34,42),c(43,51),c(52,60),c(61,69),c(70,78),c(79,87),c(88,96),c(97,105)) # Lynx
# years <- list(c(25,33),c(34,42),c(43,51),c(79,87),c(88,96),c(97,105)) # Only mid-century and end-of-century. # Lynx
years <- list(c(16,42)) # years <- list(c(25,51),c(79,105))
# stop('cbw')

for (i in scenarios)
{
	for (j in 1:5)
	{
		for (k in 1:length(years))
		{
			if (file.exists(paste('I:/HexSim/Workspaces/lynx_v1/Results/',i,'/',i,'-[',j,']/',i,'_REPORT_productivity_lynx_',years[[k]][1],'_',years[[k]][2],'_[HucID].csv',sep=''))==FALSE)
			{
				report4(
					hexsim.wksp1= 'F:\\PNWCCVA_Data2\\HexSim', # 'D:/Data/wilsey/',
					hexsim.wksp2='I:\\HexSim', # 'H:\\HexSim', # 'D:\\Data\\wilsey',
					spp.folder='lynx_v1', # 'wolverine_v1',
					scenario.name=i,
					report.type='productivity',
					start.year=years[[k]][1],
					stop.year=years[[k]][2],
					population='lynx', # 'wolverine',
					trait='HucID',
					rep.no=j
					)
				# stop('cbw')
			}
			else { print(paste('I:/HexSim/Workspaces/lynx_v1/Results/',i,'/',i,'-[',j,']/',i,'_REPORT_productivity_lynx_',years[[k]][1],'_',years[[k]][2],'_[HucID].csv',sep='')) }
			
			if (file.exists(paste('I:/HexSim/Workspaces/lynx_v1/Results/',i,'/',i,'-[',j,']/',i,'_REPORT_productivity_lynx_',years[[k]][1],'_',years[[k]][2],'_[EcoRegion].csv',sep=''))==FALSE)
			{
				report4(
					hexsim.wksp1= 'F:\\PNWCCVA_Data2\\HexSim', # 'D:/Data/wilsey/',
					hexsim.wksp2='I:\\HexSim', # ''H:\\HexSim', # 'D:\\Data\\wilsey',
					spp.folder='lynx_v1', # 'wolverine_v1',
					scenario.name=i,
					report.type='productivity',
					start.year=years[[k]][1],
					stop.year=years[[k]][2],
					population='lynx', # 'wolverine',
					trait='EcoRegion',
					rep.no=j
					)
			}
			else { print(paste('I:/HexSim/Workspaces/lynx_v1/Results/',i,'/',i,'-[',j,']/',i,'_REPORT_productivity_lynx_',years[[k]][1],'_',years[[k]][2],'_[EcoRegion].csv',sep='')) }
			
			if (file.exists(paste('I:/HexSim/Workspaces/lynx_v1/Results/',i,'/',i,'-[',j,']/',i,'_REPORT_productivity_lynx_',years[[k]][1],'_',years[[k]][2],'_[ProAreas].csv',sep=''))==FALSE)
			{
				report4(
					hexsim.wksp1= 'F:\\PNWCCVA_Data2\\HexSim', # 'D:/Data/wilsey/',
					hexsim.wksp2='I:\\HexSim', # ''H:\\HexSim', # 'D:\\Data\\wilsey',
					spp.folder='lynx_v1', # 'wolverine_v1',
					scenario.name=i,
					report.type='productivity',
					start.year=years[[k]][1],
					stop.year=years[[k]][2],
					population='lynx', # 'wolverine',
					trait='ProAreas',
					rep.no=j
					)
			}
			else { print(paste('I:/HexSim/Workspaces/lynx_v1/Results/',i,'/',i,'-[',j,']/',i,'_REPORT_productivity_lynx_',years[[k]][1],'_',years[[k]][2],'_[ProAreas].csv',sep='')) }
			# stop('cbw')
			cat(i,' rep ',j,years[[k]],'\n')
		}
	}
}
stop('cbw')


# =================================================================================================

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

