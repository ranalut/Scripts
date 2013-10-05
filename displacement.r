
workspace <- 'f:/pnwccva_data2/hexsim/workspaces/spotted_frog_v2'
base.sim <- 'rana.lut.103e2'

displace <- read.csv(paste(workspace,'/results/',base.sim,'/',base.sim,'-[1]/',base.sim,'_REPORT_displacement_rana_lut_0_10.csv',sep=''),header=TRUE)
displace$Meters.Displaced <- round(displace$Meters.Displaced)
print(table(displace$Meters.Displaced))
hist(displace$Meters.Displaced)
