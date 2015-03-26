

library(ggplot2)
library(foreign)
theData.2 <- list()
models <- c('full','swe','biomes','temp')
my.colors <- c('#e41a1c','#377eb8','#4daf4a','#984ea3') # red, blue, green, purple

for (i in 1:4)
{
	theData <- read.dbf(
		# "C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/wolverine/wolverine_eco_full_ave_gulo_023_a2.dbf",
		# paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/wolverine/wolverine_pa_",models[i],"_ave_gulo_023_a2.dbf",sep=''),
		paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/fisher/fisher_pa_",models[i],"_ave_fisher_14.dbf",sep=''),
		as.is=TRUE
		)
	poly.data <- read.dbf(
		# "C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf",
		"C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_protected_areas_carnivores.dbf",
		as.is=TRUE
		)
	# print(colnames(theData))
	# print(colnames(poly.data))
	theData <- merge(theData,poly.data[,c('OBJECTID','NAME','AREA_SQKM')])
	print(colnames(theData))
	# stop('cbw')

	# theData.2[[i]] <- as.data.frame(t(theData[theData$NAME=='Yellowstone',2:101]))
	theData.2[[i]] <- as.data.frame(t(theData[theData$NAME=="Bob Marshall",2:101]))
	colnames(theData.2[[i]]) <- 'Abundance'
	theData.2[[i]]$Year <- seq(2000,2099,1)
}
# g <- ggplot(theData.2[[1]], aes(Year, Abundance)) + geom_point(color="firebrick") + stat_smooth() # + geom_point(color="firebrick")
g <- ggplot() + 
	geom_point(data=theData.2[[1]], aes(Year, Abundance),color=my.colors[1]) + 
	geom_point(data=theData.2[[2]], aes(Year, Abundance),color=my.colors[2]) + 
	geom_point(data=theData.2[[3]], aes(Year, Abundance),color=my.colors[3]) +
	geom_point(data=theData.2[[3]], aes(Year, Abundance),color=my.colors[4]) +
	geom_line(data=theData.2[[1]], aes(Year, Abundance),color=my.colors[1]) + 
	geom_line(data=theData.2[[2]], aes(Year, Abundance),color=my.colors[2]) + 
	geom_line(data=theData.2[[3]], aes(Year, Abundance),color=my.colors[3]) +
	geom_line(data=theData.2[[3]], aes(Year, Abundance),color=my.colors[4]) +
	# I couldn't figure the legend out.
	scale_colour_manual(name='Model', values=c('#e41a1c','#e41a1c','#e41a1c','#e41a1c'),labels=c('test','test','test','test')) +
	scale_shape_manual(name='Model', values=c('#e41a1c','#e41a1c','#e41a1c','#e41a1c'),labels=c('test','test','test','test'))
	
	# scale_colour_manual(name='', values=c("full"='e41a1c',"swe"='e41a1c',"biomes"='e41a1c'))
	# scale_colour_manual(name='', values=c(models[1]=my.colors[1], models[2]=my.colors[2], models[3]=my.colors[3]))
	# theme(legend.text = element_text(size = 18)) + theme(legend.position=c(2025, 480))

# png("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/wolverine_pa_yellowstone.png")
png("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/fisher_pa_bob_marshall.png")
	print(g)
dev.off()
