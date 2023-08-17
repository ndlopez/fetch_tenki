#reading output file from get_tenki.py
from datetime import date, timedelta
import pandas as pd

col_names=["時刻","天気","気温","降水確率","降水量","湿度","風速"]
df = pd.read_csv('data/get_tenki.csv',comment='#') #header=None doesn't WORK
#the following line will delete the 0..6 indexing
df.set_index(['時刻'],inplace=True)
heute=date.today()
df_tr = df.T
#df_tr = df_tr.replace('---',0) #SED already cleaned it
print("Weather for:",heute)
print(df_tr)
print("Tomorrow's weather")
df2 = pd.read_csv('data/get_tenki2.csv',comment='#')
df2.set_index(['時刻'],inplace=True)

morgen = heute + timedelta(1)
df_tr2 = df2.T
print("Weather for:",morgen)
print(df_tr2)
