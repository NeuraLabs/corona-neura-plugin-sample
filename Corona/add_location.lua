local composer = require( "composer" )
 
local scene = composer.newScene()
local widget = require "widget"

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local locations
local clickedRow = 0

local function getMissingDataForEventListener(event)
	if event.type == "Success" then
		print("Successfully added a place for the event : " .. locations[clickedRow])
	else
		print("Failed to add a place for the event : " .. locations[clickedRow])
	end
end

local function onRowRender( event )
 
    -- Get reference to the row group
    local row = event.row
 
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
 
    local rowTitle = display.newText( row, locations[row.index], 0, 0, nil, 14 )

    rowTitle:setFillColor( 0 )
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 15
    rowTitle.y = rowHeight * 0.5
end

local function onRowTouch( event )
 
    -- Get reference to the row group
    local row = event.row
    clickedRow = row.index
 
    neura.getMissingDataForEvent(locations[clickedRow], getMissingDataForEventListener)
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

	local addLocationText = display.newText( {
	    text = "Your user can add a semantic location whenever you wish to.\nOverall, Neura detects important locations in your user's life, but in case you want your user to set it up, this picker should be presented.",
	    width = display.contentWidth - 60,
	    font = native.systemFont,
	    fontSize = 11,
	    align = "left"
	} )
	addLocationText.anchorX = 0
	addLocationText.anchorY = 0
	addLocationText.x = 30
	addLocationText.y = logo.y + logo.contentHeight + 10
	addLocationText:setFillColor( 0 )
	sceneGroup:insert(addLocationText)


	local locationBasedEventsTableView = widget.newTableView(
    {
        left = 30,
        top = addLocationText.y + addLocationText.contentHeight + 10,
        width = display.contentWidth - 60,
        height = display.contentHeight - addLocationText.y - addLocationText.contentHeight - 20,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        hideBackground = true
    })
    sceneGroup:insert(locationBasedEventsTableView)

    locations = neura.getLocationBasedEvents()

	for i = 1, #locations do
	    -- Insert a row into the tableView
	    locationBasedEventsTableView:insertRow{
	    	rowColor = { default={0,0,0,0}, over={0.2, 0.2, 0.2, 0.2} }
	    }
	end

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
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