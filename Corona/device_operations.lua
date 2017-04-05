local composer = require( "composer" )
 
local scene = composer.newScene()
local widget = require "widget"

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local capabilityTextField
local addDeviceByCapabilityTextField
local addDeviceByNameTextField

local getAllCapabilitiesBtn
local addADeviceBtn
local addDeviceByCapabilityBtn

local function getAllDevicesListener(event)
	if event.type == "Success" then
		local devices = event.data.items
		toast.show("Successfully received " .. #devices .. " devices")
		print("Successfully received " .. #devices .. " devices")
	else
		toast.show("Failed to receive devices list")
		print("Failed to receive devices list")
	end
end

local function getAllDevices()
	neura.getKnownDevices(getAllDevicesListener)
end

local function getAllCapabilities()
	local capabilities = neura.getKnownCapabilities()
	toast.show("Successfully received " .. #capabilities .. " capabilities")
	print("Successfully received " .. #capabilities .. " capabilities")
end

local function hasDeviceWithCapability()
	local capability = capabilityTextField.text
	toast.show("User " .. (neura.hasDeviceWithCapability(capability) and "has " or "doesn't have ") .. "device with capability " .. capability)
	print("User " .. (neura.hasDeviceWithCapability(capability) and "has " or "doesn't have ") .. "device with capability " .. capability)
end

local function addDeviceListener(event)
	toast.show(event.response and "Add device completed successfully" or "Add device wasn't completed")
	print(event.response and "Add device completed successfully" or "Add device wasn't completed")
end

local function addADevice()
	neura.addDevice(addDeviceListener)
end

local function addDeviceByCapabilityTextField()
	if (addDeviceByCapabilityTextField.text == "") then
		toast.show("Can't add device, capabilities are blank")
	else
		neura.addDevice({deviceCapabilityNames = {addDeviceByCapabilityTextField.text}}, addDeviceListener)
	end
end

local function addDeviceByName()
	if (addDeviceByNameTextField.text == "") then
		toast.show("Please set a device name")
	else
		neura.addDevice({deviceName = {addDeviceByNameTextField.text}}, addDeviceListener)
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

	local getAllDevicesText = display.newText( {
	    text = "Receive a list of all supported devices",
	    width = (display.contentWidth - 60)/2-5,
	    font = native.systemFont,
	    fontSize = 11,
	    align = "center"
	} )
	getAllDevicesText.anchorX = 0
	getAllDevicesText.anchorY = 0
	getAllDevicesText.x = 30
	getAllDevicesText.y = logo.y + logo.contentHeight + 5
	getAllDevicesText:setFillColor( 0 )
	sceneGroup:insert(getAllDevicesText)

	local getAllCapabilitiesText = display.newText( {
	    text = "Receive a list of all supported capabilities",
	    width = (display.contentWidth - 60)/2-5,
	    font = native.systemFont,
	    fontSize = 11,
	    align = "center"
	} )
	getAllCapabilitiesText.anchorX = 1
	getAllCapabilitiesText.anchorY = 0
	getAllCapabilitiesText.x = display.contentWidth - 30
	getAllCapabilitiesText.y = logo.y + logo.contentHeight + 5
	getAllCapabilitiesText:setFillColor( 0 )
	sceneGroup:insert(getAllCapabilitiesText)

	local getAllDevicesBtn = widget.newButton( {
	    top = getAllDevicesText.y + getAllDevicesText.contentHeight + 10,
		label = "GET DEVICES",
		fontSize = 13,
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		shape = "rect",
		fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
		width = (display.contentWidth - 60)/2-5,
		onRelease = getAllDevices
	} )
	getAllDevicesBtn.anchorX = 0
	getAllDevicesBtn.x = 30
	sceneGroup:insert(getAllDevicesBtn)

	getAllCapabilitiesBtn = widget.newButton( {
	    top = getAllDevicesText.y + getAllDevicesText.contentHeight + 10,
		label = "GET CAPABILITIES",
		fontSize = 13,
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		shape = "rect",
		fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
		width = (display.contentWidth - 60)/2-5,
		onRelease = getAllCapabilities
	} )
	getAllCapabilitiesBtn.anchorX = 1
	getAllCapabilitiesBtn.x = display.contentWidth - 30
	sceneGroup:insert(getAllCapabilitiesBtn)


	local hasDeviceWithCapabilityBtn = widget.newButton( {
	    top = getAllCapabilitiesBtn.y + getAllCapabilitiesBtn.contentHeight/2 + 45,
		label = "HAS DEVICE WITH CAPABILITY",
		fontSize = 13,
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		shape = "rect",
		fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
		width = (display.contentWidth - 60),
		onRelease = hasDeviceWithCapability
	} )
	hasDeviceWithCapabilityBtn.x = display.contentCenterX
	sceneGroup:insert(hasDeviceWithCapabilityBtn)

	local addADeviceText = display.newText( {
	    text = "Show a list of supported devices",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 11,
	} )
	addADeviceText.anchorX = 0
	addADeviceText.anchorY = 0
	addADeviceText.x = 30
	addADeviceText.y = hasDeviceWithCapabilityBtn.y + hasDeviceWithCapabilityBtn.contentHeight/2 + 10
	addADeviceText:setFillColor( 0 )
	sceneGroup:insert(addADeviceText)

	addADeviceBtn = widget.newButton( {
	    top = addADeviceText.y + addADeviceText.contentHeight + 5,
		label = "ADD A DEVICE",
		fontSize = 13,
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		shape = "rect",
		fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
		width = (display.contentWidth - 60),
		onRelease = addADevice
	} )
	addADeviceBtn.x = display.contentCenterX
	sceneGroup:insert(addADeviceBtn)

	addDeviceByCapabilityBtn = widget.newButton( {
	    top = addADeviceBtn.y + addADeviceBtn.contentHeight/2 + 45,
		label = "ADD A DEVICE BY CAPABILITY",
		fontSize = 13,
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		shape = "rect",
		fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
		width = (display.contentWidth - 60),
		onRelease = addDeviceByCapability
	} )
	addDeviceByCapabilityBtn.x = display.contentCenterX
	sceneGroup:insert(addDeviceByCapabilityBtn)

	local addDeviceByNameBtn = widget.newButton( {
	    top = addDeviceByCapabilityBtn.y + addDeviceByCapabilityBtn.contentHeight/2 + 45,
		label = "ADD A DEVICE BY NAME",
		fontSize = 13,
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		shape = "rect",
		fillColor = {default = {0, 0.8, 1}, over = {0, 0.4, 0.5}},
		width = (display.contentWidth - 60),
		onRelease = addDeviceByName
	} )
	addDeviceByNameBtn.x = display.contentCenterX
	sceneGroup:insert(addDeviceByNameBtn)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		capabilityTextField = native.newTextField(display.contentCenterX, 0, display.contentWidth - 60, 30 )
		capabilityTextField.anchorY = 0
		capabilityTextField.placeholder = "For example: sleepQuality"
		capabilityTextField.y = getAllCapabilitiesBtn.y + getAllCapabilitiesBtn.contentHeight/2 + 10

		addDeviceByCapabilityTextField = native.newTextField(display.contentCenterX, 0, display.contentWidth - 60, 30 )
		addDeviceByCapabilityTextField.anchorY = 0
		addDeviceByCapabilityTextField.placeholder = "For example: heartRate"
		addDeviceByCapabilityTextField.y = addADeviceBtn.y + addADeviceBtn.contentHeight/2 + 10

		addDeviceByNameTextField = native.newTextField(display.contentCenterX, 0, display.contentWidth - 60, 30 )
		addDeviceByNameTextField.anchorY = 0
		addDeviceByNameTextField.placeholder = "Enter Device Name"
		addDeviceByNameTextField.y = addDeviceByCapabilityBtn.y + addDeviceByCapabilityBtn.contentHeight/2 + 10
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
		capabilityTextField:removeSelf()
		capabilityTextField = nil

		addDeviceByCapabilityTextField:removeSelf()
		addDeviceByCapabilityTextField = nil

		addDeviceByNameTextField:removeSelf()
		addDeviceByNameTextField = nil
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end

local function onKeyEvent( event )
    -- If the "back" key was pressed on Android or Windows Phone, make sure it gets back to menu
    if ( event.keyName == "back" ) then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
            composer.gotoScene( "menu" )
        end
        return true
    end
    return false
end
Runtime:addEventListener( "key", onKeyEvent )


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene