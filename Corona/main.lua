local neura = require "plugin.neura"
local json = require "json"
local widget = require "widget"


local function listener(event)
	print(json.prettify(event))
end


local connectButton = widget.newButton(
	{
		label = "Connect",
		x = display.contentCenterX,
		y = 170,
		width = 188,
		height = 32,
		
		onRelease = function() neura.connect({
	appUid = "9edfb165c3c071375000c6127b208049e35163e9a6026f8410cf0d4efb2fb15a", 
	appSecret = "266260dbb33e898440cf4255b5fcf1abbe93ddb5d369624e8cd083905a7af9b5"},
	listener) end
	})

local authenticateButton = widget.newButton(
	{
		label = "Authenticate",
		x = display.contentCenterX,
		y = 270,
		width = 188,
		height = 32,
		
		onRelease = function() neura.authenticate() end
	})

local disconnectButton = widget.newButton(
	{
		label = "Disconnect",
		x = display.contentCenterX,
		y = 370,
		width = 188,
		height = 32,
		
		onRelease = function() neura.disconnect() end
	})