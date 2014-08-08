
library(RColorBrewer)
source('consolidate.results.r')
source('add.records.r')

scenario <- 'sagr.136.hab.v2b.' # 'sagr.175.hab.v2b.' # 'sagr.169.hab.v2b.' # 'sagr.136.hab.v2b.'
workspace <- 'h:/hexsim/workspaces/sage_grouse_v3/'
theGCMs <- c('CCSM3','CGCM3.1_t47','GISS-ER','MIROC3.2_medres','UKMO-HadCM3')
# classes <- c('grassland','shrublands','developed')
models <- c('','clim.','veg.')
models2 <- c('full','clim','veg')
reps <- 5

run.consolidate <- 'n'

if (run.consolidate=='y')
{
	consolidate.results(
		workspace=workspace, 
		scenario=scenario, 
		models=models, 
		models2=models2, 
		theGCMs=theGCMs, 
		reps=reps
		)
}
# stop('cbw')

the.data <- read.csv(paste(workspace,'Analysis/',scenario,'all.csv',sep=''),header=TRUE, row.names=1)

yMax <- 20000
yMin <- 0
smzMax <- c(20000,15000,22000,17000,13000,5000,5000)
dir.create(paste(workspace,'Analysis/SMZs/',sep=''),recursive=TRUE)

# myColors <- brewer.pal(3,'PuBuGn')
# myColors <- c('#d9d9d9','#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c') # Blues, Greens, Reds
myColors <- c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00','#ffff33','#a65628','#f781bf')

for (i in 1:length(models2))
{
	for (n in 1:7)
	{
		png(paste(workspace,'Analysis/SMZs/pop.',scenario,'smz',n,'.',models2[i],'.png',sep=''),res=175, height=750, width=750)
		par(mar=c(4,4,1,1))
		
		for (k in 1:5)
		{
			for (j in 1:length(theGCMs))
			{
				if (k==1 & j==1)
				{
					temp <- the.data[the.data$model==models2[i] & the.data$gcm==theGCMs[j] & the.data$replicate==k,paste('Trait.Index..',n,sep='')]
					temp <- temp[-1]
					plot(temp[10:110] ~ seq(2000,2100,1), type='l', ylim=c(yMin,smzMax[n]), col=myColors[1], xlab='YEAR', ylab='FEMALES')
				}
				temp <- the.data[the.data$model==models2[i] & the.data$gcm==theGCMs[j] & the.data$replicate==k,paste('Trait.Index..',n,sep='')]
				temp <- temp[-1]
				lines(temp[10:110] ~ seq(2000,2100,1),col=myColors[n])
			}
		}
		dev.off()
	}
	# the.data.2 <- aggregate(km2 ~ model + year, data=the.data, FUN=mean)
	# temp <- the.data.2[the.data.2$model==models[i],'km2']
	# temp <- temp[-1]
	# lines(temp ~ seq(2000,2100,10),col=myColors[c(2,4,6)][i],lwd=4)
	# p.change <- round(100 * (temp[length(temp)] - temp[1])/temp[1])
	# cat(models[i],'% change',p.change,'\n')
	if (merged.figures=='y') { dev.off() }
}




