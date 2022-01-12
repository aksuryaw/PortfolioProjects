# -*- coding: utf-8 -*-
"""
Created on Wed Dec 29 00:13:33 2021

@author: Abhishek Suryawanshi
"""
import pandas as pd
import numpy as np

# read in dataset

df = pd.read_csv(r"C:\Users\15716\Documents\ffx_home_proj\raw_redfin_data.csv")

df.head()

# dropping columns
df.drop(columns=["Source.Name","NEXT OPEN HOUSE START TIME", "NEXT OPEN HOUSE END TIME",
                 "URL","FAVORITE","INTERESTED","SOURCE","MLS#","STATE OR PROVINCE","STATUS","SALE TYPE",
                 "PROPERTY TYPE"], axis=1,inplace=True)

# renaming columns
df.rename(columns={"SOLD DATE":"DATESOLD","ZIP OR POSTAL CODE":"ZIPCODE", "BEDS":"BEDROOMS",
                   "BATHS":"BATHROOMS","SQUARE FEET":"SQFT","LOT SIZE":"LOTSIZE","YEAR BUILT":"YEARBUILT",
                   "DAYS ON MARKET":"DAYS_ON_MARKET","$/SQUARE FEET":"PRICE_PER_SQFT","HOA/MONTH":"HOA_MONTHLY"}, inplace=True)

# check for duplicates
df.duplicated().sum()

df.loc[df.duplicated(),:]

# remove duplicates
df.drop_duplicates(inplace=True)

# check for NULLs
for col in df.columns:
 pct_missing = np.mean(df[col].isnull())
 print("{} - {}%".format(col, (pct_missing*100)))
 
df.isnull().sum()

# replace NaN values in HOA_MONTHLY column w/ 0's
df.HOA_MONTHLY.fillna(value= 0, inplace=True)

df.dtypes

# convert data types
df["ZIPCODE"] = df["ZIPCODE"].astype(str)
df["DATESOLD"] = pd.to_datetime(df["DATESOLD"])

# age of the house
df["HOUSE_AGE"] = df.YEARBUILT.apply(lambda x: x if x < 1 else 2021 - x)

# create month column
df["MONTH"]= df["DATESOLD"].astype(str).str[5:7]

df.MONTH.unique()

df["MONTH"].replace({"01":"January","02":"February","03":"March","04":"April","05":"May","06":"June","07":"July",
                     "08":"August","09":"September","10":"October","11":"November","12":"December"}, inplace=True)

# HOA column
df["HOA"] = df.HOA_MONTHLY.apply(lambda x: "No" if x < 1 else "Yes")

# rearrange column order
df = df.loc[:, ["ADDRESS","CITY","ZIPCODE","LOCATION","DATESOLD","MONTH","PRICE","BEDROOMS",
           "BATHROOMS","SQFT","LOTSIZE","PRICE_PER_SQFT","HOA","HOA_MONTHLY","YEARBUILT","HOUSE_AGE",
           "DAYS_ON_MARKET","LATITUDE","LONGITUDE"]]

# export cleaned dataframe
df.to_csv("redfin_data_cleaned.csv",index=False)

