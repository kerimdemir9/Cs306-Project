#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import mysql.connector
import warnings
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


# In[2]:


warnings.filterwarnings('ignore', category=UserWarning, message='pandas only support SQLAlchemy connectable')
def connectionCreator():
    passwordz=input("Please enter your mysql password: ")
    try:
        cnx = mysql.connector.connect(user="root", password=passwordz, database="berk")
        print("Connection established with the database")
        return cnx
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
        return None
    else:
        cnx.close()
        return None


# In[3]:


mydb=connectionCreator()
query='SELECT * FROM average_deaths_by_year'
df=pd.read_sql(query,con=mydb)
print(df.head())


# In[71]:


def funcvis (plots,dataframe,plot_lib):
    labels=('Outdoor Pollution', 'Unsafe Water', 'Household Air Pollution', 'Air Pollution', 'Unsafe Sanitation')
    colors=('red','blue','green','yellow','hotpink')
    years=(1990,1995,2000,2005,2010,2015,2019)
    for i,ax in enumerate(plots.flatten()):
        if i==7:
            plots.flatten()[-1].axis('off')
            continue#-1 for accessing last subplot in flattened array
        
        rows=dataframe.loc[dataframe['year']==years[i]]
        sizes = [rows['avg_outdoor_pollution'].values[0], rows['avg_unsafe_water'].values[0], 
         rows['avg_household_air_pollution'].values[0], rows['avg_air_pollution'].values[0], 
         rows['avg_unsafe_sanitation'].values[0]]
        ax.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%',textprops={'fontsize': 18}, startangle=0)
        ax.set_title('Average Natural Death Distribution in '+str(years[i]),fontsize=20)
        ax.legend(loc=4,fontsize=12)
    plt.show()


# In[72]:


dt=df
dt['all_nature_deaths_avg'] = dt[['avg_outdoor_pollution', 'avg_unsafe_water', 'avg_household_air_pollution', 
                                  'avg_air_pollution', 'avg_unsafe_sanitation']].sum(axis=1)

dt=dt.drop(['avg_outdoor_pollution', 'avg_unsafe_water', 'avg_household_air_pollution', 'avg_air_pollution', 
            'avg_unsafe_sanitation'], axis=1)
print(dt.head())


# In[73]:


fig, axs = plt.subplots(4, 2,figsize=(30,52))
funcvis(axs,df,plt)


# In[74]:


mydb.close()


# In[ ]:




