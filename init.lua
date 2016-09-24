-- Tell the chip to connect to thi access point
wifi.setmode(wifi.STATION)
wifi.sta.setip({ip="10.23.42.22",netmask="255.255.254.0",gateway="10.23.42.1"})
wifi.sta.config("SSID","PASSWORD")
-- All global Variables
sollich=1
maintenanceMode=0


-- The Mqtt logic
m = mqtt.Client("ESP8266", 120, "user", "pass")

global_c=nil
function sleepnode()
 if maintenanceMode==1 then
    print("Maintenance Mode starting...")
    s=net.createServer(net.TCP, 180)
	s:listen(2323,function(c)
	global_c=c
	function s_output(str)
	  if(global_c~=nil)
	     then global_c:send(str)
	  end
	end
	node.output(s_output, 0)
	c:on("receive",function(c,l)
	  node.input(l)
	end)
	c:on("disconnection",function(c)
	  node.output(nil)
	  global_c=nil
	end)
	print("Welcome to the Switch")
	end)
 else
     print("Good Night")
     v=node.readvdd33()
     print(v)
     tmr.alarm(4,400,0,function()
      m:publish("/room/switch/voltage",v,0,0,node.dsleep(0))
     end)
end
end

function mqttsubscribe()
 tmr.alarm(1,50,0,function() 
        m:subscribe("/room/light/#",0, function(conn) print("subscribe /room/light success") end) 
    end)
end
m:on("connect", mqttsubscribe)
m:on("offline", function(con) print ("offline") end)
m:on("message", function(conn, topic, data)
   if topic=="/room/light/workshop/state" and sollich==1 then
    sollich=0
    if data=="on" then
     print("Es war An!")
     m:publish("/room/light/workshop/command","off",0,0,sleepnode)
    else 
     print("Es war Aus!")
     m:publish("/room/light/workshop/command","on",0,0,sleepnode)
    end
   elseif topic=="/room/light/debug" then
     if data=="enabled" then
        maintenanceMode=1
     end
   end
end)

-- Wait to be connect to the WiFi access point. 
tmr.alarm(0, 100, 1, function()
  if wifi.sta.status() ~= 5 then
     print("Connecting to AP...")
-- sleep, if no wifi after 10seconds runtime
    if tmr.now() > 10000000 then
      tmr.stop(0)
      print("No Wifi - Damn - Good night")
      sleepnode() 
     end
  else
     tmr.stop(0)
     print('IP: ',wifi.sta.getip())
     m:connect("10.23.42.10",1883,0)
  end
end)


