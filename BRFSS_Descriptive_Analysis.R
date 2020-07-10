################################################
#########  BRFSS Healthcare Analytics  #########
##########    Discriptive Analysis    ##########
################################################

# Import the libraries
library(gtools)
library(plyr)

# Setting working directory
getwd()
setwd("C:/Users/ ...")


### Descriptive Analysis ###

# Read in brfss_clean table
brfss <- read.csv(file="data/brfss_clean.csv", header=TRUE, sep=",")

## Look at distribution of categorical outcome asthma
AsthmaFreq <- table(brfss$ASTHMA4)
AsthmaFreq
write.csv(AsthmaFreq, file = "AsthmaFreq.csv")

# What proportion of our dataset has ashtma?
PropAsthma <- 1562/15566
PropAsthma

# Look at categorical outcome asthma by exposure, ALCGRP
AsthmaAlcFreq <- table(brfss$ASTHMA4, brfss$ALCGRP)
AsthmaAlcFreq
write.csv(AsthmaAlcFreq, file = "AsthmaAlcFreq.csv")


## Look at distribution of sleep duration 
#summary statistics
summary(brfss$SLEPTIM2)

# Create a histogram and a box plot of total file
hist(brfss$SLEPTIM2, 
     main = "Histogram of SLEPTIM2",
     xlab = "Class SLEPTIM2",
     ylab = "Frequency",
     xlim=c(0,15), 
     ylim=c(0,5500),
     border = "black",
     col= "blue",
     las = 1,
     breaks = 24)

boxplot(brfss$SLEPTIM2, main="Box Plot of SLEPTIM2", 
        xlab="Total File", ylab="SLEPTIM2")

# Create box plots of groups next to each other
boxplot(SLEPTIM2~ALCGRP, data=brfss,
        main="Box Plot of SLEPTIM2 by ALCGRP", 
        xlab="ALCGRP", ylab="SLEPTIM2")



### Complete the Frequency Table ###

## Calculate the frequence for the Categorical Table
# Use macro calculation for overall frequency
FreqTbl <- defmacro(OutputTable, InputVar, CSVTable, 
                    expr={
                            OutputTable <- table(InputVar);
                            write.csv(OutputTable, file = paste0(CSVTable, ".csv"))
                    })

FreqTbl (AlcFreq, brfss$ALCGRP, "Alc")
FreqTbl (AgeFreq, brfss$X_AGE_G, "Age")
FreqTbl (SexFreq, brfss$SEX, "Sex")
FreqTbl (HispFreq, brfss$X_HISPANC, "Hisp")
FreqTbl (RaceFreq, brfss$RACEGRP, "Race")
FreqTbl (MaritalFreq, brfss$MARGRP, "Mar")
FreqTbl (EdFreq, brfss$EDGROUP, "Ed")
FreqTbl (IncFreq, brfss$INCOME3, "Inc")
FreqTbl (BMIFreq, brfss$BMICAT, "BMI")
FreqTbl (SmokeFreq, brfss$SMOKGRP, "Smok")
FreqTbl (ExerFreq, brfss$EXERANY3, "Exer")
FreqTbl (HlthPlanFreq, brfss$HLTHPLN2, "HlthPln")
FreqTbl (GenHlthFreq, brfss$GENHLTH2, "GenHlth")


# Subset dataset with only asthma people
asthmaonly <- subset(brfss, ASTHMA4 == 1)
table(asthmaonly$ASTHMA4)
nrow(asthmaonly)

AsthmaFreq <- table(asthmaonly$ASTHMA4)
AsthmaFreq
write.csv(AsthmaFreq, file = "Asthma.csv")

# Use macro calculation for only asthma frequency
FreqTbl (AlcGrpFreq, asthmaonly$ALCGRP, "Alc")
FreqTbl (AgeGrpFreq, asthmaonly$X_AGE_G, "Age")
FreqTbl (SexFreq, asthmaonly$SEX, "Sex")
FreqTbl (HispFreq, asthmaonly$X_HISPANC, "Hisp")
FreqTbl (RaceFreq, asthmaonly$RACEGRP, "Race")
FreqTbl (MaritalFreq, asthmaonly$MARGRP, "Mar")
FreqTbl (EdFreq, asthmaonly$EDGROUP, "Ed")
FreqTbl (IncFreq, asthmaonly$INCOME3, "Inc")
FreqTbl (BMIFreq, asthmaonly$BMICAT, "BMI")
FreqTbl (SmokeFreq, asthmaonly$SMOKGRP, "Smok")
FreqTbl (ExerFreq, asthmaonly$EXERANY3, "Exer")
FreqTbl (HlthPlanFreq, asthmaonly$HLTHPLN2, "HlthPln")
FreqTbl (GenHlthFreq, asthmaonly$GENHLTH2, "GenHlth")


# Subset dataset with no asthma
noasthmaonly <- subset(brfss, ASTHMA4 != 1)
table(noasthmaonly $ASTHMA4)
nrow(noasthmaonly)

AsthmaFreq <- table(noasthmaonly$ASTHMA4)
AsthmaFreq
write.csv(AsthmaFreq, file = "Asthma.csv")

# Use macro calculation for no asthma frequency
FreqTbl (AlcGrpFreq, noasthmaonly$ALCGRP, "Alc")
FreqTbl (AgeGrpFreq, noasthmaonly$X_AGE_G, "Age")
FreqTbl (SexFreq, noasthmaonly$SEX, "Sex")
FreqTbl (HispFreq, noasthmaonly$X_HISPANC, "Hisp")
FreqTbl (RaceFreq, noasthmaonly$RACEGRP, "Race")
FreqTbl (MaritalFreq, noasthmaonly$MARGRP, "Mar")
FreqTbl (EdFreq, noasthmaonly$EDGROUP, "Ed")
FreqTbl (IncFreq, noasthmaonly$INCOME3, "Inc")
FreqTbl (BMIFreq, noasthmaonly$BMICAT, "BMI")
FreqTbl (SmokeFreq, noasthmaonly$SMOKGRP, "Smok")
FreqTbl (ExerFreq, noasthmaonly$EXERANY3, "Exer")
FreqTbl (HlthPlanFreq, noasthmaonly$HLTHPLN2, "HlthPln")
FreqTbl (GenHlthFreq, noasthmaonly$GENHLTH2, "GenHlth")


## Calculate the Mean and SD for the Continuous Table
# Calculate the Mean and SD for SLEPTIM2
mean(brfss$SLEPTIM2)
sd(brfss$SLEPTIM2)

# Example using the ddply function to calculate mean and SD for differnet level
ddply(brfss,~ALCGRP,summarise,mean=mean(SLEPTIM2),sd=sd(SLEPTIM2))

# Use marco to calculate mean and SD for all category levels
SumTbl <- defmacro(OutputTable, GroupVar, CSVTable,
                   expr={
                           OutputTable <- ddply(brfss,~GroupVar,summarise,mean=mean(SLEPTIM2),sd=sd(SLEPTIM2));
                           write.csv(OutputTable, file = paste0(CSVTable, ".csv"))
                   })

# Use macro calculation for mean and SD
SumTbl (AlcGrpSum, brfss$ALCGRP, "Alc")
SumTbl (AgeGrpSum, brfss$X_AGE_G, "Age")
SumTbl (SexSum, brfss$SEX, "Sex")
SumTbl (HispSum, brfss$X_HISPANC, "Hisp")
SumTbl (RaceSum, brfss$RACEGRP, "Race")
SumTbl (MaritalSum, brfss$MARGRP, "Mar")
SumTbl (EdSum, brfss$EDGROUP, "Ed")
SumTbl (IncSum, brfss$INCOME3, "Inc")
SumTbl (BMISum, brfss$BMICAT, "BMI")
SumTbl (SmokeSum, brfss$SMOKGRP, "Smok")
SumTbl (ExerSum, brfss$EXERANY3, "Exer")
SumTbl (HlthPlanSum, brfss$HLTHPLN2, "HlthPln")
SumTbl (GenHlthSum, brfss$GENHLTH2, "GenHlth")
SumTbl (AsthmaSum, brfss$ASTHMA4, "Asthma")


### Bivariate Tests ###

# Load MASS library
library(MASS)

## Chi-Square Test:

# Create a table for frequency count of Asthma in each ALCGRP
AlcTbl = table(brfss$ASTHMA4, brfss$ALCGRP) 
AlcTbl

# Run the Chi-Square test
chisq.test(AlcTbl)  

# Create a marco to run the test for different variables
ChiTest <- defmacro(VarName, TblName, expr={
        TblName = table(brfss$ASTHMA4, brfss$VarName); 
        chisq.test(TblName)})

ChiTest(ALCGRP, AlcTbl)
ChiTest(X_AGE_G, AgeTbl)
ChiTest(SEX, SexTbl)
ChiTest(X_HISPANC, HispTbl)
ChiTest(RACEGRP, RaceTbl)
ChiTest(MARGRP, MarTbl)
ChiTest(EDGROUP, EdTbl)
ChiTest(INCOME3, IncTbl)
ChiTest(BMICAT, BMITbl)
ChiTest(SMOKGRP, SmokTbl)
ChiTest(EXERANY3, ExerTbl)
ChiTest(HLTHPLN2, HlthPlnTbl)
ChiTest(GENHLTH2, GenHlthTbl)


## ANOVA Test:

# Run an ANOVA for SLEPTIM2 and ALCGRP
AlcANOVA <- lm(formula = SLEPTIM2 ~ ALCGRP, data = brfss)
summary(AlcANOVA)

# Use the marco calculation for other variables
ANOVATest <- defmacro(VarName, TblName, expr={
        TblName<- lm(formula = SLEPTIM2 ~ VarName, data = brfss);
        summary(TblName)})

ANOVATest (ALCGRP, AlcANOVA)
ANOVATest (X_AGE_G, AgeANOVA)
ANOVATest (X_HISPANC, HispANOVA)
ANOVATest (RACEGRP, RaceANOVA)
ANOVATest (MARGRP, MarANOVA)
ANOVATest (EDGROUP, EdANOVA)
ANOVATest (INCOME3, IncANOVA)
ANOVATest (BMICAT, BMIANOVA)
ANOVATest (SMOKGRP, SmokANOVA)
ANOVATest (EXERANY3, ExerANOVA)
ANOVATest (HLTHPLN2, HlthPlnANOVA)
ANOVATest (GENHLTH2, GenHlthANOVA)


## Independent T test:

# ttests for Asthma and Sex on SLEPTIM2
t.test(brfss$SLEPTIM2~brfss$ASTHMA4)
t.test(brfss$SLEPTIM2~brfss$SEX)
