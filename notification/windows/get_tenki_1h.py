import csv
from bs4 import BeautifulSoup
from urllib.request import urlopen
from urllib.error import HTTPError
from datetime import datetime

now = datetime.now()

currHour = now.strftime("%H:%M")

# jiscode = "23109" # Nagoya
jiscode = "23203" # Ichinomiya
tenki_url="https://tenki.jp/forecast/5/26/5110/"+jiscode+"/1hour.html"
class_list=["weather","temperature","prob-precip","precipitation","humidity","wind-blow","wind-speed"]

try:
    source=urlopen(tenki_url)
except HTTPError as err:
    print("Could fetch",tenki_url,err.code)

soup = BeautifulSoup(source.read(),'html.parser')
tables=soup.find('table',id="forecast-point-1h-today")

"""with open('get_1h_tenki.csv', 'wb') as csvfile:
    filewriter = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    filewriter.writerow(['Name', 'Profession'])
    filewriter.writerow(['candice', 'Software Developer'])
    filewriter.writerow(['Ingrid', 'Software Developer'])
    filewriter.writerow(['Paula', 'Manager'])
"""

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

units = [":00 "," ","C ","% ","mm ","% "," ","m/s"]

def get_info(hour):
    idx=0
    for item in all_data:
        idx+=1
        if item[hour] == "---":
            item[hour] = "0"
        print(item[hour] + units[idx],end="")
    print()

print("curr=",currHour,end=" ")

get_info(int(currHour[:2])-1)
# next hour

print("next=",str(int(currHour[:2])+1)+units[0],end="")
get_info(int(currHour[:2]))
