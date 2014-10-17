
library(foreign)

copy.paste.area <- function(x)
{
	print(x)
	albers <- read.dbf(paste(x,'_albers.dbf',sep=''),as.is=TRUE)
	geo <- read.dbf(paste(x,'.dbf',sep=''),as.is=TRUE)
	# print(head(albers)); print(class(albers)); print(dim(geo))
	geo <- data.frame(geo,AREA_SQKM=albers$AREA_SQKM)
	write.dbf(geo,paste(x,'.dbf',sep=''))
}

# copy.paste.area('h:/outputs/pnwccva_represented_ecoregions_carnivores')
# workspace <- 'h:/outputs/pnwccva_represented_ecoregions_'
# workspace <- 'h:/outputs/pnwccva_protected_areas_'
# workspace <- 'h:/outputs/pnwccva_watersheds_'
workspace <- 'h:/outputs/pnwccva_sagr_mgmt_zones_'

# shp.files <- c('carnivores','frog','full','us')
shp.files <- 'us'
file.paths <- paste(workspace,shp.files,sep='')

lapply(X=file.paths,FUN=copy.paste.area)

# Fix-up code
# prefix <- 'h:/outputs/pnwccva_represented_ecoregions_carnivores'
# geo <- read.dbf(paste(prefix,'.dbf',sep=''),as.is=TRUE)
# write.dbf(geo,paste(prefix,'.dbf',sep=''))

