
# Read a movement report and generate histograms


move <- function(workspace,scenario,event,outcome,breaks,time.step=NA)
{
	file.name <- paste(workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'_REPORT_move_lynx.csv',sep='')
	# print(file.name)
	theData <- read.csv(file.name,header=TRUE,stringsAsFactors=FALSE)
	# print(head(theData))
	
	# print(unique(theData$Event.Name))
	# print(unique(theData$Outcome))
	# print(grep(event,theData$Event.Name,value=FALSE,ignore.case=TRUE))
	# print(grep(outcome,theData$Outcome,value=FALSE),ignore.case=TRUE))
	
	if (is.na(time.step)==FALSE) { theData <- theData[theData$Time.Step==time.step,] }
	subData <- theData[grep(event,theData$Event.Name,value=FALSE,ignore.case=TRUE),] 
	subData <- as.vector(subData[grep(outcome,theData$Outcome,value=FALSE,ignore.case=TRUE),'Meters.Displaced'])
	subData <- subData / 1000
	# print(head(subData))
	
	hist(subData,freq=FALSE,breaks=breaks,xlab='distance (km)',main=paste(event,outcome))
}

par(mfrow=c(2,2))
move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario='lynx.007',event='subadult',outcome='floater',time.step=10,breaks=seq(0,1000,50))
# stop('cbw')
move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario='lynx.007',event='subadult',outcome='join',time.step=10,breaks=seq(0,1000,50))
move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario='lynx.007',event='subadult',outcome='start',time.step=10,breaks=seq(0,1000,50))

for (i in c('a','b','c'))
{
	scenario <- paste('lynx.007',i,sep='')
	par(mfrow=c(2,2))
	move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario=scenario,event='subadult',outcome='floater',time.step=15,breaks=seq(0,1000,50))
	# stop('cbw')
	move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario=scenario,event='subadult',outcome='join',time.step=15,breaks=seq(0,1000,50))
	move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario=scenario,event='subadult',outcome='start',time.step=15,breaks=seq(0,1000,50))
}

