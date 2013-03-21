
setwd('c:/users/cbwilsey/documents/postdoc/scripts/')
library(rattle)
library(foreign)

# mu.dom.texture <- read.table('c:/users/cbwilsey/documents/postdoc/soils/conus-soil/mu_domtcode.ascii',skip=2)
# colnames(mu.dom.texture) <- c('MUID','MUSERIAL',paste('L',seq(1,11),sep=''))
# print(head(mu.dom.texture))
mu.fraction <- read.dbf('c:/users/cbwilsey/documents/postdoc/soils/conus-soil/mu_fraction.dbf',as.is=TRUE)
# print(head(mu.fraction)); stop('cbw')
test <- grep('SAND',colnames(mu.fraction),value=FALSE)
mu.fraction <- mu.fraction[,c(1:3,test)]
# print(colnames(mu.fraction)); stop('cbw')

extract.dom.texture <- function(x,layers)
{
	multipliers <- c(1,1,2,2,2,4,4,4,10,10,10)
	x <- x[1:layers]
	# print(x)
	y <- repeat.function(x.vector=x,each.vector=multipliers[1:layers],layers=layers)
	# print(length(y))
	# print(y)
	output <- modalvalue(y)
	# print(output) #; stop('cbw')
	return(output)
}

is.sand.texture <- function(x,layers,min.sand)
{
	multipliers <- c(1,1,2,2,2,4,4,4,10,10,10)
	sand.values <- c(1,2,3,4,6)
	x <- x[1:layers]
	# print(x)
	y <- repeat.function(x.vector=x,each.vector=multipliers[1:layers],layers=layers)
	# print(length(y))
	# print(y)
	output <- modalvalue(y)
	z <- y[y%in%sand.values]
	if (length(z) < min.sand) { return(output) }
	else { output <- modalvalue(z) }
	# print(x); print(y); print(output)
    return(output)
}

repeat.function <- function(x.vector,each.vector,layers)
{
	output <- NA
	for (i in 1:layers)
	{
		output <- c(output,rep(x.vector[i],each=each.vector[i]))
	}
	output <- output[-1]
	return(output)
}

extract.sand.fraction <- function(x,layers,min.sand)
{
	multipliers <- c(1,1,2,2,2,4,4,4,10,10,10)
	x <- x[1:layers]
	# print(x)
	y <- repeat.function(x.vector=x,each.vector=multipliers[1:layers],layers=layers)
	# print(length(y))
	# print(y)
	y <- y[y!=0]
	if (length(y) < min.sand) { output <- 0; return(output) }
	output <- mean(y,na.rm=TRUE)
	# print(output) #; stop('cbw')
	return(output)
}

# dom.texture <- t(apply(X=mu.dom.texture[,-c(1:2)],MARGIN=1,FUN=extract.dom.texture, layers=8))
# sand.texture <- t(apply(X=mu.dom.texture[,-c(1:2)],MARGIN=1,FUN=is.sand.texture, layers=8, min.sand=3))
sand.fraction <- t(apply(X=mu.fraction[,-c(1:3)],MARGIN=1,FUN=extract.sand.fraction, layers=8, min.sand=4))
# mu.dom.texture$dom8 <- as.numeric(dom.texture)
# mu.dom.texture$sand8 <- as.numeric(sand.texture)
mu.fraction$p_sand <- round(as.numeric(sand.fraction))

# write.csv(mu.dom.texture,'c:/users/cbwilsey/documents/postdoc/soils/conus-soil/dom_text_v2.csv')
write.csv(mu.fraction,'c:/users/cbwilsey/documents/postdoc/soils/conus-soil/soil_fraction_v1.csv')

stop('cbw')

   # Layer        Thickness       Depth to Top    Depth to Bottom
        
     # 1         5 cm (2 in)        0 cm (0 in)     5 cm (2 in)
     # 2         5 cm (2 in)        5 cm (2 in)    10 cm (4 in)
     # 3        10 cm (4 in)       10 cm (4 in)    20 cm (8 in)
     # 4        10 cm (4 in)       20 cm (8 in)    30 cm (12 in)
     # 5        10 cm (4 in)       30 cm (12 in)   40 cm (16 in)
     # 6        20 cm (8 in)       40 cm (16 in)   60 cm (24 in)
     # 7        20 cm (8 in)       60 cm (24 in)   80 cm (31 in)
     # 8        20 cm (8 in)       80 cm (31 in)  100 cm (39 in)
     # 9        50 cm (20 in)     100 cm (39 in)  150 cm (59 in)
    # 10        50 cm (20 in)     150 cm (59 in)  200 cm (79 in)
    # 11        50 cm (20 in)     200 cm (79 in)  250 cm (98 in)

# squirrel down to 146 cm, level 9
# rabbit down to 100 cm, level 8
# rat down to 65 cm, level 6-7
