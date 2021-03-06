# Plot number of occupied HUCs

plot.counts <- function(workspace, var.name, output.file, species, ylim)
{
	the.data <- as.matrix(read.csv(paste(workspace,'Analysis/count.',var.name,'.csv',sep=''),header=TRUE))
	
	the.data2 <- the.data[c(4,5,3),]
	
	png(paste(workspace,'Analysis/',species,'.count.',var.name,'.plot.png',sep=''))
	
	barplot(the.data2, names.arg=c('BASELINE','CCSM3','CGCM3.1','GISS-ER','MIROC\n3.2','UKMO-\nHadCM3'),ylim=ylim, legend.text=c('decreasing','stable','increasing'))
	
	barplot(the.data[1,1], add=TRUE, density=15, angle=c(45), col='black')
	
	dev.off()
}

# plot.counts(workspace='H:/HexSim/Workspaces/wolverine_v1/', var.name='hucs', species='gulo', ylim=c(0,350))

# plot.counts(workspace='I:/HexSim/Workspaces/lynx_v1/', var.name='hucs', species='lynx', ylim=c(0,425))

plot.counts(workspace='H:/HexSim/Workspaces/spotted_frog_v2/', var.name='hucs.105', species='rana.lut', ylim=c(0,450))

# plot.counts(workspace='F:/pnwccva_data2/HexSim/Workspaces/town_squirrel_v1/', var.name='hucs', species='squirrels', ylim=c(0,125))