################################################
#########  BRFSS Healthcare Analytics  #########
##########    Discriptive Analysis    ##########
################################################

# Setting working directory
getwd()
setwd("C:/Users/ ...")


### Descriptive Analysis ###

# Read in analytic table
brfss <- read.csv(file="data/brfss_clean.csv", header=TRUE, sep=",")

## Look at distribution of categorical outcome asthma
AsthmaFreq <- table(analytic$ASTHMA4)
AsthmaFreq
write.csv(AsthmaFreq, file = "AsthmaFreq.csv")

# What proportion of our dataset has ashtma?
PropAsthma <- 5343/52788
PropAsthma

# Look at categorical outcome asthma by exposure, ALCGRP
AsthmaAlcFreq <- table(analytic$ASTHMA4, analytic$ALCGRP)
AsthmaAlcFreq
write.csv(AsthmaAlcFreq, file = "AsthmaAlcFreq.csv")


## Look at distribution of sleep duration 
#summary statistics
summary(analytic$SLEPTIM2)

# Create a histogram and a box plot of total file
hist(analytic$SLEPTIM2, 
     main = "Histogram of SLEPTIM2",
     xlab = "Class SLEPTIM2",
     ylab = "Frequency",
     xlim=c(0,15), 
     ylim=c(0,20000),
     border = "red",
     col= "yellow",
     las = 1,
     breaks = 24)

boxplot(analytic$SLEPTIM2, main="Box Plot of SLEPTIM2", 
        xlab="Total File", ylab="SLEPTIM2")

# Create box plots of groups next to each other
boxplot(SLEPTIM2~ALCGRP, data=analytic, main="Box Plot of SLEPTIM2 by ALCGRP", 
        xlab="ALCGRP", ylab="SLEPTIM2")