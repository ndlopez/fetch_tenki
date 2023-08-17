/*
  Display current Weather status
  Data from tenki.jp, data wrangled using bash 
  Ref https://gitlab.com/justperfection.channel/how-to-create-a-gnome-shell-extension/-/tree/master/example@example.com
*/
const {St,GLib,Clutter} = imports.gi;
const Gio = imports.gi.Gio;
const Main = imports.ui.main;
const Mainloop = imports.mainloop;
const Me = imports.misc.extensionUtils.getCurrentExtension();

let panelBtn, panelBtnTxt, timeout;
var tenkiArr=[];
var unitArr=["°C","雨","%","mm","湿度","%","風速","m"];

function setGrepTenki(){
    var arr = [];
    var now = GLib.DateTime.new_now_local();
    var hora = now.format("%H:%M ");//%Y/%m/%d

    //display weather
    var [ok,out,err,exit] = GLib.spawn_command_line_sync('/bin/bash ' + Me.dir.get_path() + '/show_tenki.sh');
    if(out === undefined){
    out = "Error\nRevise Shell script";}
    var str = imports.byteArray.toString(out).replace('\n',' ');

    //log(hora+' Current weather: '+ str);
    tenkiArr = str.split(" ");
    var thisOpt = "";
    if (tenkiArr[5] > 0){
	thisOpt = "雨 " + tenkiArr[5] + "mm";
    	//panelBtnTxt.style_class("warning"); Error:No such function :(
    }else{
	thisOpt = "風速 " + tenkiArr[7] + "m";
    }
    const dspStr=tenkiArr[2]+" "+tenkiArr[3]+"°C/" + thisOpt;
    arr.push(dspStr);

    panelBtnTxt.set_text(arr.join('   '));
    var nextHr=tenkiArr[10]+":00 "+tenkiArr[11]+" "+tenkiArr[12]+"°C 雨 "+tenkiArr[13]+"% "+tenkiArr[14]+"mm 湿度 "+tenkiArr[15]+"% 風速"+tenkiArr[17]+tenkiArr[16]+"m";
    Main.notify(hora+ tenkiArr[2]+" "+tenkiArr[3]+"°C 雨 "+tenkiArr[4]+"% "+tenkiArr[5]+"mm 湿度 "+tenkiArr[6]+"% 風速"+tenkiArr[8]+tenkiArr[7]+"m",nextHr);
    //天気情報
    return true;
}

function init(){
    panelBtn = new St.Bin({
	style_class:"panel-button"
    });
    
    const cloudy = String.fromCharCode(9925);//works nicely
    panelBtnTxt = new St.Label({
	style_class:"tenkiText",
	text: cloudy + "天気更新中",
	//text:myArr[2]+" "+myArr[3]+"°C",
	y_align: Clutter.ActorAlign.CENTER,
    });
    panelBtn.set_child(panelBtnTxt);
}

function enable(){
    Main.panel._centerBox.insert_child_at_index(panelBtn,1);
    timeout=Mainloop.timeout_add_seconds(1653,setGrepTenki);
}

function disable(){
    Mainloop.source_remove(timeout);
    Main.panel._rightBox.remove_child(panelBtn);
}
