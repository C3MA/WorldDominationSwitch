-- Tell the chip to connect to thi access point
wifi.setmode(wifi.STATION)
wifi.sta.config("sticknet","stickpw1")
m = mqtt.Client("ESP8266", 120, "user", "pass")
function mqttsubscribe()
 tmr.alarm(1,50,0,function() m:subscribe("/room/light/+/state",0, function(conn) print("subscribe 5 success") end) end)
end
sollich=1
m:on("connect", mqttsubscribe)
m:on("offline", function(con) print ("offline") end)
m:on("message", function(conn, topic, data)
   if topic=="/room/light/5/state" and sollich==1 then
    sollich=0
    if data=="on" then
     print("Es war An!")
     m:publish("/room/light/5/command","off",0,0,nil)
     tmr.alarm(2,300,0,function() 
	m:publish("/room/light/6/command","off",0,0,function() node.dsleep(0) end)
     end)
   else 
     print("Es war Aus!")
     m:publish("/room/light/5/command","on",0,0,nil)
     tmr.alarm(3,300,0,function() 
	m:publish("/room/light/6/command","on",0,0,function() node.dsleep(0) end)
        end)
     end
   end
end)



-- Connect to the WiFi access point. Once the device is connected,
-- you may start the HTTP server.
tmr.alarm(0, 200, 1, function()
   if wifi.sta.getip() == nil then
      print("Connecting to AP...")
   else
      tmr.stop(0)
      print('IP: ',wifi.sta.getip())
      -- Uncomment to automatically start the server in port 80
      m:connect("10.23.42.10",1883,0)
   end
end)
