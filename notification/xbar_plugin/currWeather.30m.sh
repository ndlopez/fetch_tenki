#!/bin/bash
# <xbar.title>Current weather</xbar.title>
# <xbar.version>0.2</xbar.version>
# <xbar.author>Diego Lopez</xbar.author>
# <xbar.author.github>ndlopez</xbar.author.github>
# <xbar.desc>Scrapes current weather data for Nagoya-city from weathernews.jp. Other cities from Japan are available too.</xbar.desc>
# <xbar.image>https://github.com/ndlopez/weather_app/raw/notif/xbar_plugin/currWeather_1h_prev.png</xbar.image>
# <xbar.dependencies>bash,curl,grep,base64,cut</xbar.dependencies>
# <xbar.abouturl>https://github.com/ndlopez/weather_app/xbar_plugin</xbar.abouturl>
currTime=$(date "+%H:%M")
city_code=23109
pref=aichi
curr_weather=`curl -s https://weathernews.jp/onebox/tenki/$pref/${city_code}/ | grep "weather-now__ul" -A10`

if [ ! $? == 0 ];then
    echo "error"
    echo ---
    echo "Cannot access weathernews"
    exit 100
fi
tenki=$(echo ${curr_weather} | cut -f5 -d'>' | cut -f1 -d'<')
temp=$(echo ${curr_weather} | cut -f9 -d'>' | cut -f1 -d'<')
humid=$(echo ${curr_weather} | cut -f14 -d'>' | cut -f1 -d'<')
#press=18
wind=$(echo ${curr_weather} | cut -f22 -d'>' | cut -f1 -d'<')
sunrise=$(echo ${curr_weather} | cut -f26 -d'>' | cut -f1 -d'&')
sunset=$(echo ${curr_weather} | cut -f28 -d'>' | cut -f1 -d'<')
img_url=https://static.tenki.jp/static-images/radar/recent/pref-26-small.jpg
radar_img=`curl -s ${img_url} | base64`
#echo ${curr_weather}
echo $tenki $temp
echo "---"

#thanks to Dave Wikoff(@derimagia) for the following
BitBarDarkMode=${BitBarDarkMode}
if [ "$BitBarDarkMode" ]; then
  # OSX has Dark Mode enabled.
  fcolor="| color=white"
else
  # OSX does not have Dark Mode
  fcolor="| color=black"
fi

echo "| image=${radar_img}"
echo "湿度 "$humid$fcolor
echo "風 "$wind$fcolor
echo "日の出 "$sunrise$fcolor
echo "日の入 "$sunset$fcolor
echo "Last updated "$currTime

