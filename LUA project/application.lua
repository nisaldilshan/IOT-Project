-- file : application.lua
local module = {}  
m = nil
para= "oooo"
led2 = 4
gpio.mode(led2, gpio.OUTPUT)


-- Sends a simple ping to the broker
local function send_ping()  
    m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
    m:publish(config.ENDPOINT .. "ping","distance =" .. para,0,0)
    uart.on("data", 0,function(a)
        print("receive from uart:", a)
        para=a
        uart.on("data")
        
    end, 0)
    
        
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. config.ID,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        if data== "on" then
          gpio.write(led2, gpio.HIGH);
        elseif data== "off" then
          gpio.write(led2, gpio.LOW);
        end
        -- do something, we have received a message
      end
    end)
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con) 
        register_myself()
        -- And then pings each 1000 milliseconds
        tmr.stop(6)
        tmr.alarm(6, 5000, 1, send_ping)
    end) 

end

function module.start()  
  mqtt_start()
end

return module  