
esri.friendly <- function(x, drop.last=0)
{
	output <- gsub('.','_',x,fixed=TRUE)
	output <- substr(output, 1, nchar(output)- drop.last)
	# print(output)
	return(output)
}

esri.friendly('dog.eat.cat.')