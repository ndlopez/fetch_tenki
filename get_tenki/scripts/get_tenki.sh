#!/bin/bash
#Scrape data from <www.tenki.jp>
_url=https://tenki.jp/forecast/6/31/6310/28100/3hours.html
tenki_file=../data/28100_3hr.html
hour_file=../data/tenki_hour.txt
temp_file=../data/tenki_temp.txt
out_file=../data/tenki.txt
curl -O ${_url}
if [[ -f "3hours.html" ]];then
   echo "Data downloaded"
   mv 3hours.html ${tenki_file}
else
   echo "Network error :("
fi #backslash \n
monty=$(date "+%m")
day=$(date "+%d")
#week=("日" "月" "火" "水" "木" "金" "土")
#echo ${week[0]} -> 日 
lena=`LC_ALL=ja_JP date "+%a"`
#echo $lena
echo "今日 ${monty}月${day}日($lena)"
#get current weather conditions every 3hrs
echo "時刻\n\t \n 03 \n 06 \n 09 \n 12 \n 15 \n 18 \n 21 \n 24 " > ${hour_file}
weather=$(grep -m9 -w "weather" ${tenki_file} | cut -f6 -d'"')
echo "天気 "${weather} > ${temp_file}
(tr ' ' '\n' < ${temp_file}) > ${out_file}
paste -d' ' ${hour_file} ${out_file} > ${temp_file}
#cat ${temp_file}

temp=$(grep -m2 -w "temperature" -A 15 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
echo "気温\n(℃)"${temp} > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${hour_file}
paste -d' ' ${temp_file} ${hour_file} > ${out_file}
#cat ${out_file}

prob=$(grep -m2 -w "prob-precip" -A 16 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
echo "降水確率"${prob} > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
paste -d' ' ${out_file} ${temp_file} > ${hour_file}
#cat ${hour_file}

mmhr=$(grep -m2 -w "precipitation" -A 15 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
echo "降水量\n(mm/h)"${mmhr} > ${temp_file}
(tr ' ' '\n' < ${temp_file}) > ${out_file}
paste -d' ' ${hour_file} ${out_file} > ${temp_file}
#cat ${temp_file}

humid=$(grep -m2 -w "humidity" -A 16 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
echo "湿度"${humid} > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${out_file}
paste -d' ' ${temp_file} ${out_file} > ${hour_file}
#cat ${hour_file}

wind_speed=$(grep -m2 -w "wind-speed" -A 17 ${tenki_file} | cut -f3 -d'>' | cut -f1 -d'<')
echo "風速"${wind_speed} > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${temp_file}
paste -d' ' ${hour_file} ${temp_file} > ${out_file}
cat ${out_file}

#after getting all the data, format it!

