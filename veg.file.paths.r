
  
build.paths <- function(theGCM, var.index=1) 
{  
  z <- var.index
  
  file.name.a2.pre <- 'wna30sec_a2_' # c('','wna30sec_a2_','wna30sec_a2_','wna30sec_a2_')
  file.name.a2.suf <- '_biome_30-year_mean_' # c('_deficit_mam_','_lpj_afirefrac_','_mtco_','_mtwa_')
  file.name.cru <- 'wna30sec_cru_ts_2.10_biome_30-year_mean_' # c('deficit_mam_','wna30sec_cru_ts2.1_lpj_afirefrac_','wna30sec_cru_ts_2.10_mtco_','wna30sec_cru_ts_2.10_mtwa_')

  names1 <- paste('L:/space_lawler/shared/pnwccva-vegetationdata/26jul13_outputs/biome_modal_30yr_cru_ts_2.10/',file.name.cru[z],seq(1961,2000,1),'.nc',sep='')
  names2 <- paste('L:/space_lawler/shared/pnwccva-vegetationdata/26jul13_outputs/biome_modal_30yr_a2/',file.name.a2.pre[z],theGCM,file.name.a2.suf[z],seq(2001,2099,1),'.nc',sep='')
  the.names <- c(names1,names2)
  return(the.names)
}
