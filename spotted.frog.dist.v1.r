

# deficit <- read.table("c:/users/cbwilsey/documents/postdoc/spotted frog/deficit_strm1.txt",skip=6,sep=' ') # Sample based on streams throughout range.
# deficit <- read.table("c:/users/cbwilsey/documents/postdoc/spotted frog/deficit_gap1.txt",skip=6,sep=' ') # Sample based on streams only in the PNW reGAP area.
# deficit <- read.table("c:/users/cbwilsey/documents/postdoc/spotted frog/swe_gap1.txt",skip=6,sep=' ')

dv <- c(apply(deficit,2,c))
dv <- dv[dv != -9999]
hist(dv)
print(median(dv,na.rm=TRUE))
print(mean(dv,na.rm=TRUE))
print(sd(dv,na.rm=TRUE))

quants <- quantile(dv,seq(0,1,0.05),na.rm=TRUE)
print(quants)

quants <- quantile(dv,c(0.02,0.98),na.rm=TRUE)
print(quants)
