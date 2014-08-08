library(RColorBrewer)

workspace <- 'h:/hexsim/workspaces/sage_grouse_v3/analysis/'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
# classes <- c('grassland','shrublands','developed')
models <- c('full','clim','veg')

the.data <- read.csv(paste(workspace,'rf.models.area.table.csv',sep=''),header=TRUE)
the.data$km2 <- the.data$km2/1000
yMax <- max(the.data$km2)
yMin <- min(the.data$km2)
the.data.2 <- aggregate(km2 ~ model + year, data=the.data, FUN=mean)

# myColors <- brewer.pal(3,'PuBuGn')
myColors <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c') # Blues, Greens, Reds

png(paste(workspace,'habitat.area.png',sep=''),res=175, height=750, width=750)
par(mar=c(4,4,1,1))
for (i in 1:length(models))
{
	for (j in theGCMs)
	{
		temp <- the.data[the.data$model==models[i] & the.data$gcm==j,'km2']
		temp <- temp[-1]
		if (models[i]=='full' & j=='CCSM3') { plot(temp ~ seq(2000,2100,10), type='l', ylim=c(yMin,yMax), col=myColors[c(1,3,5)][i], xlab='YEAR', ylab='AREA (1000s KM2)', lwd=2) }
		else { lines(temp ~ seq(2000,2100,10),col=myColors[c(1,3,5)][i], lwd=2) }
	}
	temp <- the.data.2[the.data.2$model==models[i],'km2']
	temp <- temp[-1]
	lines(temp ~ seq(2000,2100,10),col=myColors[c(2,4,6)][i],lwd=4)
	p.change <- round(100 * (temp[length(temp)] - temp[1])/temp[1])
	cat(models[i],'% change',p.change,'\n')
}
dev.off()


