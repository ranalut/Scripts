setwd('c:/users/cbwilsey/documents/postdoc/scripts/')

sum.hex <- function(x,attr.table,max.area=866025.4)

{
	if (x%%10000==0) { cat(x,(Sys.time()-startTime),'\n') }
	# water <- attr.table[attr.table$hex_id==x & attr.table$fid_water!=(-1),]
	# print(water)
	# water <- as.vector(water[,'area'])
	water <- as.vector(attr.table[attr.table$hex_id==x & attr.table$fid_water!=(-1),'area'])
	# print(water)
	# if(length(water==0)) { return(0) }
	proportion <- round(sum(water)/max.area,5)
	# proportion <- (sum(water))/max.area
	# print(proportion)
	return(proportion)
}

# temp <- scan("E:/SpatialData/National Hydrography/union1.txt",nlines=10,skip=1)
# print(temp)

# ====================================================================================
# Read in the data
# ====================================================================================

theData <- read.csv("E:/SpatialData/National Hydrography/union1.txt")
print(head(theData))
theData <- theData[theData$Hex_ID!=0 & theData$FID_albers_test3_hexagons_1km!=(-1),c('Hex_ID','FID_pnw_all_water','Shape_Area')]
colnames(theData) <- c('hex_id','fid_water','area')

# ===================================================================================
# Run the analysis
# ==================================================================================

startTime <- Sys.time()
# the.areas <- sapply(X=seq(1,6495260,1),FUN=sum.hex,attr.table=theData)
the.areas <- sapply(X=seq(1,10000,1),FUN=sum.hex,attr.table=theData)
# the.areas <- sapply(X=seq(8,12,1),FUN=sum.hex,attr.table=theData)
# print(the.areas)

output <- data.frame(hex_id=seq(1,6495260,1),proportion=the.areas)
write.csv(output,"E:/SpatialData/National Hydrography/hexagon.proportion.v1.csv")

