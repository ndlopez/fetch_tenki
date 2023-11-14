import requests
from datetime import datetime

this_url = "https://www.jma.go.jp/bosai/quake/data/list.json"

proxj = {'https':'http://n07.ur.f.ip:8080'}

offset = 2
try:
   curr_hour = datetime.now().hour
   response = requests.get(this_url,timeout=5,proxies=proxj)
   # print(response.text)
   quake_data = response.json()
   this_date = datetime.fromisoformat(quake_data[0]['at'])
   event_hour = this_date.hour
   # print("ttl= Earthquake and Seismic Intensity Information")
   if (event_hour + offset) >= curr_hour:
       print(f"when= {this_date.month}月{this_date.day}日", this_date.time(),"地震がありました。")
       print(f"what= M{quake_data[0]['mag']} in {quake_data[0]['anm']}")
   else:
       print("when= -:--")
       print(f"what= No events in the past {offset} hours")
except requests.exceptions.ConnectionError:
   print("Cannot reach",this_url)
