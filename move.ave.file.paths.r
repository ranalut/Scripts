
  
build.paths <- function(var.index, theGCM)
{  
  z <- var.index
  theFolders.a2 <- c('deficit_mam_a2_v1','fire_frac_a2','mtco_a2','mtwa_a2')
  theFolders.cru <- c('deficit_mam_v1','afirefrac','mtco','mtwa')
  
  file.name.a2.pre <- c('','wna30sec_a2_','wna30sec_a2_','wna30sec_a2_')
  file.name.a2.suf <- c('_deficit_mam_','_lpj_afirefrac_','_mtco_','_mtwa_')
  file.name.cru <- c('deficit_mam_','wna30sec_cru_ts2.1_lpj_afirefrac_','wna30sec_cru_ts_2.10_mtco_','wna30sec_cru_ts_2.10_mtwa_')
  
  names1 <- paste('L:/space_lawler/shared/pnwccva-climatedata/annual/cru_ts2.1_1901-2000/',theFolders.cru[z],'/',file.name.cru[z],seq(1961,2000,1),'.nc',sep='')
  names2 <- paste('L:/space_lawler/shared/pnwccva-climatedata/annual/a2/',theFolders.a2[z],'/',file.name.a2.pre[z],theGCM,file.name.a2.suf[z],seq(2001,2099,1),'.nc',sep='')
  the.names <- c(names1,names2)
  return(the.names)
}
