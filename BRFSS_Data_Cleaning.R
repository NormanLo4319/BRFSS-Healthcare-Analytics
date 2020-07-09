###################################################
#####  BRFSS Health Data Decriptive Analysis  #####
###########        Data Cleaning        ###########
###################################################

# Import "foreign" package for reading the data
library(foreign)

# Setting working directory
getwd()
setwd("C:/ ...")

# Reading the data
brfss <- read.xport("data/MMSA2014.xpt")
dim(brfss)
colnames(brfss)
head(brfss)

# Define the object list of variables to be kept
varList <- c("VETERAN3", "ALCDAY5", "SLEPTIM1", "ASTHMA3", "X_AGE_G", "SMOKE100",
             "SMOKDAY2", "SEX", "X_HISPANC", "X_MRACE1", "MARITAL", "GENHLTH",
             "HLTHPLN1", "EDUCA", "INCOME2", "X_BMI5CAT", "EXERANY2")

# Create a subset of data by the variable list
brfss <- brfss[varList]
dim(brfss)

# Remove observations before generating new variables
# Remove obs not in the subpopulation
# Subset the dataset for only veterans
brfss <- subset(brfss, VETERAN3==1)

# Remove obs does not have a valid value for exposure or outcome
# Only keep rows with with valid alcohol/exposure variable
brfss <- subset(brfss, ALCDAY5 < 777 | ALCDAY5==888)
# Only keep rows with valid sleep data
brfss <- subset(brfss, SLEPTIM1 < 77)
# Only keep rows with valid asthma data
brfss <- subset(brfss, ASTHMA3 < 7)

dim(brfss)

# Generating exposures variables
# Add the categorical variable set to 9 to the dataset
brfss$ALCGRP <- 9

# Update according to the data dictionary
# Drink Weekly = 3
brfss$ALCGRP[brfss$ALCDAY5 <200 ] <- 3
# Drink Monthly = 2
brfss$ALCGRP[brfss$ALCDAY5 >=200 & brfss$ALCDAY5 <777] <- 2
# No drink in past 30 days = 1
brfss$ALCGRP[brfss$ALCDAY5 == 888] <- 1 

# Check the new variable
table(brfss$ALCGRP, brfss$ALCDAY5)

# Create dummy variable for each category
brfss$DRKMONTHLY <- 0
brfss$DRKMONTHLY[brfss$ALCGRP == 2] <- 1

brfss$DRKWEEKLY <- 0
brfss$DRKWEEKLY[brfss$ALCGRP == 3] <- 1

# Check the new dummy variables
table(brfss$ALCGRP, brfss$DRKMONTHLY)
table(brfss$ALCGRP, brfss$DRKWEEKLY)

# Create outcome variables:
# Create the sleep variable
brfss$SLEPTIM2 <- NA
brfss$SLEPTIM2[!is.na(brfss$SLEPTIM1) & brfss$SLEPTIM1 !=77
                 & brfss$SLEPTIM1 !=99] <- brfss$SLEPTIM1

# Check the new sleep variable
table(brfss$SLEPTIM1, brfss$SLEPTIM2)

# Create the asthma variable
brfss$ASTHMA4 <- 9
brfss$ASTHMA4[brfss$ASTHMA3 == 1] <- 1
brfss$ASTHMA4[brfss$ASTHMA3 == 2] <- 0

# Check the new asthma variable
table(brfss$ASTHMA3, brfss$ASTHMA4)

# Create Age dummy variables (baseline group Age 18 to 24)
brfss$AGE2 <- 0
brfss$AGE3 <- 0
brfss$AGE4 <- 0
brfss$AGE5 <- 0
brfss$AGE6 <- 0

# Age 25 to 34
brfss$AGE2[brfss$X_AGE_G == 2] <- 1
# Age 35 to 44
brfss$AGE3[brfss$X_AGE_G == 3] <- 1
# Age 45 to 54
brfss$AGE4[brfss$X_AGE_G == 4] <- 1
# Age 55 to 64
brfss$AGE5[brfss$X_AGE_G == 5] <- 1
# Age 65 or above
brfss$AGE6[brfss$X_AGE_G == 6] <- 1

# Check the new age dummy variables
table(brfss$X_AGE_G, brfss$AGE2)


# Create Smoke dummy variables
# Dummy for never smoker
brfss$NEVERSMK <- 0
brfss$NEVERSMK [brfss$SMOKE100 == 2] <- 1

# Check the non-smoker dummy
table(brfss$SMOKE100, brfss$NEVERSMK)

# Smoker group, 1 who still smoke, 2 who no longer smoke
brfss$SMOKGRP <- 9
brfss$SMOKGRP[brfss$SMOKDAY2 == 1 | brfss$SMOKDAY2 == 2] <- 1
brfss$SMOKGRP[brfss$SMOKDAY2 == 3 | brfss$NEVERSMK == 1] <- 2

table(brfss$SMOKGRP, brfss$SMOKDAY2)
table(brfss$SMOKGRP, brfss$SMOKE100)

# Dummy for smoker
brfss$SMOKER <- 0
brfss$SMOKER[brfss$SMOKGRP == 1] <- 1

# Check the smoker dummy
table(brfss$SMOKGRP, brfss$SMOKER)

# Drop all NAs in the dataset
brfss_final <- na.omit(brfss)

# Check the data frame
dim(brfss_final)

# Write the clean dataset into csv file
write.csv(brfss_final, file="data/brfss_clean.csv")
