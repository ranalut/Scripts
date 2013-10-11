

log.transform.neg <- function(x)
{
	x <- round(x)
	if(x>0) { temp <- log(x); return(temp) }
	if(x==0) { return(0) }
	if(x<0) { temp <- -1*log(abs(x)); return(temp) }
}
