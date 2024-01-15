from datetime import datetime, timedelta
import csv

from bs4 import BeautifulSoup
from urllib.request import urlopen
from urllib.error import HTTPError

now = datetime.now()
currHour = now.strftime("%H:%M")
# jiscode = "23109" # Nagoya
jiscode = "23220" # Inazawa
tenki_url = f"https://tenki.jp/forecast/5/26/5110/{jiscode}/1hour.html"
class_list = ["weather","temperature","prob-precip","precipitation","humidity","wind-blow","wind-speed"]
units = [":00 ","","\u2103  防水率","% ","mm 湿度","% ","","m"]
   
def save_data(got_data,out_file):
   with open(out_file,'w',newline='',encoding='utf8') as fp:
       add_data = csv.writer(fp,delimiter=',')
       for item in got_data:
           add_data.writerow(item)

def make_soup(tagID,f_out):
   try:
       source = urlopen(tenki_url)
   except HTTPError as err:
       print("Could not fetch",tenki_url,err.code)

   soup = BeautifulSoup(source.read(),'html.parser')
   tables = soup.find('table',id=tagID)
   all_data = []        

   for classy in class_list:
       aux = ""
       tab_tr=tables.find('tr',class_=classy)
       
       auxStr=tab_tr.get_text("\n",strip=True).replace("\n",",")
       if classy == "weather":
           aux = auxStr[3:].split(",")
       elif classy == "prob-precip":
           aux = auxStr[9:].split(",")
       elif classy == "humidity":
           aux = auxStr[7:].split(",")
       elif classy == "wind-blow":
           aux = auxStr[12:].split(",")
       else:
           aux = auxStr.split(",")
       #print(len(aux))
       all_data.append(aux)
   save_data(all_data,f_out)

   return all_data

def read_data(in_file):
   new_data = []
   with open(in_file,newline='',encoding='utf8') as inFile:
       data = csv.reader(inFile,delimiter=',')
       for row in data:
           new_data.append(row)
   return new_data

def get_info(hour,got_this):
   idx=0
   for item in got_this:
       idx+=1
       if item[hour] == "---":
           item[hour] = "0"
       if idx == 4:
           if int(item[hour]) < 1:
               item[hour] = ""
               units[idx] = "湿度"
       print(item[hour] + units[idx],end="")
   print()
