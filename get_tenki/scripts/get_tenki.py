#extracting data from www.tenki.jp
from bs4 import BeautifulSoup
from urllib.request import urlopen

my_url='https://tenki.jp/forecast/6/31/6310/28100/3hours.html'
class_list=["weather","temperature","prob-precip","precipitation",
            "humidity","wind-speed"]
#when downloading a page...
try:
    source=urlopen(my_url)
    print("Access granted")
except urllib.error.HTTPError as err:
    print("Access denied or...", err.code)
    print("Better use curl to fetch the page...")
    source = open('../data/23108_3hr.html','r')

soup = BeautifulSoup(source.read(),'html.parser')

'''
tab_tr=tables.find('tr',class_='weather')
print(tab_tr.get_text("\n",strip=True).replace("\n",","))
#out: '\n天気\n曇り\n曇り\n曇り\n曇り\n曇り\n曇り\n曇り\n曇り\n'
tab_tr=tables.find('tr',class_='temperature')
tab_tr=tables.find('tr',class_='prob-precip')
tab_tr=tables.find('tr',class_='precipitation')
tab_tr=tables.find('tr',class_='humidity')
tab_tr=tables.find('tr',class_='wind-speed')
'''
#up to here ok!
def get_info(tab_id):
    tables = soup.find('table',id=tab_id)
    for classy in class_list:
        tab_tr=tables.find('tr',class_=classy)
        print(tab_tr.get_text("\n",strip=True).replace("\n",","))

get_info("forecast-point-3h-today")
get_info("forecast-point-3h-tomorrow")

