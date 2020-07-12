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

### Regression Analysis ###

# Read in brfss table
brfss <- read.csv(file="data/brfss_clean.csv", header=TRUE, sep=",")

# Normal probability plot
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


## Fitting the Linear Regression Model
# Linear Regression Model (Forward Stepwise)
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
write.csv(Tidy_Model2, file = "data/LinearRegressionModel2.csv")

