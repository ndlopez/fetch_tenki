from datetime import datetime, timedelta
from pathlib import Path
import csv

from bs4 import BeautifulSoup
from urllib.request import urlopen
from urllib.error import HTTPError

now = datetime.now()
tomorrow = now + timedelta(1) # 2024-01-10 13:35:13.633480
currHour = now.strftime("%H:%M")
jiscode = ["23109", "Nagoya"]
# jiscode = ["23220", 稲沢市]
tenki_url = f"https://tenki.jp/forecast/5/26/5110/{jiscode[0]}/1hour.html"
class_list = ["weather","temperature","prob-precip","precipitation","humidity","wind-blow","wind-speed"]
units = [":00 ","","\u2103  防水率","% ","mm 湿度","% ","","m"]
aux_dates = []

def save_data(got_data,out_file):
    with open(out_file,'w',newline='',encoding='utf8') as fp:
        # fp.write(tag+"\n")
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
    # tagg = "# " + tag.strftime('%Y-%m-%d')
    # all_data.append(tag)

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
        """if "#" in data:
            aux_dates.append(data)
        else:"""
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
            if int(item[hour]) <= 1:
                item[hour] = ""
                units[idx] = "湿度"
            else:
                units[idx] = "mm 湿度"
        print(item[hour] + units[idx],end="")
    print()

if __name__ == "__main__":
    update_time = []
    print(aux_dates)
    for heure in range(0,24,3):
        update_time.append(heure)
    outFile = [Path.home().joinpath("Downloads","get_tenki_today.csv"), Path.home().joinpath("Downloads","get_tenki_tomorrow.csv"),Path.home().joinpath("Downloads","get_tenki_dayaftertomorrow.csv")]
    if int(currHour[:2]) in update_time:
        # update every 3hours [[],[],...]
        print("data being updated...")
        got_that = make_soup("forecast-point-1h-today",outFile[0],now)
        got_avy = make_soup("forecast-point-1h-tomorrow",outFile[1],tomorrow)
        got_zoey = make_soup("forecast-point-1h-dayaftertomorrow",outFile[2])
    else:
        # read from csv file
        print("data from file")
        got_that = read_data(outFile[0])
        got_avy = read_data(outFile[1])
        got_zoey = read_data(outFile[2])
    
    # print(got_this) # [[weather],[tem],...]
    aux = 1
    print(f"curr= {jiscode[1]}、現在",currHour,end=" ")
    if int(currHour[3:]) > 30:
        #next hour
        get_info(int(currHour[:2]),got_that)
        aux = 2
    else:
        #curr hour
        get_info(int(currHour[:2])-1,got_that)

    # next hour
    # print("next=",str(int(currHour[:2]) + aux) + units[0],end="")
    # get_info(int(currHour[:2]) + aux - 1,got_that)
    # next2 hours
    print("next=",str(int(currHour[:2]) + aux + 1) + units[0],end="")
    get_info(int(currHour[:2]) + aux + 0,got_that)
    # tomorrow
    print(f"next2= {tomorrow.strftime('%m月%d日')} {str(int(currHour[:2]))}{units[0]}",end="")
    get_info(int(currHour[:2]),got_avy)
