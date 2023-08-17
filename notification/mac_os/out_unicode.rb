#!/usr/bin/ruby
# coding: utf-8
=begin
    Read a csv file
    ideally should output unicode of CJK chars
    however, cannot render them in JS when parsing
    if,then,else in ruby
    if condition
        do sth
    elsif condition
        do sth else
    else
        do anything
    end
=end
require 'csv'
dataFile="/Users/diego/Projects/weather_app/notif_app/data/tenki_hour.csv"
weather=CSV.parse(File.read(dataFile)) #,headers: false)

for idx in 0..weather.length()-2
    print weather[idx][0],",",weather[idx][1],","
    case weather[idx][2] 
    when "晴れ" #sunny
        print "9728,Sunny," #"\\u6674\\u308c,"
    when "曇り" #cloudy
        print "9925,Cloudy," #"\\u96f2\\u308a,"
    when "雨", "強雨"
        print "9748,Rain," #"\\u96E8,"
    else
        print "9928,LightRain," 
    end
    for jdx in 3..7
        print weather[idx][jdx],","
    end
    case weather[idx][8]
    when "北東" , "東北東"
        puts "8599" #"NE" #"\\u279a"
    when "南西" , "南南西"
        puts "8601" #"SW" #"\\u2199"
    when "南東" , "東南東"
        puts "8600" #"SE" #"\\u2798"
    when "北西" , "西北西"
        puts "8598" #"NW" #"\\u2196"
    when "南" , "南南西" , "南南東"
        puts "8595" #"S"
    when "北北西" , "北" , "北北東"
        puts "8593" #"N"
    when "西南西" , "西"
        puts "8592" #"W"
    else puts "8594" #"E"
    end
end
#print weather[1][2]
