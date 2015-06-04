# WorldDominationSwitch
ESP8266 controlled power saving battery operated wireless LAN MQTT switch

## Interface
1. Switch
2. Wifi
2.1 Mqtt
2.2 TCP Debugging interface

## Debug Mode
Activate the debug Mode, with your PC (mosqiutto-client required):
 mosquitto_pub -h 10.23.42.10 -r -t "/room/debug" -m "enabled"

