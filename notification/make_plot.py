from datetime import datetime, timedelta
from csv import reader
# import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.ticker import AutoMinorLocator

col_names=["天気","気温","降水確率","降水量","湿度","風方向","風速"]
tags = []

def read_data(in_file):
   # read csv file and convert strings to numbers
   new_data = []
   with open(in_file,newline='',encoding='utf8') as inFile:
      data = reader(inFile,delimiter=',')
      """if "#" in data:
         print(data)
         tags.append(data.split()[1])
      else:"""
      for row in data:
         new_row = []
         for elm in row:
            if elm.isnumeric():
               elm = int(elm)
            elif "." in elm:
               elm = float(elm)
            if elm == "---":
               elm = 0
            new_row.append(elm)
         new_data.append(new_row)
   return new_data

def x_hours(x):
   return x

def x_date_hours(x):
   # convert datetime to integer: 
   # (2024,01,20,03,0) -> 2024012003
   return 1000000*x.year + 10000*x.month + 10*x.day + x.hours

thisData = read_data("../../../Downloads/get_tenki_today.csv")
print(thisData)
thatData = read_data("../../../Downloads/get_tenki_tomorrow.csv")
# run two loops and append contents of one to the other respectively
kdx =0
for atem in thisData:
   idx = 0
   for jdx in range(kdx,len(thatData)):
       for elm in thatData[jdx]:
           if idx <= len(thatData[jdx]):
               atem.append(elm)
           idx+=1
       if idx == len(thatData[jdx]):
           break
   kdx +=1

# print(thisData)
update_time = []
for heure in range(1,len(thisData[0])+1):
   update_time.append(heure)

# create two arrays with datetimes
heute = datetime.now()
zoey = datetime(heute.year,heute.month,heute.day)
dates = [zoey + timedelta(hours=k) for k in range(24)]
aux = [zoey + timedelta(1,hours=k) for k in range(24)]
for item in aux:
   dates.append(item)
# print(dates)
# print(len(update_time),len(thisData[0]))
# transpose data
# transData=[[row[i] for row in thisData] for i in range(24)]
# print(transData[0])

xlbl = []
# convert cjk chars to unicode
for x in thisData[0]:
   if x == "晴れ":
       xlbl.append(u"\u2600")
   elif x == "曇り":
       xlbl.append(u"\u2601")
   else:
       xlbl.append(u"\u2614")
# aux = [u"\u2600" if x == "晴れ" else u"\u2601" for x in thisData[0]]
print(xlbl)
#\u2614 umbrella \u263c sun

# _,axes = plt.subplots(layout='constrained')
# Not avail on py3.7 plt.subplots(layout='constrained')
axes = plt.subplot(212)
# axes.scatter(update_time,thisData[1],marker='^')
axes.plot(dates,thisData[1])
axes.set_ylabel('temp[C]')
# axes.set_xticks(update_time,labels=xlbl)
axes2 = plt.subplot(211,sharex=axes)
axes2.plot(dates,thisData[2])
axes2.tick_params('x', labelbottom=False)
axes2.set_ylabel('rainProb[%]')
# sec_ax = axes2.secondary_xaxis('top',functions=(x_hours,x_hours))
# sec_ax.set_xticks(dates,labels=xlbl)

#plt.xticks(rotation=45)
plt.show()
# plt.savefig(r"D:/data/get_tenki_today.png")

"""
bug: index array was added to weather string,e.g. 晴れ.1  
df = pd.read_csv(r"D:/dlopez/data/get_tenki_today.csv")
df1 = df.T
df2 = pd.concat([pd.DataFrame([i],columns=['time']) for i in range(1,25)])
df1.append(df2)
"""

