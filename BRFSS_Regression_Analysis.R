################################################
#########  BRFSS Healthcare Analytics  #########
#########      Regression Analysis    ##########
################################################

# Setting working directory
getwd()
setwd("C:/Users/ ...")

### Regression Analysis ###

# Read in analytic table
brfss <- read.csv(file="data/brfss_clean.csv", header=TRUE, sep=",")

