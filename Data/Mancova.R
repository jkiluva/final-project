#Load Libraries
library("MASS")
library("rcompanion")
library("mvnormtest")
library("car")
library("psych")
library("effects")
library("multcomp")
library("dplyr")
library(readr)
library(ggplot2)

#Question
## What gender is putting out the most tweets in a specific category?
##Null hypothesis - there is no difference in tweets

#Import Data and View
NYR <- read_csv("New_years_resolutions.csv")

View(NYR)

#preview head data
head(NYR)


##DATA WRANGLING
#Rename columns
NYR <- NYR%>% rename(Date=tweet_created,Tweet=tweet_text,Category=tweet_category,Topics=tweet_topics,Location=tweet_location,State=tweet_state,Region=tweet_region,TZ=user_timezone,Gender=user_gender)
head(NYR)


#Select Data to work with
NYRtrim = select(NYR,Gender,Category)
View(NYRtrim)

#Mutate data
#check class of data
class(NYRtrim$Gender)


#Convert Categorical to Numeric
NYRtrim$GenderR<- NA

NYRtrim$GenderR[NYRtrim$Gender=='male'] <- 0
NYRtrim$GenderR[NYRtrim$Gender=='female'] <- 1
NYRtrim$GenderR

NYRtrim$CategoryR[NYRtrim$Category=='Career'] <- 0
NYRtrim$CategoryR[NYRtrim$Category=='Education/Training'] <- 1
NYRtrim$CategoryR[NYRtrim$Category=='Family/Friends/Relationships'] <- 2
NYRtrim$CategoryR[NYRtrim$Category=='Finance'] <- 3
NYRtrim$CategoryR[NYRtrim$Category=='Health & Fitness'] <- 4
NYRtrim$CategoryR[NYRtrim$Category=='Humor'] <- 5
NYRtrim$CategoryR[NYRtrim$Category=='Personal Growth'] <- 6
NYRtrim$CategoryR[NYRtrim$Category=='Philanthropic'] <- 7
NYRtrim$CategoryR[NYRtrim$Category=='Recreation & Leisure'] <- 8
NYRtrim$CategoryR[NYRtrim$Category=='Time Management/Organization'] <- 9
NYRtrim$CategoryR
View(NYRtrim)

NYRr <- select(NYRtrim, GenderR, CategoryR)

View(NYRr)

#Remove Nulls
NYRr <- na.omit(NYRr) 
#group by Male and Female provide summary of data
Gendergroup <- NYRr %>% group_by(GenderR,CategoryR) %>% summarize(Count = n())
View(Gendergroup)
describe(NYRr$CategoryR)

Gendergroup

#Flip data
NYRF <- t(Gendergroup)
NYRF

##ANALYSIS
#check for normality
plotNormalHistogram(NYRr$CategoryR)
# Conclusion: Looks like Personal Growth, Humor, Health & Fitness were the top 3 and where most of the data is. I will use those to do MANCOVA ANALYSIS.

#MANCOVA analysis
############################################################################################
##NOT NEEDED BUT KEEPING JUST IN CASE
#Create matrix for each gender and category
males = matrix(c(0,0,77,0,1,44,0,2,153,0,3,73,0,4,369,0,5,558,0,6,759,0,7,42,0,8,245,0,9,36), nrow=10, ncol= 3, byrow = TRUE)
males
females = matrix(c(1,0,46,1,1,43,1,2,174,1,3,94,1,4,456,1,5,329,1,6,919,1,7,41,1,8,216,1,9,49), nrow=10, ncol= 3, byrow = TRUE)
females
#bind matrices into a new data set
NYRF <- rbind(males, females)
NYRF
#naming columns
names(NYRF) <- c("Gender", "Covariate", "Frequency")
View(NYRF)
#plotNormalHistogram(NYRr2)
######################################################################################

#Regression Line Anaylsis

outcome = cbind(NYRF$CategoryR, NYRF$GenderR)
outcome

model = manova(outcome ~ GenderR + CategoryR + GenderR* CategoryR, data = Gendergroup)

summary(model, test="Wilks", type = "III")
summary(model, test="Wilks", type = "III")
summary(model, test="Wilks", type = "III")
summary(model, test="Roy", type = "III")
