
# Read a movement report and generate histograms


move <- function(workspace,scenario,event,outcome,breaks,time.step=NA)
{
	file.name <- paste(workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'_REPORT_move_lynx.csv',sep='')
	# print(file.name)
	theData <- read.csv(file.name,header=TRUE,stringsAsFactors=FALSE)
	# print(head(theData))
	
	print(unique(theData$Event.Name))
	print(unique(theData$Outcome))
	# print(grep(event,theData$Event.Name,value=FALSE,ignore.case=TRUE))
	# print(grep(outcome,theData$Outcome,value=FALSE),ignore.case=TRUE))
	
	if (is.na(time.step)==FALSE) { theData <- theData[theData$Time.Step==time.step,] }
	subData <- theData[grep(event,theData$Event.Name,value=FALSE,ignore.case=TRUE),] 
	subData <- as.vector(subData[grep(outcome,theData$Outcome,value=FALSE,ignore.case=TRUE),'Meters.Displaced'])
	subData <- subData / 1000
	# print(head(subData))
	
	hist(subData,freq=FALSE,breaks=breaks,xlab='distance (km)',main=paste(event,outcome,'\nmax =',max(subData,na.rm=TRUE)))
}

scenarios <- 'lynx.011'
par(mfrow=c(2,2))
events <- c('ranges','young','subadult')
outcomes <- list('start','join',c('start','floater'))
for (i in 3:3) # Dispersal distances for adults and young were all 1.
{
	for (j in outcomes[[i]])
	{
		move(workspace='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1',scenario=scenarios,event=events[i],outcome=j,time.step=30,breaks=seq(0,1000,50))
	}
}

