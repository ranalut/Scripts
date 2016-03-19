
# Psuedocode
# Read in the model table
# Rank models
# Calculate delta AIC
# Calulate AIC weights
# write table.

lynx <- read.table("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/lynx_lmer_aic.txt",header=TRUE,sep='\t')
lynx <- readLines("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/Results/lynx_lmer_aic.txt")
