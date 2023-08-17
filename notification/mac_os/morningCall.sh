#!/bin/bash
# < morning_call.sh >
# fetches the local weather from
# wttr.in website for a ${place}
# place= nagoya, la_paz and lpb
# must convert wind speed from km/h to m/s
# execute: sh morning_call.sh place | say -v Samantha
#
# perl count_down.pl 5
#
# this_script lives at ${myhome}/../scripts however
#
place=$1
myhome=$HOME/Projects/weather_app/data
temp_file=${myhome}/morningCall.txt #base file
#rm ${weather_file}
#when no place is input
if [[ -z $1 ]];then
    place=nagoya #default place=35.1579,136.9045
fi
weather_file=${myhome}/wttrin_${place}.txt
out_file=${myhome}/wttrin_${place}.csv

#loc_time="The local time is "
if [[ ${place} = 'nagoya' ]]; then
    hora=$(date "+%H")
else
    place=la_paz #,lpb,~chacaltaya} #place=16.4956,-68.1336
    hora=`TZ='America/La_Paz' date "+%H"`
fi
echo $heure >> ${weather_file}

if [[ $hora -lt "12" ]]; then
  saludo="Good Morning, "
elif [[ $hora -lt "18" ]]; then
  saludo="Good Afternoon, "
else
  saludo="Good Evening, "
fi
echo $saludo $USER > ${weather_file}
minuto=$(date "+%M")
echo "$hora:$minuto" >> ${weather_file}
date "+%A, %B %d" >> ${weather_file}
#getting weather data...
curl wttr.in/${place}?format="+%t\n+%C\n+%h\n+%p\n+%w+\n%m" >> ${weather_file}
file_size=$(wc ${weather_file} | awk '{print $1}')
if [[ ${file_size} -lt 2 ]]; then
  echo "No data available at this time. Check again?"
else
  echo "The file size is "${file_size}
  paste -d' ' ${temp_file} ${weather_file} > ${out_file}
#sed -i -e 's/[ \t]*//' temp2.txt #does not work
##delete extra tabs with perl
#perl -i -pe 's/[ \t]+/ /' ${out_file}
  cat ${out_file} | say -v Samantha
fi
if [ $hora -gt "17" ]; then
  echo ", please, don't forget to reset the fans 🙀" | say -v Samantha
else
  echo ", Have a nice day! 😸"
fi
