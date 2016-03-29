
# I didn't end up using this script. I liked the effects plots in fisher_lmer_pop.r better.
# Coefficient plots to show effects among GCM and Scenario Treatments

fe <- read.csv("D:/Box Sync/PNWCCVA/MS_MesoCarnivores/1_Results/fisher_log_lmer_coef_ci95.csv",header=TRUE,row.names=1,stringsAsFactors = FALSE)
# fe <- fe[-1,]
test <- grep(':',rownames(fe))
fe <- fe[-test,]
# test <- grep('year',rownames(fe))
# fe <- fe[-test,]
fe <- exp(fe)

# Drop the interactions and year
# change the scale to real numbers (not relative)
# label the intercept appropriately
# break out by gcm vs sens.

# Plot
p <- ggplot(fe, aes(x=rownames(fe), y=Estimate)) + 
  geom_errorbar(aes(ymin=lower, ymax=upper), width=.1) +
  geom_line() + geom_point() + ylab('value (intercept=esA1b,HabitatForest)') + xlab('coefficient') # + coord_flip()
plot(p)
ggsave("../Box Sync/PNWCCVA/MS_MesoCarnivores/Results/fisher_log_lmer_coef_ci95.png", width = 7, height = 5)

