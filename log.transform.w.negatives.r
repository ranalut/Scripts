

log.transform.neg <- function(x)
{
	if (is.na(x)==TRUE) { return(NA) }
	x <- round(x)
	if(x>1) { temp <- log(x); return(temp) }
	if(x==0) { return(0) }
	if(x<(-1)) { temp <- -1*log(abs(x)); return(temp) }
	if(x<=1 & x>0) { temp <- 0.01; return(temp) }
	if(x>=(-1) & x<0) { temp <- -0.01; return(temp) }
}


# print(sapply(c(NA,-5,-1,-0.5,0,0.5,1,5),log.transform.neg))
