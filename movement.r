
# Read a movement report and generate histograms


move <- function(workspace,scenario,event,outcome,breaks,time.step=NA,population)
{
	file.name <- paste(workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'_REPORT_move_',population,'.csv',sep='')
	# print(file.name)
	theData <- read.csv(file.name,header=TRUE,stringsAsFactors=FALSE)
	# print(head(theData))
	
	# print(unique(theData$Event.Name))
	# print(unique(theData$Outcome))
	# print(grep(event,theData$Event.Name,value=FALSE,ignore.case=TRUE))
	# print(grep(outcome,theData$Outcome,value=FALSE),ignore.case=TRUE))
	
	if (is.na(time.step)==FALSE) { theData <- theData[theData$Time.Step==time.step,] }
	# print(head(theData))
	subData <- theData[grep(event,theData$Event.Name,value=FALSE,ignore.case=TRUE),] 
	if (is.na(outcome)==FALSE) { subData <- subData[grep(outcome,theData$Outcome,value=FALSE,ignore.case=TRUE),] }
	subData <- as.vector(subData[,'Meters.Displaced'])
	subData <- subData / 1000
	# print(head(subData))
	
	hist(subData,freq=FALSE,breaks=breaks,xlab='distance (km)',main=paste(scenario,event,outcome,time.step,'\nmedian =',round(median(subData,na.rm=TRUE),1),'max =',round(max(subData,na.rm=TRUE)),'n =',length(subData)))
}

# SAGR
run.report <- 'y'
population <- 'sage_grouse'
# workspace <- 'H:/HexSim/Workspaces/sage_grouse_v3' # 'F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1'
workspace <- 'L:/Space_Lawler/Shared/Wilsey/PostDoc/HexSim/Workspaces/sage_grouse_v3/'
scenario <- 'sagr.150'
breaks <- seq(0,80,2)
par(mfrow=c(2,2))
events <- 'Annual dispersal' # previously c('ranges','young','subadult')
outcomes <- list(c(NA,'join','start','floater')) # list(c(NA,'start','floater')) # previously list('start','join',c('start','floater'))
time.steps <- seq(2,2,1)

# # Lynx
# run.report <- 'y'
# population <- 'lynx'
# workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1'
# scenario <- 'lynx.035f'
# breaks <- seq(0,1000,100)
# par(mfrow=c(3,3))
# events <- 'subadult' # previously c('ranges','young','subadult')
# outcomes <- list(c(NA,'start','floater')) # previously list('start','join',c('start','floater'))
# time.steps <- seq(6,15,1)

# # Wolverine
# population <- 'wolverine'
# workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/wolverine_v1'
# scenario <- 'gulo.013'
# run.report <- 'n'
# breaks <- seq(0,750,50)
# par(mfrow=c(3,3))
# events <- 'annual'
# outcomes <- list(c(NA,'start','floater'))
# time.steps <- seq(18,20,1)

# command <- paste('H:/hexsim/currenthexsim/OutputTransformer.exe -movement ',workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')
command <- paste('D: && cd D:/Data/Wilsey/HexSim/currentHexSim/ && OutputTransformer.exe -movement ',workspace,'Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')

if (run.report=='y') { shell(command) }

for (n in time.steps)
{
	for (i in 1:length(events)) # Dispersal distances for adults and young were all 1.
	{
		for (j in outcomes[[i]])
		{
			move(workspace=workspace,scenario=scenario,event=events[i],outcome=j,time.step=n,breaks=breaks,population=population)
		}
	}
}
