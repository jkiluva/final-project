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
# Conclusion: Looks like Personal Growth, Humor, Health & Fitness were the top 3 and where most of the data is.

t.test <- t.test(Gendergroup$CategoryR,Gendergroup$GenderR, alternative = "two.sided", var.equal=FALSE)
print(t.test)

#p-value = 7.331e-06