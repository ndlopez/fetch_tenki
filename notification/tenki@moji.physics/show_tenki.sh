#/bin/bash
txtData=$HOME/.local/share/gnome-shell/extensions/tenki@moji.physics/data/tenki_temp.txt
currDay=$(date "+%d ")
currM=$(date "+%m")
today=2022-$currM-$currDay
#echo $today
currHour=$(date "+%H")
currMin=$(date "+%M")
if [[ $currMin > 30 ]];then
	currHour=`expr $currHour + 1`
fi

nextHour=`expr $currHour + 1`
#echo $today$nextHour
grep "$today$currHour" -m 1 $txtData
grep "$today$nextHour" -m 1 $txtData
