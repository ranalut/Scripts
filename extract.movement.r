
move.report <- function(in.file,outcome)
{
	theData <- read.csv(in.file,stringsAsFactors=FALSE)
	print(head(theData))
	print(unique(theData$Meters.Displaced[theData$Outcome==outcome]))
	print(unique(theData$Outcome))
	# hist(theData$Meters.Displaced[theData$Outcome==outcome])

}

move.report(in.file='F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Results/rana.lut.63/rana.lut.63-[1]/rana.lut.63_move_rana_lut.csv', outcome='      start')
