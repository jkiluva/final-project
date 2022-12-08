#!/usr/bin/env python
# coding: utf-8

# In[44]:


import pandas as pd
import numpy as np
import scipy
from scipy import stats


# In[45]:


NYR=pd.read_csv("C:/Users/Megan/Documents/data science/Data-Science-Program/DS110-Final Project/New_years_resolutions.csv")


# In[46]:


NYR.rename(columns={'tweet_created' : 'Date', 'tweet_text' : 'Tweet', 'tweet_category' : 'Category', 'tweet_topics' : 'Topics', 'tweet_location' : 'Location', 'tweet_state' : 'State', 'tweet_region' : 'Region', 'user_timezone' : 'TZ', 'user_gender' : 'Gender'}, inplace=True)


# In[47]:


NYR.head()


# In[48]:


NYRtrim = NYR.drop(['Location', 'retweet_count', 'TZ', 'Location'], axis=1)


# In[49]:


NYRtrim.head()


# In[50]:


NYRtrim.info()


# In[51]:


from scipy.stats import ttest_ind


# In[52]:


NYRtrim.Category.value_counts()


# In[53]:


## Recoding 


# In[54]:


def recode (series):
    if series == "female":
        return 0
    if series == "male":
        return 1
NYRtrim['GenderR'] = NYRtrim['Gender'].apply(recode)


# In[55]:


def recode (series):
    if series == "Humor":
        return 1
    if series == "Health & Fitness":
        return 2
    if series == "Personal Growth":
        return 3
    if series == "Finance":
        return 4
    if series == "Philanthropic":
        return 5
    if series == "Recreation & Leisure":
        return 6
    if series == "Time Management/Organization":
        return 7
    if series == "Family/Friends/Relationships":
        return 8
    if series == "Career":
        return 9
    if series == "Education/Training":
        return 10
NYRtrim['CategoryR'] = NYRtrim['Category'].apply(recode)


# In[56]:


NYRtrim.head()


# In[57]:


## Independent T-Test


# In[58]:


stats.ttest_ind(NYRtrim["CategoryR"], NYRtrim["GenderR"])

#pvalue is 0.0 so it appears to be a significant difference