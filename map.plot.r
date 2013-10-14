source('log.transform.w.negatives.r')

# Function to produce a plot, must be wrapped in png() and layout() functions
map.plot <- function(the.data, distribution.data, cutoffs, spatial.data, political, ocean, model.name, add.legend, include.axes, color.ramp, margins, label.text=NA, study.area, data.type)
{
	# print(dim(the.data)); print(head(the.data)); print(dim(spatial.data@data)); print(head(spatial.data@data)); dev.off(); stop('cbw')
	the.map <- merge(spatial.data,the.data,all.x=FALSE)
	# print(the.map@data[,c('CBW_CODE','variable')]); dev.off(); stop('cbw')
	the.range1 <- range(the.map@data$variable); print(the.range1)
	
	if (data.type=='abundance')
	{
		the.map@data$variable[the.map@data$variable==0] <- NA
		colnames(distribution.data)[1] <- 'hist.range'
		distribution.data$hist.range <- sapply(distribution.data$hist.range, log.transform.neg)
		the.map <- merge(the.map,distribution.data,all.x=TRUE) # ; cat('step 1\n')
		# print(head(the.map@data))
	}
	
	# the.map@data$density <- the.map@data$variable/(the.map@data$F_AREA/100)
	# the.range2 <- range(the.map@data$density); print(the.range2)
	the.map@data$density[the.map@data$variable < cutoffs[1]] <- cutoffs[1] + 1
	the.map@data$density[the.map@data$variable > cutoffs[length(cutoffs)]] <- cutoffs[length(cutoffs)] - 1

	cutoffs.log <- sapply(cutoffs, log.transform.neg)
	the.map@data$variable.log <- sapply(the.map@data$variable, log.transform.neg)
	# print(cutoffs.log); print(color.ramp)
	
	the.map@data$color <- as.character(cut(the.map@data$variable.log, breaks=cutoffs.log, labels=color.ramp))
	# the.map@data$color <- as.character(colorRampPalette(color.ramp)(the.map@data$variable))
	# print(the.map@data[,c('CBW_CODE','variable','color')]); dev.off(); stop('cbw')
	
	# image.plot(x,y,log(z), axis.args=list( at=log(ticks), labels=ticks))
	
	par(mar=margins)
	plot(political, col=rgb(189,189,189,max=255), xlim=c(-135,-107), ylim=c(38,58), axes=include.axes, cex.axis=1.25)
	plot(the.map, add=TRUE, col=the.map@data$color, border='gray')
	plot(ocean, add=TRUE, col=rgb(166,189,219,max=255))
	if (the.range1[1]<0 & data.type=='abundance') { plot(the.map[is.na(the.map@data$variable)==TRUE & the.map@data$hist.range>0,],border='white',add=TRUE) }
	plot(study.area,add=TRUE, border='red')
	plot(political, add=TRUE)
	text(x=-130,y=40,model.name,cex=1.5)
	
	if (add.legend==TRUE) 
	{ 
		# color.legend(xl,yb,xr,yt)
		image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs.log),max(cutoffs.log)), breaks=cutoffs.log, col=color.ramp, lab.breaks=cutoffs, legend.width=3, graphics.reset=TRUE, legend.args=list(text=label.text,cex=1.5,side=1,line=ifelse(data.type=='abundance',2,2.5)))
		# image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), col=as.character(colorRampPalette(color.ramp)(the.map@data$variable)), legend.width=3, graphics.reset=TRUE, legend.args=list(text=label.text,cex=1.5,side=1,line=2.25))
		# image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), col=color.ramp, lab.breaks=cutoffs, legend.width=3, legend.args=list(text=label.text,cex=1.5,side=1,line=2.25)) # nlevel=length(color.ramp), graphics.reset=TRUE)
	}
}	
