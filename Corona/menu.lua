local composer = require( "composer" )
 
local scene = composer.newScene()
local widget = require "widget"

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local setUIState


local neuraStatusText
local requestPermissionsBtn
local servicesBtn
local addDeviceBtn
local addLocationBtn
local simulateEventBtn
local disconnectBtn

local phoneTextField


local function subscribeToEventListener(event)
	if event.type == "Failure" then
		toast.show("Error: Failed to subscribe to event " .. event.event.eventName .. ". Error code: " .. event.data)
		print("Error: Failed to subscribe to event " .. event.event.eventName .. ". Error code: " .. event.data)
	else
		print("Subscribed to event " .. event.event.eventName)
	end
end


local function authenticateListener(event)
	if event.type == "Success" then
		setUIState(true)
		neura.registerFirebaseToken()
		print("Start subscribe")
     	for i, v in ipairs(event.data.events) do
     		if v.pushNotificationText ~= "" then
				neura.subscribeToEvent(v.name, "Identifier_"..v.name, subscribeToEventListener)
				local notificationOptions = {
					contentTitle = v.displayName,
					contentText = v.pushNotificationText
				}
				neura.registerNotificationForEvent(v.name, notificationOptions)
			end
		end
		print("End subscribe")
	else
		requestPermissionsBtn:setEnabled(true)
	end
end

local function requestPermissions()
	local args = {}
	if phoneTextField.text ~= "" then
		args["phone"] = phoneTextField.text
	end
	neura.authenticate(args, authenticateListener)
end

local function services()
	composer.gotoScene( "services" )
end

local function addDevice()
	composer.gotoScene( "device_operations" )
end

local function addLocation()
	composer.gotoScene( "add_location" )
end

local function simulateEvent()
	neura.simulateAnEvent()
end

local function disconnectListener(event)
	setUIState(neura.isLoggedIn())
end

local function disconnect()
	neura.forgetMe(true, disconnectListener)
end

function setUIState( isConnected )
	requestPermissionsBtn:setEnabled( not isConnected )
	disconnectBtn:setEnabled( isConnected )
	if isConnected then
		neuraStatusText.text = "Connected"
		neuraStatusText:setFillColor( 0.15, 0.62, 0.09 )
	else
		neuraStatusText.text = "Disconnected"
		neuraStatusText:setFillColor( 1, 0, 0.12 )
	end
	neuraStatusText.text = isConnected and "Connected" or "Disconnected"

	
    simulateEventBtn:setEnabled(isConnected);
    simulateEventBtn.alpha = isConnected and 1 or 0.5
    addDeviceBtn:setEnabled(isConnected);
    addDeviceBtn.alpha = isConnected and 1 or 0.5
    servicesBtn:setEnabled(isConnected);
    servicesBtn.alpha = isConnected and 1 or 0
    addLocationBtn:setEnabled(isConnected);
    addLocationBtn.alpha = isConnected and 1 or 0.5

    requestPermissionsBtn.alpha = isConnected and 0 or 1

    disconnectBtn:setEnabled( isConnected )

    if phoneTextField == nil and not isConnected then
	    phoneTextField = native.newTextField(display.contentCenterX, 0, display.contentWidth - 60, 30 )
		phoneTextField.anchorY = 0
		phoneTextField.placeholder = "Optional: authenticate with a phone number"
		phoneTextField.inputType = "phone"
		phoneTextField.y = neuraStatusText.y + neuraStatusText.contentHeight + 10
	elseif phoneTextField ~= nil and isConnected then
		phoneTextField:removeSelf()
		phoneTextField = nil
	end

end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 0.96 )

	local logo = display.newImageRect(sceneGroup, "neura_sdk_demo_logo.png", 186, 18)
	logo.anchorX = 0
	logo.anchorY = 0
	logo.x = 30
	logo.y = 30

	local versionText = display.newText( sceneGroup, "Sdk Version: ", 0, 0, native.systemFont, 13 )
	versionText.anchorX = 0
	versionText.anchorY = 0
	versionText.x = 30
	versionText.y = logo.y + logo.contentHeight + 5
	versionText.text = "Sdk Version: ".. neura.getSdkVersion()
	versionText:setFillColor( 0 )

	local neuraSymbolTop = display.newImageRect(sceneGroup, "neura_symbol_top_element.png", 103, 53)
	neuraSymbolTop.anchorY = 0
	neuraSymbolTop.x = display.contentCenterX
	neuraSymbolTop.y = versionText.y + versionText.contentHeight


	local neuraSymbolBottom = display.newImageRect(sceneGroup, "neura_symbol_bottom_element.png", 103, 53)
	neuraSymbolBottom.anchorY = 0
	neuraSymbolBottom.x = display.contentCenterX
	neuraSymbolBottom.y = neuraSymbolTop.y + neuraSymbolTop.contentHeight + 5

	local neuraStatusTitle = display.newText( sceneGroup, "Neura Status:", 0, 0, native.systemFont, 22 )
	neuraStatusTitle.anchorY = 0
	neuraStatusTitle.x = display.contentCenterX
	neuraStatusTitle.y = neuraSymbolBottom.y + neuraSymbolBottom.contentHeight
	neuraStatusTitle:setFillColor( 0 )

	neuraStatusText = display.newText( sceneGroup, "", 0, 0, native.systemFont, 22 )
	neuraStatusText.anchorY = 0
	neuraStatusText.x = display.contentCenterX
	neuraStatusText.y = neuraStatusTitle.y + neuraStatusTitle.contentHeight

	servicesBtn = widget.newButton( {
			top = neuraStatusText.y + neuraStatusText.contentHeight + 10 + 40,
			label = "SERVICES",
			fontSize = 13,
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			shape = "rect",
			fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
			width = display.contentWidth - 60,
			onRelease = services
		} )	
	servicesBtn.x = display.contentCenterX
	sceneGroup:insert(servicesBtn)

	requestPermissionsBtn = widget.newButton( {
			top = neuraStatusText.y + neuraStatusText.contentHeight + 10 + 40,
			label = "CONNECT AND REQUEST PERMISSIONS",
			fontSize = 13,
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			shape = "rect",
			fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
			width = display.contentWidth - 60,
			onRelease = requestPermissions
		} )	
	requestPermissionsBtn.x = display.contentCenterX
	sceneGroup:insert(requestPermissionsBtn)


	addDeviceBtn = widget.newButton( {
			top = requestPermissionsBtn.y + requestPermissionsBtn.contentHeight/2 + 10,
			label = "DEVICE OPERATIONS",
			fontSize = 13,
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			shape = "rect",
			fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
			width = (display.contentWidth - 60)/2-5,
			onRelease = addDevice
		} )	
	addDeviceBtn.anchorX = 0
	addDeviceBtn.x = 30
	sceneGroup:insert(addDeviceBtn)

	addLocationBtn = widget.newButton( {
			top = requestPermissionsBtn.y + requestPermissionsBtn.contentHeight/2 + 10,
			label = "ADD A LOCATION",
			fontSize = 13,
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			shape = "rect",
			fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
			width = (display.contentWidth - 60)/2-5,
			onRelease = addLocation
		} )	
	addLocationBtn.anchorX = 1
	addLocationBtn.x = display.contentWidth - 30
	sceneGroup:insert(addLocationBtn)

	simulateEventBtn = widget.newButton( {
			top = addDeviceBtn.y + addDeviceBtn.contentHeight/2 + 10,
			label = "SIMULATE AN EVENT",
			fontSize = 13,
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			shape = "rect",
			fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
			width = (display.contentWidth - 60)/2-5,
			onRelease = simulateEvent
		} )	
	simulateEventBtn.anchorX = 0
	simulateEventBtn.x = 30
	sceneGroup:insert(simulateEventBtn)

	disconnectBtn = widget.newButton( {
			top = addDeviceBtn.y + addDeviceBtn.contentHeight/2 + 10,
			label = "DISCONNECT",
			fontSize = 13,
			labelColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
			shape = "rect",
			fillColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			width = (display.contentWidth - 60)/2-5,
			onRelease = disconnect
		} )	
	disconnectBtn.anchorX = 1
	disconnectBtn.x = display.contentWidth - 30
	sceneGroup:insert(disconnectBtn)

	setUIState(neura.isLoggedIn())
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

		setUIState(neura.isLoggedIn())
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		if phoneTextField ~= nil then
			phoneTextField:removeSelf()
			phoneTextField = nil
		end
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene