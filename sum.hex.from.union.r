setwd('c:/users/cbwilsey/documents/postdoc/scripts/')

sum.hex <- function(x,attr.table,max.area=866025.4)

{
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

# temp <- read.csv("E:/SpatialData/National Hydrography/union1.txt")
# print(head(temp))
# temp <- temp[temp$Hex_ID!=0 & temp$FID_albers_test3_hexagons_1km!=(-1),c('Hex_ID','FID_pnw_all_water','Shape_Area')]
# colnames(temp) <- c('hex_id','fid_water','area')

# ===================================================================================
# Run the analysis
# ==================================================================================

the.areas <- sapply(X=seq(1,6495260,1),FUN=sum.hex,attr.table=temp)
# the.areas <- sapply(X=seq(8,12,1),FUN=sum.hex,attr.table=temp)
# print(the.areas)

output <- data.frame(hex_id=seq(1,6495260,1),proportion=the.areas)
write.csv(output,"E:/SpatialData/National Hydrography/hexagon_proporation1.csv")

