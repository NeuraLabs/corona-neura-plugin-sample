local composer = require( "composer" )
json = require("json")
toast = require('plugin.toast')
neura = require("plugin.neura")

local function generalNeuraListener(event)
	-- print("generalNeuraListener enter")
	print(json.prettify(event))
	-- print("generalNeuraListener exit")
end

neura.connect({
	appUid = "badadc23349b3d2d16f4b787823819c3f29b29bd24c158d3aa4590d069e689b3", 
	appSecret = "77a52fe07ef104079e77d2a66e8630b4d3fbdd3d2dbe06098fda3fb7d8a1df2d"},
	generalNeuraListener) 


-- Prints all contents of a Lua table to the log.
local function printTable(table, stringPrefix)
	if not stringPrefix then
		stringPrefix = "### "
	end
	if type(table) == "table" then
		for key, value in pairs(table) do
			if type(value) == "table" then
				print(stringPrefix .. tostring(key))
				print(stringPrefix .. "{")
				printTable(value, stringPrefix .. "   ")
				print(stringPrefix .. "}")
			else
				print(stringPrefix .. tostring(key) .. ": " .. tostring(value))
			end
		end
	end
end

-- Called when a notification event has been received.
local function onNotification(event)
	if event.type == "remoteRegistration" then
		-- This device has just been registered for Google Cloud Messaging (GCM) push notifications.
		-- Store the Registration ID that was assigned to this application by Google.
		googleRegistrationId = event.token

		-- Display a message indicating that registration was successful.
		local message = "This app has successfully registered for Google push notifications."
		native.showAlert("Information", message, { "OK" })

		-- Print the registration event to the log.
		print("### --- Registration Event ---")
		printTable(event)

	else
		-- A push notification has just been received. Print it to the log.
		print("### --- Notification Event ---")
		printTable(event)
	end
end

-- Set up a notification listener.
Runtime:addEventListener("notification", onNotification)

-- Print this app's launch arguments to the log.
-- This allows you to view what these arguments provide when this app is started by tapping a notification.
local launchArgs = ...
print("### --- Launch Arguments ---")
printTable(launchArgs)

-- Go to the menu screen
composer.gotoScene( "menu" )


