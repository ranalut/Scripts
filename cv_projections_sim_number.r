library(dplyr)
library(tidyr)


# Load data
all_paths <- dir('D:/PNWCCVA/Merged_Workspaces/wolverine_v1/Results/gulo.023n.a2.cgcm3/', pattern='.1.csv', full.names=T, recursive=T, include.dirs=T)

all_tables <- lapply(all_paths, read.csv)
td <- do.call(rbind, all_tables)

plot(Population.Size ~ Time.Step, td)

# td2 <- filter(td, Time.Step==35)
# print(sd(td2$Population.Size)/mean(td2$Population.Size))


# Function for Coefficient of Variation
cv <- function(x) sd(x)/mean(x)


# CV for full population
all_cv_25 <- td %>%  group_by(Time.Step) %>% summarise(cv=cv(Population.Size))
all_cv_5  <- td %>%  filter(Run<=5) %>% group_by(Time.Step) %>% summarise(cv=cv(Population.Size))
write.csv(all_cv_25,'D:/PNWCCVA/Merged_Workspaces/wolverine_v1/Analysis/cv_full_population_25.csv')
write.csv(all_cv_5,'D:/PNWCCVA/Merged_Workspaces/wolverine_v1/Analysis/cv_full_population_5.csv')

# whether 5 or 25, the CV is still < 5%.

# CV in ecoregions
td2 <- gather(td, key='eco',value='count',7:79)
eco_cv_25 <- td2 %>%  group_by(eco,Time.Step) %>% summarise(cv=cv(count))
write.csv(eco_cv_25,'D:/PNWCCVA/Merged_Workspaces/wolverine_v1/Analysis/cv_ecoregions_25.csv')
