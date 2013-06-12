
library(sp)
library(lattice)
# trellis.par.set(sp.theme())

plot.csv <- function(path.csv,hex.grid=hex.grid,column) #narrow=TRUE
{
	the.csv <- read.csv(path.csv,header=TRUE)
	# print(head(the.csv))
	plot.data <- addAttrToGeom(x=hex.grid[[2]],y=the.csv,match.ID=FALSE)
	rm(the.csv)
	print(head(plot.data))
	print(spplot(plot.data,zcol=column,scales=list(draw=TRUE),pretty=TRUE))
}

plot.csv(path.csv='F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Results/rana.lut.73.baseline/rana.lut.73.baseline-[1]/population/population.110.csv',hex.grid=hex.grid,column='Score')
