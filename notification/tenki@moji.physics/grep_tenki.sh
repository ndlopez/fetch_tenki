#!/bin/bash
# <grep_tenki.sh>
# Version 1.7 2022-05-31
# Scrape data from <www.tenki.jp>
# Output is displayed using <show_tenki.sh> script
# !A copy is saved on Dropbox/Programming/scripts/
# Help: $ seq 1 24 -> prints 1 2 3 4...24
# backslash \n
# There's an issue with the URL source
# According to tenki.jp hour=24 is considered part
# of the current day, it should've been the next day 
# Bug:
# Data is retrieved for the current and next day,
# however, if last day of month it will print:
# 2022-05-31 and 2022-05-01

area=23109 #home, 23106 Naka-ku,23211 Toyota-shi
rate=1hour #3hours
_url=https://tenki.jp/forecast/5/26/5110/${area}/${rate}.html
#_url1hr=https://tenki.jp/forecast/5/26/5110/23109/1hour.html
#神戸市の天気 https://tenki.jp/forecast/6/31/6310/28100/3hours.html
#img_url=https://static.tenki.jp/static-images/radar/recent/pref-26-large.jpg
#also pref-26-middle.jpg is available

monty=$(date "+%m")
day=$(date "+%d")
hora=$(date "+%H")
#min=$(date "+%M")

#storing only current date data
myHome=$HOME/.local/share/gnome-shell/extensions/tenki@moji.physics/data
#cd $myHome

#setting up variables
tenki_file=$myHome/${area}_${rate}.html
hour_file=$myHome/tenki_hour_$monty$day.txt
#File for Gnome Extension
temp_file=$myHome/tenki_temp.txt

#week=("日" "月" "火" "水" "木" "金" "土")
#echo ${week[0]} -> 日 
#lena= ${week[4]} #`LC_ALL=ja_JP date "+%a"`

#testing = 1, download data = 0
if [[ "$1" == "1" ]];then
    echo "please add path of html file"
    #gunzip ${tenki_file}
    tenki_file=$2
    sleep 1
else
    curl ${_url} -o ${tenki_file}
    #2 > err.log
fi
#confirm if data was downloaded
if ! [[ -f ${tenki_file} ]];then
    echo "Network error :("
    exit 100
fi
    #else echo "Data downloaded"
    #cp ${rate}.html ${tenki_file}

#echo "今日 ${monty}月${day}日(${week[4]}), Now "`date +"%H:%M"`
#get current weather conditions every hour
oneDay=`seq 24`
datum="2022-"$monty"-"$day
#datum="2021-03-10"
heute=$(echo "-- "`for num in $oneDay;do echo $datum;done`)

tomoro=$((`date +%s` + 86400))
day=`date -d @$tomoro +%d`
datum="2022-"$monty"-"$day
#datum="2022-03-11"
morgen=$(echo " -- "`for num in $oneDay;do echo $datum;done`)
heure=$(echo "--";seq -w 23;echo "0 --";seq -w 1 24)

weather=$(grep -m50 -w "weather" ${tenki_file} | cut -f6 -d'"')

#echo "天気 "${weather} > ${temp_file}
#echo "気温\n(℃ )"${temp} > ${temp_file}
temp=$(grep -m2 -w "temperature" -A 47 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
#echo "降水確率"${prob} > ${hour_file}
prob=$(grep -m2 -w "prob-precip" -A 48 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')

mmhr=$(grep -m2 -w "precipitation" -A 47 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')

#echo "湿度"${humid} > ${hour_file}
humid0=$(grep -m2 -w "humidity" -A 48 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
humid1=$(grep -m2 -w "humidity" -A 48 ${tenki_file} | cut -f2 -d'>' | cut -f1 -d'<')

#echo "風速\n(m/s)"${wind_speed} > ${temp_file}
wind_speed=$(grep -m2 -w "wind-speed" -A 47 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
#wind direction
windy=$(grep -m2 -w "wind-blow" -A 94 ${tenki_file} | cut -f3 -d'=' | cut -f1 -d' ')

#merge all columns by variable
fecha=$heute$morgen
paste <(echo $fecha | tr ' ' '\n') <(echo $heure | tr ' ' '\n') <(echo "--"$weather | tr ' ' '\n') <(echo "--"${temp} | tr ' ' '\n') <(echo ${prob} | tr ' ' '\n') <(echo "--"${mmhr} | tr ' ' '\n') <(echo ${humid0//--/}${humid1//湿度/} | tr ' ' '\n') <(echo "--"${wind_speed} | tr ' ' '\n') <(echo $windy | tr ' ' '\n') -d' ' > ${hour_file}

#Add an space to beginning of each row
#Otherwise, when parsing to JS the row will start with '\n' char
#sed -i 's/.*/ &/' ${hour_file}
#Since the weather mark is displaced by one row
sed -i '1d;26d' ${hour_file}

#the following replaces empty space with "晴れ"
sed -i "s|$datum 24|$datum 0 晴れ|g" ${hour_file}
#DEL last row of data:<     0  64  "北">
sed -i '$d' ${hour_file}
#data reduction
offset=`expr 50 - $hora`
tail -$offset ${hour_file} > ${temp_file}
echo "Updated on " `date` >> ${temp_file}
#Since HTML file is no longer useful, unless to re-do scraping
#if [ ! -f ${tenki_file} ];then
#    gunzip ${tenki_file}
#else
#    gzip ${tenki_file}
#fi
echo "Done. Have a nice day :)"
#{ tail -$offset ${hour_file};echo "Updated on "`date` } > ${temp_file}
