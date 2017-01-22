library(dplyr)
library(tidyr)

all_paths <- dir('D:/PNWCCVA/Merged_Workspaces/wolverine_v1/Results/gulo.023n.a2.cgcm3/', pattern='.0.csv', full.names=T, recursive=T, include.dirs=T)

all_tables <- lapply(all_paths, read.csv)
td <- do.call(rbind, all_tables)

plot(Population.Size ~ Time.Step, td)

# td2 <- filter(td, Time.Step==35)
# print(sd(td2$Population.Size)/mean(td2$Population.Size))

cv <- function(x) sd(x)/mean(x)
all_cv_25 <- td %>%  group_by(Time.Step) %>% summarise(cv=cv(Population.Size))
all_cv_5  <- td %>%  filter(Run<=5) %>% group_by(Time.Step) %>% summarise(cv=cv(Population.Size))

# whether 5 or 25, the CV is still < 5%.
  