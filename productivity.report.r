

workspace <- 'F:/PNWCCVA_Data2/HexSim/Workspaces/lynx_v1'
scenario <- 'lynx.041b'

command1 <- paste('F:/pnwccva_data2/hexsim/currenthexsim/OutputTransformer.exe -productivity:12:36:lynx:"EcoRegion" ',workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')

command2 <- paste('F:/pnwccva_data2/hexsim/currenthexsim/OutputTransformer.exe -productivity:11:35:lynx:"EcoRegion" ',workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')

command <- paste('F:/pnwccva_data2/hexsim/currenthexsim/OutputTransformer.exe -productivity:10:36:lynx:"Latitude" ',workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')

command <- paste('F:/pnwccva_data2/hexsim/currenthexsim/OutputTransformer.exe -productivity:10:36:lynx:"Latitude":"Ecoregion" ',workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'.log',sep='')

# shell(command1)
# shell(command2)
shell(command)
stop('cbw')

# output <- read.csv(paste(workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'_REPORT_productivity_lynx_10_36_[ecoRegion].csv',sep=''),header=TRUE)

s.output <- read.csv(paste(workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'_REPORT_productivity_lynx_12_36_[ecoRegion].csv',sep=''),header=TRUE)

b.output <- read.csv(paste(workspace,'/Results/',scenario,'/',scenario,'-[1]/',scenario,'_REPORT_productivity_lynx_11_35_[ecoRegion].csv',sep=''),header=TRUE)

print(s.output); print(b.output); stop('cbw')

merge.table <- read.csv('h:/spatialdata/spatialdata/tnc-terr-ecoregions121409/ecoregions.merge.table.csv',header=TRUE,row.names=1)

output <- merge(output,merge.table)
print(output)

