
wifi.sta.config("aaa","12345678")
print(wifi.sta.getip())

led1 = 3
led2 = 4
--sum=0
gpio.mode(led1, gpio.INT, gpio.PULLUP)
gpio.mode(led2, gpio.OUTPUT)
-----------------------------------------------------
uart.on("data", 3, 
    function(data)
        print("Received from Arduino:", data)

    end        
end, 0)    
-----------------------------------------------------

function fn(level)
    --print(sum)
    --sum=sum+1
    mqtt:publish("abc/test","off",0,0, function(conn) 
       print("sent") 
       end)
    tmr.delay(250000)
    end

gpio.trig(led1, "down", fn)

-- initiate the mqtt client and set keepalive timer to 120sec
mqtt = mqtt.Client("client_id", 120, "username", "password")

mqtt:on("connect", function(con) print ("connected") end)
mqtt:on("offline", function(con) print ("offline") end)

-- on receive message
mqtt:on("message", function(conn, topic, data)
  print(topic .. ":" )
  if data ~= nil then
    print(data)
    if data== "on" then
      gpio.write(led2, gpio.HIGH);
    elseif data== "off" then
      gpio.write(led2, gpio.LOW);
    end
  end
end)


mqtt:connect("192.168.137.29", 1883, 0, function(conn) 
  print("connected")
  -- subscribe topic with qos = 0
  mqtt:subscribe("abc/t",0, function(conn) 
    -- publish a message with data = my_message, QoS = 0, retain = 0
     mqtt:publish("abc/test","message123",0,0, function(conn) 
       print("sent") 
       end)
  end)
end)
