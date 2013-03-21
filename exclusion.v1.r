
exclusion <- read.csv("F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/hex_id_exclusion.txt",header=TRUE)
exclusion <- exclusion[,2:3]
print(head(exclusion))
exclusion$Score[exclusion$Score==0] <- 1
exclusion$Score2 <- exclusion$Score
print(head(exclusion))
# write.csv(exclusion,"F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/hex_id_exclusion.csv")
write.csv(exclusion,"F:/PNWCCVA_Data2/HexSim/Workspaces/spotted_frog_v2/Spatial Data/hex_id_exclusion.csv",row.names=FALSE)
