
workspace <- 'f:/pnwccva_data2/hexsim/workspaces/spotted_frog_v2'
base.sim <- 'rana.lut.103e2'

workspace <- 'd:/data/wilsey/hexsim/workspaces/town_squirrel_v1'
base.sim <- 'squirrel.006c.100'

displace <- read.csv(paste(workspace,'/results/',base.sim,'/',base.sim,'-[1]/',base.sim,'_REPORT_displacement_squirrels_0_5.csv',sep=''),header=TRUE)
displace$Meters.Displaced <- round(displace$Meters.Displaced)
print(table(displace$Meters.Displaced))
hist(displace$Meters.Displaced)
