###################################################
#####  BRFSS Health Data Decriptive Analysis  #####
###########        Data Cleaning        ###########
###################################################

# Import "foreign" package for reading the data
library(foreign)

# Setting working directory
getwd()
setwd("C:/...")

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


### Data Cleaning ###

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

## Generating exposures variables
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


## Create outcome variables
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


## Create other categorical variables for analysis:
# Create sex dummy variable
brfss$MALE <- 0
brfss$MALE[brfss$SEX == 1] <- 1

# Check the new sex dummy
table(brfss$MALE, brfss$SEX)

# Create new Hispanic dummy variable
brfss$HISPANIC <- 0
brfss$HISPANIC[brfss$X_HISPANC == 1] <- 1

# Check the new Hispanic dummy
table(brfss$HISPANIC, brfss$X_HISPANC)


# Create new race category variables
# Baseline category 9 = Don't know
brfss$RACEGRP <- 9
# 1 = White
brfss$RACEGRP[brfss$X_MRACE1 == 1] <- 1
# 2 = Black
brfss$RACEGRP[brfss$X_MRACE1 == 2] <- 2
# 3 = American Indian
brfss$RACEGRP[brfss$X_MRACE1 == 3] <- 3
# 4 = Asian
brfss$RACEGRP[brfss$X_MRACE1 == 4] <- 4
# 5 = Native Hawaiian / Pacific Islander
brfss$RACEGRP[brfss$X_MRACE1 == 5] <- 5
# 6 = Other race / multiracial
brfss$RACEGRP[brfss$X_MRACE1 == 6 | brfss$X_MRACE1 == 7] <- 6

# Check the new race variable
table(brfss$RACEGRP , brfss$X_MRACE1)

# Create now columns for Black, Asian and Others
brfss$BLACK <- 0
brfss$ASIAN <- 0
brfss$OTHRACE <- 0

# Create dummies for Black, Asian, and others
brfss$BLACK[brfss$RACEGRP == 2] <- 1
table(brfss$RACEGRP, brfss$BLACK)

brfss$ASIAN[brfss$RACEGRP == 4] <- 1
table(brfss$RACEGRP, brfss$ASIAN)

brfss$OTHRACE[brfss$RACEGRP == 3 | brfss$RACEGRP == 5 | brfss$RACEGRP == 6 | brfss$RACEGRP == 7] <- 1
table(brfss$RACEGRP, brfss$OTHRACE)


# Create the marital status category variables
# Baseline category: 9 = Don't know
brfss$MARGRP <- 9
# 1 = Married / Member of an unmarried couple
brfss$MARGRP[brfss$MARITAL == 1 | brfss$MARITAL == 5] <- 1
# 2 = Divorced / Widowed
brfss$MARGRP[brfss$MARITAL == 2 | brfss$MARITAL == 3 ] <- 2
# 3 = Never married
brfss$MARGRP[brfss$MARITAL == 4] <- 3

# Check the new categorical variable
table(brfss$MARGRP, brfss$MARITAL)

# Create dummy variables for each category
brfss$NEVERMAR <- 0
brfss$FORMERMAR <- 0

brfss$NEVERMAR[brfss$MARGRP == 3] <- 1
table(brfss$MARGRP, brfss$NEVERMAR)

brfss$FORMERMAR[brfss$MARGRP == 2] <- 1
table(brfss$MARGRP, brfss$FORMERMAR)


# Create the Genhealth category variables
# Baseline category: 9 = Refused or Don't know
brfss$GENHLTH2 <- 9
# 1 = Excellent
brfss$GENHLTH2[brfss$GENHLTH == 1] <- 1
# 2 = Very Good
brfss$GENHLTH2[brfss$GENHLTH == 2] <- 2
# 3 = Good
brfss$GENHLTH2[brfss$GENHLTH == 3] <- 3
# 4 = Fair
brfss$GENHLTH2[brfss$GENHLTH == 4] <- 4
# 5 = Poor
brfss$GENHLTH2[brfss$GENHLTH == 5] <- 5

# Check the new categorical variable
table(brfss$GENHLTH2, brfss$GENHLTH)

# Create Fair and Poor dummy
brfss$FAIRHLTH <- 0
brfss$POORHLTH <- 0

brfss$FAIRHLTH [brfss$GENHLTH2 == 4] <- 1
table(brfss$FAIRHLTH, brfss$GENHLTH2)

brfss$POORHLTH [brfss$GENHLTH2 == 5] <- 1
table(brfss$POORHLTH, brfss$GENHLTH2)


# Create health plan variables
brfss$HLTHPLN2 <- 9
# 1 = Yes
brfss$HLTHPLN2[brfss$HLTHPLN1 == 1] <- 1
# 2 = No
brfss$HLTHPLN2[brfss$HLTHPLN1 == 2] <- 2

table(brfss$HLTHPLN1, brfss$HLTHPLN2)

# Create dummy for no health plan
brfss$NOPLAN <- 0
brfss$NOPLAN [brfss$HLTHPLN2== 2] <- 1
table(brfss$NOPLAN, brfss$HLTHPLN2)


# Create education category variables
# Baseline category: 9 = refused
brfss$EDGROUP <- 9
# 1 = Below Grade 12
brfss$EDGROUP[brfss$EDUCA == 1 | brfss$EDUCA == 2 | brfss$EDUCA == 3] <- 1
# 2 = Grade 12 or GED
brfss$EDGROUP[brfss$EDUCA == 4] <- 2
# 3 = College 1 to 3 years
brfss$EDGROUP[brfss$EDUCA == 5] <- 3
# 4 = College 4 years or more
brfss$EDGROUP[brfss$EDUCA == 6] <- 4

table(brfss$EDGROUP, brfss$EDUCA)

# Create dummy for lowed education group and some college group
brfss$LOWED <- 0
brfss$SOMECOLL <- 0

brfss$LOWED[brfss$EDGROUP == 1 | brfss$EDGROUP == 2 ] <- 1
table(brfss$LOWED, brfss$EDGROUP)

brfss$SOMECOLL [brfss$EDGROUP == 3] <- 1
table(brfss$SOMECOLL, brfss$EDGROUP)


# Create income categorical variables
brfss$INCOME3 <- brfss$INCOME2
# Baseline category: 9 = Don't know or Refused
brfss$INCOME3[brfss$INCOME2 >=77] <- 9

table(brfss$INCOME2, brfss$INCOME3)

# Create dummies for each income group
brfss$INC1 <- 0
brfss$INC2 <- 0
brfss$INC3 <- 0
brfss$INC4 <- 0
brfss$INC5 <- 0
brfss$INC6 <- 0
brfss$INC7 <- 0

# <$10k
brfss$INC1[brfss$INCOME3 == 1] <- 1
table(brfss$INC1, brfss$INCOME3)

# <$15k
brfss$INC2[brfss$INCOME3 == 2] <- 1
table(brfss$INC2, brfss$INCOME3)

# <$20
brfss$INC3[brfss$INCOME3 == 3] <- 1
table(brfss$INC3, brfss$INCOME3)

# <$25
brfss$INC4[brfss$INCOME3 == 4] <- 1
table(brfss$INC4, brfss$INCOME3)

# <$35
brfss$INC5[brfss$INCOME3 == 5] <- 1
table(brfss$INC5, brfss$INCOME3)

# <$50
brfss$INC6[brfss$INCOME3 == 6] <- 1
table(brfss$INC6, brfss$INCOME3)
# <$75
brfss$INC7[brfss$INCOME3 == 7] <- 1
table(brfss$INC7, brfss$INCOME3)

# Create BMI categorical variables
# Basline category: 9 = Missing
brfss$BMICAT<- 9
# 1 = Underweight
brfss$BMICAT[brfss$X_BMI5CAT ==1] <- 1
# 2 = Normal
brfss$BMICAT[brfss$X_BMI5CAT ==2] <- 2
# 3 = Overweight
brfss$BMICAT[brfss$X_BMI5CAT ==3] <- 3
# 4 = Obese
brfss$BMICAT[brfss$X_BMI5CAT ==4] <- 4

table(brfss$BMICAT, brfss$X_BMI5CAT)

# Create dummies
brfss$UNDWT <- 0
brfss$OVWT <- 0
brfss$OBESE <- 0

brfss$UNDWT[brfss$BMICAT== 1] <- 1
table(brfss$UNDWT, brfss$BMICAT)

brfss$OVWT[brfss$BMICAT== 3] <- 1
table(brfss$OVWT, brfss$BMICAT)

brfss$OBESE[brfss$BMICAT== 4] <- 1
table(brfss$OBESE, brfss$BMICAT)


# Create exercise categorical variables
brfss$EXERANY3<- 9
brfss$EXERANY3[brfss$EXERANY2 ==1] <- 1
brfss$EXERANY3[brfss$EXERANY2 ==2] <- 2

table(brfss$EXERANY3, brfss$EXERANY2)

brfss$NOEXER <- 0
brfss$NOEXER[brfss$EXERANY3 ==2] <- 1
table(brfss$NOEXER, brfss$EXERANY3)

# Drop all NAs in the dataset
brfss_final <- na.omit(brfss)

# Check the data frame
dim(brfss_final)

# Write the clean dataset into csv file
write.csv(brfss_final, file="data/brfss_clean.csv")

