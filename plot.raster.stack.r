library(raster)

plot.stack <- function(the.stack, picks='all')
{
	n.layers <- dim(the.stack)[3]
	if (picks=='all') { all.layers <- seq(1,n.layers,1) }
	else { all.layers <- picks }
	for (i in all.layers) 
	{
		plot(dropLayer(the.stack,seq(1:n.layers)[-i]),main=paste('keep',i)) 
	}
}
