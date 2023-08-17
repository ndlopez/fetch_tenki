#!/bin/bash
area=23109 # Nagoya-shi,Naka-ku
rate=1hour #3hours
_url=https://tenki.jp/forecast/5/26/5110/${area}/${rate}.html
#_url1hr=https://tenki.jp/forecast/5/26/5110/23109/1hour.html
#神戸市の天気 https://tenki.jp/forecast/6/31/6310/28100/3hours.html
myHome=`pwd`
tenki_file=$myHome/data/${area}_${rate}.html
hour_file=$myHome/data/tenki_hour.txt
temp_file=$myHome/data/tenki_temp.txt
out_file=$myHome/data/grep_tenki

if [[ "$1" == "1" ]];then
    echo "using "${tenki_file}
else
    tenki_data=`curl -s ${_url}`
    if [ $? !=  0 ];then
	echo "Network error :("
	exit 100
    fi
fi

#backslash \n
monty=$(date "+%m")
day=$(date "+%d")
currHour=$(date "+%H")
currMin=$(date "+%M")
#week=("日" "月" "火" "水" "木" "金" "土")
#echo ${week[0]} -> 日 
lena=`LC_ALL=ja_JP date "+%a"`
#echo $lena
#echo "今日 ${monty}月${day}日($lena), Now "`date +"%H:%M"`
oneDay=`seq 24`
datum="2022-"$monty"-"$day
heute=$(echo "date "`for num in $oneDay;do echo $datum;done`)
echo $heute > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
#get current weather conditions every hour
heure=$(seq -w 1 23;echo "0")
echo "hour "$heure > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${hour_file}

paste -d' ' ${temp_file} ${hour_file} > ${out_file}

#echo "天気 "${weather} > ${temp_file}
#weather=$(echo ${tenki_data} | grep -m25 -w "weather" | cut -f6 -d'"')
for ((i=8; i<= 238; i+=10))
do
    echo ${tenki_data} |grep -m25 -w "weather"| cut -f`echo $i` -d'"'
    #echo $weather
done
exit 0
echo "weather"${weather} > ${temp_file}
(tr ' ' '\n' < ${temp_file}) > ${hour_file}
paste -d' ' ${out_file} ${hour_file} > ${temp_file}
#echo ${tenki_data}
echo $weather
#cat ${temp_file}
exit 0

temp=$(echo ${tenki_data} | grep -m2 -w "temperature" -A 47 | cut -f3 -d'>' | cut -f1 -d'<')

#echo "気温\n(℃)"${temp} > ${out_file}
echo "temp"${temp} > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${hour_file}
paste -d' ' ${temp_file} ${hour_file} > ${out_file}

prob=$(echo ${tenki_data} | grep -m2 -w "prob-precip" -A 48 | cut -f3 -d'>' | cut -f1 -d'<')

#echo "降水確率"${prob} > ${hour_file}
echo ${prob} > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
paste -d' ' ${out_file} ${temp_file} > ${hour_file}

mmhr=$(echo ${tenki_data} | grep -m2 -w "precipitation" -A 47 | cut -f3 -d'>' | cut -f1 -d'<')

#echo "降水量\n(mm/h)"${mmhr} > ${temp_file}
echo "rainMM"${mmhr} > ${temp_file}
(tr ' ' '\n' < ${temp_file}) > ${out_file}
paste -d' ' ${hour_file} ${out_file} > ${temp_file}

humid0=$(echo ${tenki_data} | grep -m2 -w "humidity" -A 48 | cut -f3 -d'>' | cut -f1 -d'<')
humid1=$(echo ${tenki_data} | grep -m2 -w "humidity" -A 48 | cut -f2 -d'>' | cut -f1 -d'<')

#echo "湿度"${humid} > ${hour_file}
echo ${humid0//--/}${humid1//湿度/} > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${out_file}
paste -d' ' ${temp_file} ${out_file} > ${hour_file}

wind_speed=$(echo ${tenki_data} | grep -m2 -w "wind-speed" -A 47 | cut -f3 -d'>' | cut -f1 -d'<')
#echo "風速\n(m/s)"${wind_speed} > ${out_file}
echo "windSpeed"${wind_speed} > ${out_file}
(tr ' ' '\n' < ${out_file}) > ${temp_file}
paste -d' ' ${hour_file} ${temp_file} > ${out_file}

windy=$(echo ${tenki_data} | grep -m2 -w "wind-blow" -A 94 | cut -f3 -d'=' | cut -f1 -d' ')
echo $windy > ${hour_file}
(tr ' ' '\n' < ${hour_file}) > ${temp_file}
paste -d' ' ${out_file} ${temp_file} > ${hour_file}
#mv ${hour_file} ${out_file}.csv

#sed -ie 's/ /,/g;s/"//g' ${out_file}.csv
# DEL 1st line and conv blank to "," from file
sed -ie '1d;s/ /,/g' ${hour_file}
#rm ${temp_file} ${hour_file}
if [ $currMin -gt 30 ];then
    currHour=$(expr $currHour + 1)
fi
grep $currHour ${hour_file}
# Check this script
# head -24 ${hour_file} > ${out_file}.csv
