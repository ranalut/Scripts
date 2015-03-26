

library(ggplot2)
library(foreign)
theData.2 <- data.frame(Abundance=NA, Year=NA, Model=NA)
# models <- c('full','swe','biomes','temp')
# models <- c('full','swe','biomes')
models <- c('full','clim','veg')
# my.colors <- c('#e41a1c','#377eb8','#4daf4a','#984ea3') # red, blue, green, purple
# target.site <- "Bob Marshall"
target.site <- "Charles Sheldon" # "Yellowstone"

for (i in 1:length(models))
{
	theData <- read.dbf(
		# "C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/wolverine/wolverine_eco_full_ave_gulo_023_a2.dbf",
		paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pygmy_rabbit/pygmy_rabbit_pa_",models[i],"_ave_rabbit_020_hab_v2.dbf",sep=''),
		# paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/greater_sage_grouse/greater_sage_grouse_pa_",models[i],"_ave_sagr_136_hab_v2b.dbf",sep=''),
		# paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/wolverine/wolverine_pa_",models[i],"_ave_gulo_023_a2.dbf",sep=''),
		# paste("C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/fisher/fisher_pa_",models[i],"_ave_fisher_14.dbf",sep=''),
		as.is=TRUE
		)
	poly.data <- read.dbf(
		# "C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_represented_ecoregions_carnivores.dbf",
		# "C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_protected_areas_carnivores.dbf",
		"C:/Users/cwilsey/Box Sync/PNWCCVA/Outputs/pnwccva_protected_areas_us.dbf",
		as.is=TRUE
		)
	# print(colnames(theData))
	# print(colnames(poly.data))
	theData <- merge(theData,poly.data[,c('OBJECTID','NAME','AREA_SQKM')])
	# print(colnames(theData))
	# stop('cbw')

	# temp <- as.data.frame(t(theData[theData$NAME==target.site,2:101]))
	temp <- as.data.frame(t(theData[theData$NAME==target.site,2:12]))
	colnames(temp) <- 'Abundance'
	# temp$Year <- seq(2000,2099,1)
	temp$Year <- seq(2000,2100,10)
	temp$Model <- models[i]
	
	theData.2 <- rbind(theData.2,temp)
}
theData.2 <- theData.2[-1,]
theData.2$Model <- factor(theData.2$Model)

# stop('cbw')

g <- ggplot(data=theData.2,aes(x=Year, y=Abundance, group=Model, colour=Model),color=my.colors) + geom_line(size=1.5) + scale_color_brewer(palette="Set1") + theme(axis.text=element_text(size=24), axis.title=element_text(size=30)) + theme(legend.text = element_text(size = 30)) + theme(legend.title = element_text(size = 30))
	

png("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/pygmy_rabbit_pa_charles_sheldon.png",width=960,height=960,pointsize=12)
# png("C:/Users/cwilsey/Box Sync/PNWCCVA/2015 Outputs/fisher_pa_bob_marshall.png",width=960,height=960,pointsize=12)
	print(g)
dev.off()
