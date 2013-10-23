source('log.transform.w.negatives.r')

# Function to produce a plot, must be wrapped in png() and layout() functions
map.plot.simple <- function(the.data, cutoffs, spatial.data, political, ocean, model.name, add.legend, include.axes, color.ramp, margins, label.text=NA, study.area, data.type)
{
	# print(head(spatial.data@data)); print(head(the.data)); dev.off(); stop('cbw')
	the.map <- merge(spatial.data,the.data[the.data$variable!=0,],all.x=FALSE)
	# print(dim(the.map@data)); print(the.map@data$variable); dev.off(); stop('cbw')
	the.map@data <- the.map@data[is.na(the.map@data$variable)==FALSE,]
	# print(dim(the.map))
	
	the.zeros <- merge(spatial.data,the.data[the.data$variable==0,],all.x=FALSE)
	# print(the.zeros@data$variable); print(dim(the.zeros)); dev.off(); stop('cbw')

	the.map@data$color <- rep(NA,length(the.map@data$variable))
	the.map@data$color[the.map@data$variable<0] <- as.character(cut(the.map@data$variable[the.map@data$variable<0], right=FALSE, breaks=cutoffs, labels=color.ramp))
	the.map@data$color[the.map@data$variable>0] <- as.character(cut(the.map@data$variable[the.map@data$variable>0], right=TRUE, breaks=cutoffs, labels=color.ramp))
		
	par(mar=margins)
	plot(political, col=rgb(189,189,189,max=255), xlim=c(-135,-107), ylim=c(38,58), axes=include.axes, cex.axis=1.25)
	plot(the.map, add=TRUE, col=the.map@data$color, border='gray')
	plot(ocean, add=TRUE, col=rgb(166,189,219,max=255))
	# if (the.range1[1]<0 & data.type=='abundance') { plot(the.map[is.na(the.map@data$variable)==TRUE & the.map@data$hist.range>0,],border='white',add=TRUE) }
	plot(the.zeros,border='white',add=TRUE)
	plot(study.area,add=TRUE, border='red')
	plot(political, add=TRUE)
	text(x=-130,y=40,model.name,cex=1.5)
	
	if (add.legend==TRUE) 
	{
		image.plot(legend.only=TRUE, add=TRUE, zlim=c(min(cutoffs),max(cutoffs)), breaks=cutoffs, col=color.ramp, lab.breaks=cutoffs, legend.width=2, graphics.reset=TRUE, legend.args=list(text=label.text,cex=1.5,side=1,line=ifelse(data.type=='abundance',2,2.5)))
	}
}	
