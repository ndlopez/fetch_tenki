#!/bin/bash
#Scrape data from <www.tenki.jp>
area=23109 #23106 Nagoya,Naka-ku
rate=1hour #3hours
_url=https://tenki.jp/forecast/5/26/5110/${area}/${rate}.html
#_url1hr=https://tenki.jp/forecast/5/26/5110/23109/1hour.html
#神戸市の天気 https://tenki.jp/forecast/6/31/6310/28100/3hours.html
myHome=/Users/diego/Projects/weather_app/notif_app #`pwd`
tenki_file=$myHome/data/${area}_${rate}.html
hour_file=$myHome/data/tenki_hour
temp_file=$myHome/data/tenki_temp.txt
out_file=$myHome/data/grep_tenki

if [[ "$1" == "1" ]];then
    echo "using "${tenki_file}
else
    curl ${_url} -o ${tenki_file}
fi

if ! [[ -f ${tenki_file} ]];then
    echo "Network error :("
    exit 100
fi
#backslash \n
monty=$(date "+%m")
day=$(date "+%d")
hora=$(date "+%H")
#week=("日" "月" "火" "水" "木" "金" "土")
#echo ${week[0]} -> 日 
lena=`LC_ALL=ja_JP date "+%a"`
#echo $lena
echo "今日 ${monty}月${day}日($lena), Now "`date +"%H:%M"`
oneDay=`seq 24` #49 2days
datum="2022-"$monty"-"$day
heute=$(echo "date "`for num in $oneDay;do echo $datum;done`)
echo $heute > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
#get current weather conditions every 3hrs
#echo "時刻\n\t \n 03 \n 06 \n 09 \n 12 \n 15 \n 18 \n 21 \n 24 " > ${hour_file}
#weather=$(grep -m9 -w "weather" ${tenki_file} | cut -f6 -d'"')
#get current weather conditions every hour
heure=$(seq -w 1 23;echo "0")
echo "hour "$heure > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${hour_file}

paste -d' ' ${temp_file} ${hour_file} > ${out_file}

#echo "天気 "${weather} > ${temp_file}
weather=$(grep -m25 -w "weather" ${tenki_file} | cut -f6 -d'"')
echo "weather"${weather} > ${temp_file}
(tr ' ' '\n' < ${temp_file}) > ${hour_file}
paste -d' ' ${out_file} ${hour_file} > ${temp_file}

#temp=$(grep -m2 -w "temperature" -A 15 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')

temp=$(grep -m2 -w "temperature" -A 47 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')

#echo "気温\n(℃)"${temp} > ${out_file}
echo "temp"${temp} > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${hour_file}
paste -d' ' ${temp_file} ${hour_file} > ${out_file}

#prob=$(grep -m2 -w "prob-precip" -A 16 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
prob=$(grep -m2 -w "prob-precip" -A 48 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')

#echo "降水確率"${prob} > ${hour_file}
echo ${prob} > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
paste -d' ' ${out_file} ${temp_file} > ${hour_file}
#cat ${hour_file}

#mmhr=$(grep -m2 -w "precipitation" -A 15 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
mmhr=$(grep -m2 -w "precipitation" -A 47 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')

#echo "降水量\n(mm/h)"${mmhr} > ${temp_file}
echo "rainMM"${mmhr} > ${temp_file}
(tr ' ' '\n' < ${temp_file}) > ${out_file}
paste -d' ' ${hour_file} ${out_file} > ${temp_file}
#cat ${temp_file}

#humid=$(grep -m2 -w "humidity" -A 16 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
humid0=$(grep -m2 -w "humidity" -A 48 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
humid1=$(grep -m2 -w "humidity" -A 48 ${tenki_file} | cut -f2 -d'>' | cut -f1 -d'<')

#echo "湿度"${humid} > ${hour_file}
echo ${humid0//--/}${humid1//湿度/} > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${out_file}
paste -d' ' ${temp_file} ${out_file} > ${hour_file}
#cat ${hour_file}

#wind_speed=$(grep -m2 -w "wind-speed" -A 17 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
wind_speed=$(grep -m2 -w "wind-speed" -A 47 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
#echo "風速\n(m/s)"${wind_speed} > ${out_file}
echo "windSpeed"${wind_speed} > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${temp_file}
paste -d' ' ${hour_file} ${temp_file} > ${out_file}

windy=$(grep -m2 -w "wind-blow" -A 94 ${tenki_file} | cut -f3 -d'=' | cut -f1 -d' ')
echo $windy > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
paste -d' ' ${out_file} ${temp_file} > ${hour_file}
#mv ${hour_file} ${out_file}.csv
# add quotes to Weather to parse in JS
# awk '$3="\""$3"\""' ${hour_file} > ${out_file}.csv
# sample output
# echo "時刻 天気 気温 降水確率 降水量 湿度 風速"
# echo "-- --- [C]   [%]   [mm/h] [%] [m/s]"
# head -10 ${out_file}.csv
#sed -ie 's/ /,/g;s/"//g' ${out_file}.csv
# DEL 1st line and conv blank to "," from file
sed -ie '1d;s/ /,/g' ${hour_file} 
mv ${hour_file} ${hour_file}.csv
#rm ${temp_file} ${hour_file}

# Check this script
# https://github.com/matryer/xbar-plugins/blob/main/Weather/weather.15m.py
# mv ${out_file}.csv $HOME/Projects/weather_app/data/.
# echo "CSV Data moved to weather App folder"
# ls -l $HOME/Projects/weather_app/data/
# head -24 ${hour_file} > ${out_file}.csv
# exit 0
echo "Fixing some CJK chars..." 
/usr/bin/ruby $myHome/out_unicode.rb > ${hour_file}.mod.csv
# cron will exec the following
#echo "Displaying as a notification..."
#/usr/bin/osascript -l JavaScript $myHome/notif_app.js
