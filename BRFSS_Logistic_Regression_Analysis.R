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

### Logistic Regression ###

# Model 1
LogModel1 <- glm(ASTHMA4 ~ DRKMONTHLY + DRKWEEKLY, data=brfss, family = "binomial") 
summary(LogModel1)

# Save as tidy summary
Tidy_LogModel1 <- tidy(LogModel1)
Tidy_LogModel1

# Add calculations
Tidy_LogModel1$OR <- exp(Tidy_LogModel1$estimate)
Tidy_LogModel1$LL <- exp(Tidy_LogModel1$estimate - (1.96 * Tidy_LogModel1$std.error))
Tidy_LogModel1$UL <- exp(Tidy_LogModel1$estimate + (1.96 * Tidy_LogModel1$std.error))
Tidy_LogModel1

# Export the summary table
write.csv(Tidy_LogModel1, file = "data/LogisticRegressionModel1.csv")


# Model 2
LogModel2 <- glm(ASTHMA4 ~ DRKMONTHLY + DRKWEEKLY + MALE + AGE2 + AGE3 + AGE4 + AGE5 + AGE6, data=brfss, family = "binomial") 
summary(LogModel2) 

# Add calculations
Tidy_LogModel2 <- tidy(LogModel2)
Tidy_LogModel2$OR <- exp(Tidy_LogModel2$estimate)
Tidy_LogModel2$LL <- exp(Tidy_LogModel2$estimate - (1.96 * Tidy_LogModel2$std.error))
Tidy_LogModel2$UL <- exp(Tidy_LogModel2$estimate + (1.96 * Tidy_LogModel2$std.error))

# Export the summary table
write.csv(Tidy_LogModel2, file = "data/LogisticRegressionModel2.csv")


# Model 3 
# Forward stepwise for model selection

# All variables are significant in model 2
LogModel3 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE, data=brfss, family = "binomial") 
summary(LogModel3)

# Add smoker
LogModel4 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER, data=brfss, family = "binomial") 
summary(LogModel4)
# Keep smoker

# Add Hispanic
LogModel5 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER + HISPANIC, data=brfss, family = "binomial") 
summary(LogModel5)
# Remove Hispanic

#Add races
LogModel6 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                 + BLACK + ASIAN + OTHRACE, data=brfss, family = "binomial") 
summary(LogModel6)

# Keep only OTHRACE
LogModel7 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                 + OTHRACE, data=brfss, family = "binomial") 
summary(LogModel7)

# Add marital
LogModel8 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                 + OTHRACE + NEVERMAR + FORMERMAR, data=brfss, family = "binomial") 
summary(LogModel8)
# Keep marital

# Add generalhealth
LogModel9 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                 + OTHRACE + NEVERMAR + FORMERMAR + FAIRHLTH + POORHLTH, data=brfss, family = "binomial") 
summary(LogModel9)

# FORMERMAR not significant, take out FORMERMAR
LogModel10 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH, data=brfss, family = "binomial") 
summary(LogModel10)

# Add health plan
LogModel11 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH + NOPLAN, data=brfss, family = "binomial") 
summary(LogModel11)
# Take out health plan

# Add education
LogModel12 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + LOWED + SOMECOLL, data=brfss, family = "binomial") 
summary(LogModel12)
# Take out education

# Add income
LogModel13 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4 + INC5 + INC6 + INC7, data=brfss, family = "binomial") 
summary(LogModel13)

# Take out INC5 through INC7
LogModel14 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE + SMOKER 
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4, data=brfss, family = "binomial") 
summary(LogModel14)

# Take out SMOKER
LogModel15 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4, data=brfss, family = "binomial") 
summary(LogModel15)

# Add obesity
LogModel16 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + UNDWT + OVWT + OBESE, data=brfss, family = "binomial") 
summary(LogModel16)

# Remove UNDWT
LogModel17 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OVWT + OBESE, data=brfss, family = "binomial") 
summary(LogModel17)

# Remove OVWT
LogModel18 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE, data=brfss, family = "binomial") 
summary(LogModel18)

# Add exercise
LogModel19 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER, data=brfss, family = "binomial") 
summary(LogModel19)

# Add back DRKMONTHLY
LogModel20 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY, data=brfss, family = "binomial") 
summary(LogModel20)
# MODEL20 is CANDIDATE FINAL MODEL

# Try to add back SMOKER
LogModel21 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER, data=brfss, family = "binomial") 
summary(LogModel21)
# Almost significant, keep.

# Add back HISPANIC
LogModel22 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + HISPANIC, data=brfss, family = "binomial") 
summary(LogModel22)
# Remove HISPANIC

# Add back BLACK
LogModel23 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + BLACK, data=brfss, family = "binomial") 
summary(LogModel23)
# Remove BLACK

# Add back ASIAN
LogModel24 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + ASIAN, data=brfss, family = "binomial") 
summary(LogModel24)
# Remove ASIAN

# Add back LOWED
LogModel25 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED, data=brfss, family = "binomial") 
summary(LogModel25)
# Keep LOWED

# Add back SOMECOLL
LogModel26 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + SOMECOLL, data=brfss, family = "binomial") 
summary(LogModel26)
# Remove SOMECOLL

# Add back INC5
LogModel27 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + INC5, data=brfss, family = "binomial") 
summary(LogModel27)
# Remove INC5

# Add back INC6
LogModel28 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + INC6, data=brfss, family = "binomial") 
summary(LogModel28)
# Remove INC6

# Add back INC7
LogModel29 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + INC7, data=brfss, family = "binomial") 
summary(LogModel29)
# Remove INC7

# Add back FORMERMAR
LogModel30 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + FORMERMAR, data=brfss, family = "binomial") 
summary(LogModel30)
# Remove FORMERMAR

# Add back NOPLAN
LogModel31 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + NOPLAN, data=brfss, family = "binomial") 
summary(LogModel31)
# Remove FORMERMAR

# Add back UNDWT
LogModel32 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + UNDWT, data=brfss, family = "binomial") 
summary(LogModel32)
# Remove UNDWT

# Add back OVWT
LogModel33 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT, data=brfss, family = "binomial") 
summary(LogModel33)

# Add back AGE2
LogModel34 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2, data=brfss, family = "binomial") 
summary(LogModel34)

# Add back AGE3
LogModel35 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE3, data=brfss, family = "binomial") 
summary(LogModel35)
# Remove AGE3

# Add back AGE4
LogModel36 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE4, data=brfss, family = "binomial") 
summary(LogModel36)
# Remove AGE4

#Add back AGE5
LogModel37 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5, data=brfss, family = "binomial") 
summary(LogModel37)

# Add back AGE6
LogModel38 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + AGE6, data=brfss, family = "binomial") 
summary(LogModel38)
# Remove AGE6

# Add back HISPANIC
LogModel39 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + HISPANIC, data=brfss, family = "binomial") 
summary(LogModel39)
# Remove HISPANIC

# Add back SOMECOLL
LogModel40 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + SOMECOLL, data=brfss, family = "binomial") 
summary(LogModel40)
# Remove SOMECOLL

# Add back UNDWT
LogModel41 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + UNDWT, data=brfss, family = "binomial") 
summary(LogModel41)
# Remove UNDWT

# Add back health plan
LogModel42 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + NOPLAN, data=brfss, family = "binomial") 
summary(LogModel42)
# Remove NOPLAN

# Add back INC5
LogModel43 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + INC5, data=brfss, family = "binomial") 
summary(LogModel43)
# Remove INC5

# Add back INC6
LogModel44 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + INC6, data=brfss, family = "binomial") 
summary(LogModel44)
# Remove INC6

# Add back INC7
LogModel45 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + INC7, data=brfss, family = "binomial") 
summary(LogModel45)
# Remove INC7

# Add back BLACK
LogModel46 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + BLACK, data=brfss, family = "binomial") 
summary(LogModel46)
# Remove BLACK

# Add back ASIAN
LogModel47 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + ASIAN, data=brfss, family = "binomial") 
summary(LogModel47)
# Remove ASIAN

# Add back FORMERMAR
LogModel48 <- glm(ASTHMA4 ~ DRKWEEKLY + MALE
                  + OTHRACE + NEVERMAR + FAIRHLTH + POORHLTH
                  + INC1 + INC2 + INC3 + INC4
                  + OBESE + NOEXER + DRKMONTHLY + SMOKER
                  + LOWED + OVWT + AGE2 + AGE5 + FORMERMAR, data=brfss, family = "binomial") 
summary(LogModel48)

#FINAL MODEL
#arrange covariates in order of table 1
FinalLogisticRegressionModel <- glm(ASTHMA4 ~ DRKMONTHLY + DRKWEEKLY 
                                    + AGE2 + AGE5 + MALE
                                    + OTHRACE + NEVERMAR + LOWED 
                                    + INC1 + INC2 + INC3 + INC4
                                    + OVWT + OBESE + SMOKER 
                                    + NOEXER + FAIRHLTH + POORHLTH, data=brfss, family = "binomial") 
summary(FinalLogisticRegressionModel)

# Write out CSV of final model
Tidy_LogModel_a <- tidy(FinalLogisticRegressionModel)
Tidy_LogModel3 <- subset(Tidy_LogModel_a, term != "(Intercept)")

# Add calculations
Tidy_LogModel3$OR <- exp(Tidy_LogModel3$estimate)
Tidy_LogModel3$LL <- exp(Tidy_LogModel3$estimate - (1.96 * Tidy_LogModel3$std.error))
Tidy_LogModel3$UL <- exp(Tidy_LogModel3$estimate + (1.96 * Tidy_LogModel3$std.error))

# Export the summary as CSV file
write.csv(Tidy_LogModel3, file = "data/LogisticRegressionModel3.csv")

#visualize to help interpretation
library(ggplot2)

ggplot(Tidy_LogModel3, 
       aes(x = term, y = OR, ymin = LL, ymax = UL)) + 
  geom_pointrange(aes(col = factor(term)), 
                  position=position_dodge(width=0.30)) + 
  ylab("Odds ratio & 95% CI") + 
  geom_hline(aes(yintercept = 1)) + 
  scale_color_discrete(name = "Term") + 
  xlab("") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))