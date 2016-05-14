
# Psuedocode
# Read in the model table
# Rank models
# Calculate delta AIC
# Calulate AIC weights
# write table.

vector_paste <- function(x) { paste(x[2:length(x)],collapse='') }

build.aic.table <- function(species,path)
{
  aic <- read.table(paste(path,species,"_lmer_aic.txt",sep=''),header=TRUE,sep='\t',row.names=NULL,stringsAsFactors=FALSE,skip=1)
  temp <- apply(aic,1,FUN=vector_paste)
  aic[,2] <- temp
  aic <- aic[,1:2]
  colnames(aic) <- c('aic','call')
  # aic <- aic[-1,]
  
  aic <- aic[order(aic$aic),]
  best <- aic$aic[1]
  # print(best)
  # print(aic$aic)
  aic$delta <- aic$aic - best
  aic$weight <- best / aic$aic
  
  aic <- aic[,c('call','aic','delta','weight')]
  write.csv(aic,paste(path,species,"_lmer_aic_table.csv",sep=''))
}

# meso <- c('fisher','lynx','wolverine')
# for (i in meso)
# {
#   build.aic.table(species=i,path="D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/")
# }

# build.aic.table(species='whwo',path="D:/Box Sync/PNWCCVA/MS_Woodpecker/Results/")
# Seems there's an extra field at the end which produces NAs. Deleted by hand
