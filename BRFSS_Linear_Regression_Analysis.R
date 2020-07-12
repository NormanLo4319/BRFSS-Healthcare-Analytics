################################################
#########  BRFSS Healthcare Analytics  #########
#########      Regression Analysis    ##########
################################################

# Import the dependencies
library (devtools)
library (broom)

# Setting working directory
getwd()
setwd("C:/Users/ ...")

# Read in brfss table
brfss <- read.csv(file="data/brfss_clean.csv", header=TRUE, sep=",")


### Outcome Variable ###

## Normal probability plot
# Make linear model using grouping variable
AlcSleepTimeRegression <- lm(SLEPTIM2 ~ ALCGRP, data=brfss) 
AlcSleepTimeRegression 
summary(AlcSleepTimeRegression)

# Make diagnostic plots
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(AlcSleepTimeRegression, 
     main = "Alcohol by Sleep Duration")


## Feature Engineering

# 1 - Categorization
# Before making any transformation, let's check the summary of the continuous outcome SLEPTIM2
summary(brfss$SLEPTIM2)

# Look at the distribution of SLEPTIM2
hist(brfss$SLEPTIM2, 
     main = "Histogram of SLEPTIM2",
     xlab = "Class SLEPTIM2",
     ylab = "Frequency",
     xlim=c(0,15), 
     ylim=c(0,6000),
     border = "red",
     col= "yellow",
     las = 1,
     breaks = 24)

# Categorize at median
brfss$SLEEPCAT <- 9
brfss$SLEEPCAT[brfss$SLEPTIM2 >7] <- 1
brfss$SLEEPCAT[brfss$SLEPTIM2 <=7] <- 2

# Create table for 
table(brfss$SLEEPCAT, brfss$SLEPTIM2)


# 2 - Log transformation
brfss$LOGSLEEP <- log(brfss$SLEPTIM2)
summary(brfss$LOGSLEEP)

# Plote the log transformation variable
hist(brfss$LOGSLEEP, 
     main = "Histogram of LOGSLEEP",
     xlab = "Class LOGSLEEP",
     ylab = "Frequency",
     xlim=c(0,4), 
     ylim=c(0,35000),
     border = "red",
     col= "yellow",
     las = 1,
     breaks = 5)


# 3 - Quartiles Strategy

# Divide the SLEPTIM2 variable into 4 categories
SLEEPQuantiles <- quantile(brfss$SLEPTIM2)
SLEEPQuantiles

brfss$SLEPQUART <- 9
brfss$SLEPQUART[brfss$SLEPTIM2 <= 6] <- 1
brfss$SLEPQUART[brfss$SLEPTIM2 >6 & brfss$SLEPTIM2 <=7] <- 2
brfss$SLEPQUART[brfss$SLEPTIM2 >7 & brfss$SLEPTIM2 <=8] <- 3
brfss$SLEPQUART[brfss$SLEPTIM2 >8] <- 4

table(brfss$SLEPQUART, brfss$SLEPTIM2)


# 4 - Ranking Approach

# Creating the rank for SLEPTIM2
# First order the SLEPTIM2 in the data frame
order.sleeptime <- order(-brfss$SLEPTIM2)

# Assign the ordered SLEPRANK to the data frame
brfss$SLEPRANK <- brfss[order.sleeptime,]

# Rank the SLEPTIM2
brfss$SLEPRANK <- rank(brfss$SLEPTIM2)

# Check the new rank variable
head(brfss[,c("SLEPRANK","SLEPTIM2")], n=25)
tail(brfss[,c("SLEPRANK","SLEPTIM2")], n=25)


### Linear Regression Model ###

# Note: Our dependent variable or outcome variable is SLEPTIM2

# Model 1
Model1 = lm(SLEPTIM2 ~ DRKMONTHLY + DRKWEEKLY, data=brfss) 

# Summary of the model
summary(Model1)

# Export the summary report to CSV file
Tidy_Model1 <- tidy(Model1)
write.csv(Tidy_Model1, file="data/LinearRegressionModel1.csv")


# Model 2
Model2 = lm(SLEPTIM2 ~ DRKMONTHLY + DRKWEEKLY + MALE + AGE2 + AGE3 + AGE4 + AGE5 + AGE6, data=brfss) 

# Summary of the model
summary(Model2) 

# Export the summary report to CSV file
Tidy_Model2 <- tidy(Model2)
write.csv(Tidy_Model2, file="data/LinearRegressionModel2.csv")


# Model 3 
# Forward stepwise for model selection

# Start with Model 2 with the not significant covariates removed
Model3 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6, data=brfss) 
summary(Model3) 

# Add smoker
Model4 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
            + SMOKER, data=brfss) 
summary(Model4) 
# Smoker is significant

# Add Hispanic
Model5 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
            + SMOKER + HISPANIC, data=brfss) 
summary(Model5) 
# Hispanic significant

# Add race
Model6 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
            + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE, data=brfss) 
summary(Model6) 
# Race vars significant

# Marital status
Model7 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
            + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR, data=brfss) 
summary(Model7)
# Marital significant

# Add general health
Model8 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
            + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
            + FAIRHLTH + POORHLTH, data=brfss) 
summary(Model8)
# General Health significant

# Health plan
Model9 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
            + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
            + FAIRHLTH + POORHLTH + NOPLAN, data=brfss) 
summary(Model9)
# Health plan is not significant, take out NOPLAN

# Add education levels
Model10 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + LOWED + SOMECOLL, data=brfss) 
summary(Model10)
# LOWED is not significant, take out LOWED

# somecol is significant, so Keep Some college
Model11 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL, data=brfss) 
summary(Model11)

# Add income
Model12 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC1 + INC2 + INC3 + INC4 + INC5 + INC6 + INC7, data=brfss) 
summary(Model12)
# remove insignificant income variables
Model13 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7, data=brfss) 
summary(Model13)
# Only INC2 and INC7 are significant

# Add BMI
Model14 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + UNDWT + OVWT + OBESE, data=brfss) 
summary(Model14)

# take out insignificant UNDWT
Model15 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE, data=brfss) 
summary(Model15)

# Add exercise
Model16 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + NOEXER, data=brfss) 
summary(Model16)
# Take out noexer

# Add back male
Model17 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + MALE, data=brfss) 
summary(Model17)
# Take out male

# Add back AGE2 and AGE3
Model18 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE2 + AGE3, data=brfss) 
summary(Model18)
# Remove AGE2

Model19 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3, data=brfss) 
summary(Model19)
# keep only AGE3

# Add back UNDWT
Model20 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + UNDWT, data=brfss) 
summary(Model20)
# Still insignificant, remove UNDWT

# Add back LOWED
Model21 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED, data=brfss) 
summary(Model21)
# Model21 is working final model

# Add back NOEXER
Model22 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + NOEXER, data=brfss) 
summary(Model22)
# Screws up LOWED
# Remove NOEXER

# Add back NOPLAN
Model23 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + NOPLAN, data=brfss) 
summary(Model23)
# Remove NOPLAN

# Add back AGE2
Model24 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + AGE2, data=brfss) 
summary(Model24)
# Remove AGE2

# Add back INC1
Model25 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + INC1, data=brfss) 
summary(Model25)
# Remove INC1

#Add back INC3
Model26 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + INC3, data=brfss) 
summary(Model26)
# Remove INC3

# Add back INC4
Model27 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + INC4, data=brfss) 
summary(Model27)
# Remove INC4

# Add back INC5
Model28 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + INC5, data=brfss) 
summary(Model28)
# Remove INC5

# Add back INC6
Model29 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + INC6, data=brfss) 
summary(Model29)
# Remove INC6

# Add back MALE
Model30 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + AGE3 + LOWED + MALE, data=brfss) 
summary(Model30)

Model31 = lm(SLEPTIM2 ~ DRKWEEKLY + AGE3 + AGE4 + AGE5 + AGE6 
             + SMOKER + HISPANIC + BLACK + ASIAN + OTHRACE + NEVERMAR + FORMERMAR
             + FAIRHLTH + POORHLTH + LOWED + SOMECOLL
             + INC2 + INC7 + OVWT + OBESE + DRKMONTHLY, data=brfss) 
summary(Model31)

### FINAL MODEL
FinalLinearRegressionModel = lm(SLEPTIM2 ~ DRKMONTHLY + DRKWEEKLY + AGE3 + AGE4 + AGE5 + AGE6 
                                + HISPANIC + BLACK + ASIAN + OTHRACE + FORMERMAR + NEVERMAR
                                + LOWED + SOMECOLL + INC2 + INC7 
                                + OVWT + OBESE + SMOKER + FAIRHLTH + POORHLTH, data=brfss) 
summary(FinalLinearRegressionModel)

# Output as CSV
Tidy_FinalModel <- tidy(FinalLinearRegressionModel)
write.csv(Tidy_FinalModel, file="data/FinalLinearRegressionModel.csv")

# Coefficient plot
library(arm)

# Default plot
coefplot(FinalLinearRegressionModel)

# Final model diagnostics
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(FinalLinearRegressionModel, 
     main = "Final Linear Regression Model")

# Model fit diagnostics
library(gvlma)
gvmodel <- gvlma(FinalLinearRegressionModel) 
summary(gvmodel)