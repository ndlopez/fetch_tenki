//!/usr/bin/osascript -l JavaScript
/*
 This app displays local weather 
 at the Notification center in MacOS
 Requires data 
 fetched and cleaned using curl and sed
*/
var app = Application.currentApplication()

app.includeStandardAdditions = true

let data_home = "/Users/diego/Projects/weather_app/notif_app/data/tenki_hour.mod.csv"
let now_time= app.currentDate() //current date and time
var nowHeure = now_time.getHours();
var nowMinute = now_time.getMinutes();
var currentTime = nowHeure + ":";
currentTime+= (nowMinute < 10)? ("0"+ nowMinute):(nowMinute);

function readDataFile(fileName){
	try{
		var pathStr = fileName.toString()
		return app.read(Path(pathStr))
	}
    catch(error){
		displayError(fileName + " NO such data on system.", ["Cancel", "Exit"])
	}
}

function displayError(errorMessage, buttons) {
    app.displayDialog(errorMessage, {
        buttons: buttons
    })
}

var myData=readDataFile(data_home);

function txtToArray(){
	//#Convert csv table to array
	var timeTable = [];
	var myData = readDataFile(data_home);
	var lineBreak = myData.split("\n");
	lineBreak.forEach(res => {
		timeTable.push(res.split(","));
	});
	return timeTable
}

function getWeather(outHeure){
	var temp=txtToArray();
	//console.log("data",temp.length,temp[0])
	for (let idx=0;idx<temp.length;idx++){
		let aux=temp[idx].toString();
		let dataArray=aux.split(",");
		let heure = temp[idx].slice(1,2);
		if( heure == outHeure ){
			return dataArray
		}
	}
}

function getMsg(hora){
	var myData = getWeather(hora);
	if (typeof myData === "undefined"){
		return "Consult with tenki.jp :("
	}
	var Msg = myData[1]+":00 ";
	var weatherStr = String.fromCharCode(myData[2]) + " Rain";
	//var weatherStr = '"'+ myData[2] + '"' +' Rain';
	var windyStr = String.fromCharCode(myData[9]) + " "; //arrow \u2198, cloudy \u26c8,\u96F2\u308a
	var myStr = ["°C "+weatherStr,"% ","mm 湿度","%  "+windyStr,"m/s"];
	for(let item = 4;item < myData.length-1; item++){
		Msg += myData[item];
		Msg += myStr[item-4];
	}
	return Msg;
}
var currData=getWeather(nowHeure);
//console.log("currData",currData)

app.displayNotification(getMsg(nowHeure+2),{//\u3041 currData[3]
	withTitle: "Weather in Nagoya, Now " + currentTime + " " + currData[4] + "°C " + String.fromCharCode(currData[2]),
	subtitle: getMsg(nowHeure+1),
	soundName: "Frog"
})
