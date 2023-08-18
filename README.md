# Weather applications

Weather applications developed with various technologies and environments (GNU/Linux, MacOS and Windows). Uses APIs from different providers.

## [CLI application](https://github.com/ndlopez/fetch_tenki/tree/main/get_tenki)

First attempt to extract weather data from a webpage (tenki.jp). Displays current weather conditions, updated every 3 hours.

## [GNOME Extension](https://github.com/ndlopez/fetch_tenki/tree/main/tenki%40moji.physics)

Display a notification every 30min.

Works on GNOME 40+ versions

![Screenshoot](tenki%40moji.physics/Screenshot.png)

Should probably create a new branch for this repository

	$ git branch gnome-ext

	$ git checkout -b gnome-ext

Then pull-request to merge with main

## [MacOS Notification](https://github.com/ndlopez/fetch_tenki/tree/main/notif_app/mac_os)

Display @the Notification Center and pop up every 30 minutes.

Requires manual update, CJK chars are converted to Unicode.

Branch created "notif"

### xBar plugin

[repo](https://github.com/ndlopez/weather/tree/main/xbar_plugin)

Plugin to display current conditions and radar image, all courtesy from tenki.jp.

## [Windows Notification](https://github.com/ndlopez/fetch_tenki/tree/main/notif_app/windows)

Windows PopUp message application using Powershell to display.

Auto-updates using task-scheduler.

---
Enviroment: 
- MacBookPro/MacOS 15.5<br>
- Panasonic Let'sNote/Linux Fedora 36<br>

Languages: Shell, JavaScript, Ruby<br>
Editors: VIM and Emacs

