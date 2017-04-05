local composer = require( "composer" )
 
local scene = composer.newScene()
local widget = require "widget"

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local updateUI

local scrollView
local situationText
local dailySummaryHeader
local dailySummaryDescription
local dailySummaryText
local sleepDataHeader
local sleepDataDescription
local sleepDataText

local function updateUI()
	dailySummaryHeader.y = situationText.y + situationText.contentHeight + 20
	dailySummaryDescription.y = dailySummaryHeader.y + dailySummaryHeader.contentHeight + 5
	dailySummaryText.y = dailySummaryDescription.y + dailySummaryDescription.contentHeight + 5

	sleepDataHeader.y = dailySummaryText.y + dailySummaryText.contentHeight + 20
	sleepDataDescription.y = sleepDataHeader.y + sleepDataHeader.contentHeight + 5
	sleepDataText.y = sleepDataDescription.y + sleepDataDescription.contentHeight + 5

	scrollView:setScrollHeight(sleepDataText.y + sleepDataText.contentHeight)

end

local function getSituationListener(event)
	if event.type == "Success" then
		local situationData = event.data
		situationText.text = json.prettify(situationData)
		updateUI()
		print("Situation received successfully: ".. situationText.text)
	else
		print("Failed to receive situation: "..event.response)
	end
end

local function getDailySummaryListener(event)
	if event.type == "Success" then
		local dailySummaryData = event.data
		dailySummaryText.text = json.prettify(dailySummaryData)
		updateUI()
		print("Daily summary received successfully: ".. dailySummaryText.text)
	else
		print("Failed to receive daily summary: "..event.response)
	end
end

local function getSleepProfileListener(event)
	if event.type == "Success" then
		local sleepProfileData = event.data
		sleepDataText.text = json.prettify(sleepProfileData)
		updateUI()
		print("Sleep Profile received successfully: ".. sleepDataText.text)
	else
		print("Error at receiving sleep data: "..event.response)
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

	scrollView = widget.newScrollView(
	    {
	        top = 30,
	        left = 30,
	        width = display.contentWidth - 60,
	        height = display.contentHeight - 40,
	        backgroundColor = {0.96, 0.96, 0.96}
	    }
	)
	sceneGroup:insert(scrollView)

	local logo = display.newImageRect("neura_sdk_demo_logo.png", 186, 18)
	logo.anchorX = 0
	logo.x = 0
	logo.anchorY = 0
	logo.y = 0
	scrollView:insert(logo)

	local situationHeader = display.newText("Progressive Situation", 0, 0, native.systemFont, 18 )
	situationHeader.anchorX = 0
	situationHeader.x = 0
	situationHeader.anchorY = 0
	situationHeader.y = logo.y + logo.contentHeight + 10
	situationHeader:setFillColor( 0, 0.8, 1 )
	scrollView:insert(situationHeader)

	local situationDescription = display.newText( {
	    text = "Generate a report for situation - according to a timestamp you set (in this sample - the timestamp is 30 minutes ago), neura will return where the user was before, during and after that timestamp",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 11,
	} )
	situationDescription.anchorX = 0
	situationDescription.x = 0
	situationDescription.anchorY = 0
	situationDescription.y = situationHeader.y + situationHeader.contentHeight + 5
	situationDescription:setFillColor( 0 )
	scrollView:insert(situationDescription)

	situationText = display.newText( {
	    text = " ",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 13,
	} )
	situationText.anchorX = 0
	situationText.x = 0
	situationText.anchorY = 0
	situationText.y = situationDescription.y + situationDescription.contentHeight + 5
	situationText:setFillColor( 0 )
	scrollView:insert(situationText)

	dailySummaryHeader = display.newText("Daily Summary", 0, 0, native.systemFont, 18 )
	dailySummaryHeader.anchorX = 0
	dailySummaryHeader.x = 0
	dailySummaryHeader.anchorY = 0
	dailySummaryHeader.y = situationText.y + situationText.contentHeight + 20
	dailySummaryHeader:setFillColor( 0, 0.8, 1 )
	scrollView:insert(dailySummaryHeader)

	dailySummaryDescription = display.newText( {
	    text = "Wellness information and avarage data for yesterday",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 11,
	} )
	dailySummaryDescription.anchorX = 0
	dailySummaryDescription.x = 0
	dailySummaryDescription.anchorY = 0
	dailySummaryDescription.y = dailySummaryHeader.y + dailySummaryHeader.contentHeight + 5
	dailySummaryDescription:setFillColor( 0 )
	scrollView:insert(dailySummaryDescription)

	dailySummaryText = display.newText( {
	    text = " ",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 13,
	} )
	dailySummaryText.anchorX = 0
	dailySummaryText.x = 0
	dailySummaryText.anchorY = 0
	dailySummaryText.y = dailySummaryDescription.y + dailySummaryDescription.contentHeight + 5
	dailySummaryText:setFillColor( 0 )
	scrollView:insert(dailySummaryText)

	sleepDataHeader = display.newText("Sleep Data", 0, 0, native.systemFont, 18 )
	sleepDataHeader.anchorX = 0
	sleepDataHeader.x = 0
	sleepDataHeader.anchorY = 0
	sleepDataHeader.y = dailySummaryText.y + dailySummaryText.contentHeight + 20
	sleepDataHeader:setFillColor( 0, 0.8, 1 )
	scrollView:insert(sleepDataHeader)

	sleepDataDescription = display.newText( {
	    text = "Average sleep information for the past 5 days",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 11,
	} )
	sleepDataDescription.anchorX = 0
	sleepDataDescription.x = 0
	sleepDataDescription.anchorY = 0
	sleepDataDescription.y = sleepDataHeader.y + sleepDataHeader.contentHeight + 5
	sleepDataDescription:setFillColor( 0 )
	scrollView:insert(sleepDataDescription)

	sleepDataText = display.newText( {
	    text = " ",
	    width = (display.contentWidth - 60),
	    font = native.systemFont,
	    fontSize = 13,
	} )
	sleepDataText.anchorX = 0
	sleepDataText.x = 0
	sleepDataText.anchorY = 0
	sleepDataText.y = sleepDataDescription.y + sleepDataDescription.contentHeight + 5
	sleepDataText:setFillColor( 0 )
	scrollView:insert(sleepDataText)

	updateUI()

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		neura.getUserSituation((os.time()-60 * 30)*1000, getSituationListener)
		neura.getDailySummary((os.time()-60 * 60 * 24)*1000, getDailySummaryListener)
		neura.getSleepProfile((os.time()-5 * 60 * 60 * 24)*1000, os.time()*1000, getSleepProfileListener)
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