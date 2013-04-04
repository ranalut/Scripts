
source('run.reports.r')

move.report <- function(in.file,outcome)
{
	theData <- read.csv(in.file,stringsAsFactors=FALSE)
	# print(head(theData))
	# print(unique(theData$Outcome))
	cat('meters displaced\n')
	print(table(theData$Meters.Displaced[theData$Outcome==outcome]))
	cat('hexagons explored\n')
	print(table(theData$Hexagons.Explored[theData$Outcome==outcome]))
	# hist(theData$Meters.Displaced[theData$Outcome==outcome])
}

hexsim.wksp <- 'F:/PNWCCVA_Data2/HexSim/'
hexsim.wksp2 <- 'F:\\PNWCCVA_Data2\\HexSim'
spp.folder <- 'spotted_frog_v2'
scenario.name <- 'rana.lut.66'

run.hexsim.report(
	report='-movement',
	hexsim.wksp=hexsim.wksp,
	hexsim.wksp2=hexsim.wksp2,
	spp.folder=spp.folder,
	scenario.name=scenario.name,
	)

# command <- paste(substr(hexsim.wksp2,1,2),' && cd "',hexsim.wksp2,'\\currentHexSim" && OutputTransformer.exe -movement "',hexsim.wksp2,'\\Workspaces\\',spp.folder,'\\Results\\',scenario.name,'\\',scenario.name,'-[1]\\',scenario.name,'.log"',sep='')
# shell(command)

print('start new group')
move.report(in.file=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario.name,'/',scenario.name,'-[1]/',scenario.name,'_REPORT_move_rana_lut.csv',sep=''), outcome='      start')
print('floater')
move.report(in.file=paste(hexsim.wksp,'Workspaces/',spp.folder,'/Results/',scenario.name,'/',scenario.name,'-[1]/',scenario.name,'_REPORT_move_rana_lut.csv',sep=''), outcome='    floater') # outcome='      start')
