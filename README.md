# WorldDominationSwitch
ESP8266 controlled power saving battery operated wireless LAN MQTT switch

Based on the nodemcu-firmware

## Interface
1. Switch
2. Wifi
2.1 Mqtt
2.2 TCP Debugging interface

## Debug Mode
Activate the debug Mode, with your PC (mosqiutto-client required):
```
mosquitto_pub -h 10.23.42.10 -r -t "/room/light/debug" -m "enabled"
```

## Upgrade
The code must be filled with the correct passwords:
```
cat initTemplate.lua | sed "s/SSID/ask for the SSID/" | sed "s/PASSWORD/ask for the password/" > init.lua && sudo programESP.sh serial init.lua init.lua
```
