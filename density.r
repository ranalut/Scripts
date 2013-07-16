

# Estimating densities from .csv census files.

density.est <- function(census,trait.col=list(),areas,time.step)
{
	theData <- read.csv(census,header=TRUE)
	output <- NA
	
	for (i in 1:length(trait.col))
	{
		temp <- as.vector(theData[theData$Time.Step==time.step,trait.col[[i]]])
		output[i] <- sum(temp) / areas[i]
	}
	return(output)
}

# calculating areas from .csv hexmap exports

ha.hex <- 86.6 # ha, divide by 100 to get km2

# n.s <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Analysis/north.south.50.csv',header=TRUE)
# hab.qual <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Analysis/hab.qual.15.csv',header=TRUE)
# sw.range <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Analysis/sw.range.csv',header=TRUE)
# sw.range <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Analysis/sw.range2.csv',header=TRUE)
# sw.range <- read.csv('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Analysis/sw.range3.csv',header=TRUE)

area.1 <- length(n.s$Step_1[n.s$Step_1==1 & sw.range$Step_1==1 & hab.qual$Score >= 0.25]) * ha.hex / 100
area.2 <- length(n.s$Step_1[n.s$Step_1==2 & sw.range$Step_1==1 & hab.qual$Score >= 0.25]) * ha.hex / 100
cat('area 1',area.1,'area 2',area.2,'\n')

# calculating densities from census files
# lynx.dens <- density.est(census='F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/lynx.007/lynx.007-[1]/lynx.007.0.csv',
							# trait.col=list(seq(7,11,1),seq(12,16,1)),
							# areas=c(area.1,area.2),
							# time.step=13
							# )
# print(lynx.dens)

scenario <- 'lynx.035c'
cat('###################\n',scenario,'\n')
plot(1~1,ylim=c(1,4000),xlim=c(1,50))
for (y in 1:15)
{
	lynx.dens <- density.est(census=paste('F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1/Results/',scenario,'/',scenario,'-[1]/',scenario,'.0.csv',sep=''),
								trait.col=list(seq(7,12,1),seq(13,18,1)),
								areas=c(area.1,area.2),
								time.step=y
								)
	cat('year',y,'south then north',round(lynx.dens*100,1),'\n')
	points(lynx.dens[1]*area.1 ~ y,pch=1)
	points(lynx.dens[2]*area.2 ~ y,pch=2)
}
