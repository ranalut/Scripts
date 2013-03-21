
library(ncdf)

##############################
###
###  annualMeanNcdf
###
###############################

###***********
### Check units and varaible precision before using 
###***********

annualCalcFutureAetToPet <- function(startYr = 1, endYr = 150,
          modelNameList = c("bccr_bcm2_0.1", "cccma_cgcm3_1.1", "cccma_cgcm3_1.2", "cccma_cgcm3_1.3", 
          "cccma_cgcm3_1.4", "cccma_cgcm3_1.5", "cnrm_cm3.1", "csiro_mk3_0.1", 
          "gfdl_cm2_0.1", "gfdl_cm2_1.1", "giss_model_e_r.1", "giss_model_e_r.2", 
          "giss_model_e_r.4", "inmcm3_0.1", "ipsl_cm4.1", "miroc3_2_medres.1", 
          "miroc3_2_medres.2", "miroc3_2_medres.3", "miub_echo_g.1", "miub_echo_g.2", 
          "miub_echo_g.3", "mpi_echam5.1", "mpi_echam5.2", "mpi_echam5.3", 
          "mri_cgcm2_3_2a.1", "mri_cgcm2_3_2a.2", "mri_cgcm2_3_2a.3", "mri_cgcm2_3_2a.4", 
          "mri_cgcm2_3_2a.5" , "ncar_ccsm3_0.1", "ncar_ccsm3_0.2", "ncar_ccsm3_0.3", 
          "ncar_ccsm3_0.4", "ncar_ccsm3_0.5", "ncar_ccsm3_0.6", "ncar_ccsm3_0.7", 
          "ncar_pcm1.1", "ncar_pcm1.2", "ncar_pcm1.3", "ncar_pcm1.4","ukmo_hadcm3.1"), 
          scenNameList = c("a2", "a1b", "b1"),
          dataType = "AR4_Global_50k") {

       
            
  if (dataType == "AR4_US_12k")  {
    cellsize <- 0.125
    nCols <- 462
    nRows <- 222
  
    inNc1 <- open.ncdf("sresa1b.bccr_bcm2_0.1.monthly.Prcp.1950-2099.nc")
    timeVals <- inNc1$dim$time$vals
    timeValsAnn <-  timeVals[seq(6,1800, by = 12)]
    timeValsSeas15 <-  timeVals[seq(1,1800, by = 12)]
    timeValsSeas16 <-  timeVals[seq(4,1800, by = 12)]
    timeValsSeas17 <-  timeVals[seq(7,1800, by = 12)]
    timeValsSeas18 <-  timeVals[seq(10,1800, by = 12)]
    
    lonVals <-  inNc1$dim$longitude$vals
    latVals <-  inNc1$dim$latitude$vals
    
    
    dataTypeName <- "AR4_US_12k"
    
    
  }

  if (dataType == "AR4_Global_50k")  {
    cellsize <- 0.5
    nCols <- 720
    nRows <- 278
  
    inNc1 <- open.ncdf("sresa2.bccr_bcm2_0.1.monthly.Prcp.1950-2099.nc")
    timeVals <- inNc1$dim$time$vals
    timeValsAnn <-  timeVals[seq(6,1800, by = 12)]
    timeValsSeas15 <-  timeVals[seq(1,1800, by = 12)]
    timeValsSeas16 <-  timeVals[seq(4,1800, by = 12)]
    timeValsSeas17 <-  timeVals[seq(7,1800, by = 12)]
    timeValsSeas18 <-  timeVals[seq(10,1800, by = 12)]
    
    lonVals <-  inNc1$dim$longitude$vals
    latVals <-  inNc1$dim$latitude$vals
    
    
    dataTypeName <- "AR4_Global_50k"

  }
  
  years <- startYr:endYr
  
  for (modelName in modelNameList) {

    for (scenName in scenNameList) {

       if(file.exists(paste("sres", scenName, ".", modelName, ".monthly.aetHam.1950-2099.nc", sep = ""))) {
        
        name0 <-  paste("sres", scenName, ".", modelName, ".monthly.aetToPetHam.1950-2099", sep = "")
        name0Ann <- paste(name0, ".14.annual.nc", sep = "")
        
        nameAet <-  paste("sres", scenName, ".", modelName, ".monthly.aetHam.1950-2099.14.annual.nc", sep = "")
        namePet <-  paste("sres", scenName, ".", modelName, ".monthly.petHam.1950-2099.14.annual.nc", sep = "")
        
        if (!file.exists(name0Ann) )  {
          dimYr <- dim.def.ncdf("time", "Days since 1950-01-01 00:00:00", timeValsAnn)
          dimX <- dim.def.ncdf("longitude", "degrees_east", lonVals)
          dimY <- dim.def.ncdf("latitude", "degrees_north", latVals)


              ncdfVar <- var.def.ncdf(name = "aetToPetHam", units = "ratio", dim = list(dimX,dimY,dimYr), 
                                  missval = -9999, longname = paste("AET:PET (Hamon Method)", dataTypeName), 
                                  prec = "float")
          
          
          ncAet <- open.ncdf(nameAet)
          ncPet <- open.ncdf(namePet)
          
          nc <- create.ncdf(name0Ann, list(ncdfVar))
  
          
          for (yr in 1:length(timeValsAnn)) {
          
            inGridAet <- get.var.ncdf(ncAet, "aetHam", start = c(1, 1, yr), count = c(-1, -1, 1))
            inGridPet <- get.var.ncdf(ncPet, "petHam", start = c(1, 1, yr), count = c(-1, -1, 1))
            
            outGridAetToPet <- inGridAet / inGridPet     
  
              
            
  
            put.var.ncdf(nc, "aetToPetHam", outGridAetToPet, start = c(1,1,yr), count = c(-1,-1,1))
    
            print(paste("aetToPetHam", yr, name0))
          }
    
          close.ncdf(nc)
          close.ncdf(ncAet)
          close.ncdf(ncPet)
        }
      }
  }
  }    
}
