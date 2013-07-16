
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
	subData <- as.vector(subData[grep(outcome,theData$Outcome,value=FALSE,ignore.case=TRUE),'Meters.Displaced'])
	subData <- subData / 1000
	# print(head(subData))
	
	hist(subData,freq=FALSE,breaks=breaks,xlab='distance (km)',main=paste(scenario,event,outcome,time.step,'\nmedian =',round(median(subData,na.rm=TRUE)),'max =',round(max(subData,na.rm=TRUE))))
}

# # Lynx
# run.report <- 'n'
# population <- 'lynx'
# workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1'
# scenario <- 'lynx.035c'
# breaks <- seq(0,1000,100)
# par(mfrow=c(2,2))
# events <- 'subadult' # previously c('ranges','young','subadult')
# outcomes <- list(c('start','floater')) # previously list('start','join',c('start','floater'))
# time.steps <- seq(6,15,1)

# # Wolverine
run.report <- 'y'
population <- 'wolverine'
workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/wolverine_v1'
scenario <- 'gulo.006c'
breaks <- seq(0,2000,100)
par(mfrow=c(2,2))
events <- 'annual'
outcomes <- list(c('start','floater'))
time.steps <- seq(11,15,1)

command <- paste('F:/pnwccva_data2/hexsim/currenthexsim/OutputTransformer.exe -movement ',workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')
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
