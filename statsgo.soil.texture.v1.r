
# This script attempts to extract the soil texture description for each map unit directly from the tabular data for the STATSGO Access database.

#set data columns according to http://soildatamart.nrcs.usda.gov/documents/SSURGO%20Metadata%20-%20Tables%20and%20Columns%20Report.pdf
  # cokey column in the datatable (e.g. chorizon)
  cokey.tab<-"V170"
  #cokey colun in the component table
  cokey.comp<-"V109"
  #mukey in the component table
  mukey<-"V108"
  #the variable of interest in the datatable (e.g. organic matter in the chorizon table)
  value.tab<-"V67"

#read in the tabular statsgo data
  comp<-read.table("D:\\Data\\schloss\\gsmsoil_us\\gsmsoil_us\\tabular\\comp.txt", sep="|")
  tab<-read.table("D:\\Data\\schloss\\gsmsoil_us\\gsmsoil_us\\tabular\\chorizon.txt", sep="|")

# a vector of the unique components (cokey values) that are available in the data (e.g. chorizon table)
  tab.comps<-unique(tab[,cokey.tab])
  
######################################
# STEP 1: find the value for each component (weighted average or weighted total or dominant component)
  #the following code uses depth weighted average
  #for horizons without information - the depth of that horizon is not included in the total depth

  #blank datatable with all the componants that are in the variable data table
  datatable<-data.frame(cokey=tab.comps, value=rep(NA, length(tab.comps)))

#loop through components
for (c in tab.comps){
  #find number of horizons in the given component
  num.layers<-length(which(tab[,cokey.tab]==c))
  #subset the variable datatable to all horizons within the component
  subL<-tab[which(tab[,cokey.tab]==c),]

  #find the horizons that have a value for that variable
  notNA.index<-which(subL$V67>-1)
  depth.tot<-0
  # loop through only the horizons that have a value and calculate depth of each horizon and total depth
  for (L in notNA.index){
    depth1<-(subL$V10[L]-subL$V7[L])
    depth.tot<-depth1+depth.tot
    }
  #find the value of the variables for each horizon as the depth weighted value for that variable (each NA will stay NA)
  subL$value<-subL$V67*(subL$V10-subL$V7)/depth.tot

  #calculate the value of the variable for the component
    #if some values are not NA - then sum the depth weighted values to get the depth weighted average
    if(length(notNA.index)>0){datatable$value[datatable$cokey==c]<-sum(subL$value, na.rm=T)}
    #if all values are NA set that components value as NA
    if(length(notNA.index)==0){datatable$value[datatable$cokey==c]<-NA }
    }


######################################
# STEP 2: find  the value for each map unit (weighted average or weighted total or dominant component)

  #read in soil spatial map of relevent areas - with old data for comparison
  library(foreign)
  map<-read.dbf("s:/shared/facet_GIS_data/soils/OM.dbf")
  map$newom<-rep(NA, length(map$MUKEY))

  #unique mukeys for each mapunit
  mus<-unique(map$MUKEY)

 #loop through map unit
 for (mu in  mus){
# create subset of components in the map unit
  sub1<-comp[which(comp$V108==mu),]
  sub1$wtvalue<-rep(NA, length(sub1[,1]))
      for (s1 in sub1$V109){
          leng.match<-length(which(as.character(datatable$cokey)==as.character(s1)))
          if(leng.match>0){
          sub1$wtvalue[which(sub1$V109==s1)]<-sub1$V2[which(sub1$V109==s1)]*datatable$value[which(as.character(datatable$cokey)==as.character(s1))]
             if(is.na(datatable$value[which(datatable$cokey==as.character(s1))])){sub1$wtvalue[which(sub1$V109==s1)]<-NA; print(s1)
          sub1$V2[which(sub1$V109==s1)]<-0 } 
            
            }
          if(leng.match==0 ){sub1$wtvalue[which(sub1$V109==s1)]<-NA; print(s1)
          sub1$V2[which(sub1$V109==s1)]<-0 }
         
          }
       sub1$wtavg<-sub1$wtvalue/(sum(sub1$V2))
       
 leng.sub1<-length(sub1$wtavg)
 if(length(which(is.na(sub1$wtavg)))==leng.sub1){map$newom[which(map$MUKEY==mu)]<-NA}
 if(length(which(is.na(sub1$wtavg)))<leng.sub1){map$newom[which(map$MUKEY==mu)]<-sum(sub1$wtavg, na.rm=T)}
 }

map$newom[which(is.na(map$newom))]<- -9999
write.csv(map, "s:/shared/facet_GIS_data/soils/new_om2.csv", row.names=F)