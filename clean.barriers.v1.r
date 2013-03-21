
setwd('c:/users/cbwilsey/documents/postdoc/scripts/')

# file.path <- 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/spotted_frog_v1/Spatial Data/Barriers/nat_atlas_roads/nat_atlas_roads.1.hbf'
file.path <- 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/spotted_frog_v1/Spatial Data/Barriers/nat_atlas_water/nat_atlas_water.1.hbf'

theFile <- readLines(file.path, n=-1, warn=FALSE)
print(head(theFile))
print(length(theFile))

test <- grep('-', theFile, value=FALSE, invert=TRUE)
print(head(test))
print(length(test))
# stop('cbw')

theFile <- theFile[test]

# writeLines(theFile, 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/spotted_frog_v1/Spatial Data/Barriers/nat_atlas_roads/nat_atlas_roads.1.hbf')
writeLines(theFile, 'C:/Users/cbwilsey/Documents/PostDoc/HexSim/Workspaces/spotted_frog_v1/Spatial Data/Barriers/nat_atlas_water/nat_atlas_water.1.hbf')

