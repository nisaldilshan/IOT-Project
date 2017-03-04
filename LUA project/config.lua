-- file : config.lua
local module = {}

module.SSID = {}  
module.SSID["NISALDILSHAN"] = "fuckfuck"

module.HOST = "192.168.137.1"  
module.PORT = 1883  
module.ID = node.chipid()

module.ENDPOINT = "nodemcu/"  
return module  