---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require( 'src.Tools' )
require( 'src.resources.Globals' )
local composer = require( "composer" )
local DBManager = require( 'src.resources.DBManager' )
local RestManager = require( 'src.resources.RestManager' )
--local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpReport, grpReportField
local scene = composer.newScene()
local tools

local dbConfig = DBManager.getSettings()
-- Variables
local newH = 0
local grpLoading
local itemsGuard
local first = 0
local txtSubject, txtMessage
local btnSend

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

--------------------------------------
-- Envia la queja o sugerencia
--------------------------------------
function sendMessage( )
	native.setKeyboardFocus( nil )
	btnSend:removeEventListener( 'tap', sendMessage )
	if trimString( txtSubject.text ) ~= '' and trimString( txtMessage.text ) ~= '' then
		tools:setLoading( true, grpLoading )
		grpReportField.x = intW
		RestManager.sendSuggestion( trimString( txtSubject.text ), trimString( txtMessage.text ) )
	else
		grpReportField.x = intW
		resultMessage('Campos Vacíos')
	end
	return true
end

--------------------------------------------------
-- Muestra un mensaje cuando se envia la queja
--------------------------------------------------
function resultMessage( message )
	NewAlert( true, 'Howe Residentes', message )
	timeMarker = timer.performWithDelay( 1000, function()
		NewAlert( false, 'Howe Residentes', message )
		grpReportField.x = 0
		btnSend:addEventListener( 'tap', sendMessage )
		tools:setLoading( false, grpLoading )
	end, 1 )
end

--------------------------------------
-- Limpia los campos
--------------------------------------
function cleanTextFieldReport()
	if txtSubject then
		txtSubject.text = ""
	end
	if txtMessage then
		txtMessage.text = ""
	end
end

-------------------------------------------------------
-- Crea los elementos de la pantalla de reporte
-------------------------------------------------------
function createReportItems()

	local screenW = intW - 85

	posY = 115 + h
	
	local bgTitle = display.newRect( screenW/2 + 85, posY - 45, screenW, 45 )
	bgTitle:setFillColor( unpack( cWhite ) )   
    grpReport:insert(bgTitle)
	bgTitle.anchorY = 0
	
	-- titulo
	local lblTitle = display.newText( {
        text = "Quejas y sugerencias",
        x = screenW/2 + 85, y = posY - 23,
        width = screenW - 30,
        font = fBold, fontSize = 18, align = "center"
    })
    lblTitle:setFillColor( unpack(cDarkBlue) )
    grpReport:insert( lblTitle )
	
	local line1 = display.newLine( 85, posY, intW, posY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	grpReport:insert(line1)
	
	-- elementos
	
	posY = posY + 55
	
	-- bg
	local bg0 = display.newRect( screenW/2 + 85, posY - 45, screenW - 20, 400 )
	bg0:setFillColor( unpack( cGrayB ) )   
    grpReport:insert(bg0)
	bg0.anchorY = 0
	
	local bg1 = display.newRect( screenW/2 + 85, posY - 43, screenW - 24, 396 )
	bg1:setFillColor( unpack( cWhite ) )   
    grpReport:insert(bg1)
	bg1.anchorY = 0
	
	-- asunto
	posY = posY + 25
	
	local bgSubject0 = display.newRect( screenW/2 + 85, posY - 43, screenW - 70, 60 )
	bgSubject0:setFillColor( unpack( cWhite ) )
	bgSubject0.fill = gGreenBlue
    grpReport:insert(bgSubject0)
	bgSubject0.anchorY = 0
	
	local bgSubject1 = display.newRect( screenW/2 + 85, posY - 42, screenW - 72, 58 )
	bgSubject1:setFillColor( unpack( cWhite ) )
    grpReport:insert(bgSubject1)
	bgSubject1.anchorY = 0
	
	txtSubject = native.newTextField( screenW/2 + 85, posY - 40,  screenW - 80, 54 )
	txtSubject.name = "subject"
    txtSubject.hasBackground = false
	txtSubject.placeholder = "ASUNTO"
	txtSubject:setTextColor( unpack(cDarkBlue) )
	txtSubject.size = 25
	txtSubject.anchorY = 0
    --txtSubject:addEventListener( "userInput", onTxtFocus )
	grpReportField:insert(txtSubject)
	
	-- mensaje
	posY = posY + 80
	
	local bgMessage0 = display.newRect( screenW/2 + 85, posY - 43, screenW - 70, 180 )
	bgMessage0:setFillColor( unpack( cWhite ) )
	bgMessage0.fill = gGreenBlue
    grpReport:insert(bgMessage0)
	bgMessage0.anchorY = 0
	
	local bgMessage1 = display.newRect( screenW/2 + 85, posY - 42, screenW - 72, 178 )
	bgMessage1:setFillColor( unpack( cWhite ) )
    grpReport:insert(bgMessage1)
	bgMessage1.anchorY = 0
	
	txtMessage = native.newTextBox( screenW/2 + 85, posY - 40,  screenW - 80, 170 )
	txtMessage.name = "message"
    txtMessage.hasBackground = false
	txtMessage.placeholder = "ASUNTO"
	txtMessage:setTextColor( unpack(cDarkBlue) )
	txtMessage.size = 25
	txtMessage.anchorY = 0
	txtMessage.isEditable = true
    --txtSubject:addEventListener( "userInput", onTxtFocus )
	grpReportField:insert(txtMessage)
	
	-- boton  enviar
	posY = posY + 160
	
	local bgSend = display.newRect( screenW/2 + 85, posY, screenW - 70, 60 )
	bgSend:setFillColor( unpack( cWhite ) )
	bgSend.fill = gGreenBlue
    grpReport:insert( bgSend )
	bgSend.anchorY = 0
	
	btnSend = display.newRect( screenW/2 + 85, posY + 1, screenW - 72, 58 )
	btnSend:setFillColor( unpack( cWhite ) )
    grpReport:insert( btnSend )
	btnSend.anchorY = 0
	btnSend:addEventListener( 'tap', sendMessage )
	
	local lblSend = display.newText( {
		text = "ENVIAR",
		x = screenW/2 + 85, y = posY + 30,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblSend:setFillColor( unpack(cDarkBlue) )
	grpReport:insert(lblSend)
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    --screen.y = h
    
    local o = display.newRect( midW, midH + h, intW+8, intH )
    o:setFillColor( unpack(cGrayL) )   
    screen:insert(o)
	tools = Tools:new()
	screen:insert(tools)
	--header
	tools:buildHeader()
	
	--menu left
	tools:buildTooLeft()
	
    -- group login
    grpReport = display.newGroup()
    screen:insert( grpReport )
	
	grpReportField = display.newGroup()
    screen:insert( grpReportField )
	
	--createGuard()
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2) )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	createReportItems()
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide Scene
function scene:hide( event )
	
	if grpReportField then
		grpReportField:removeSelf()
		grpReportField = nil
	end
	
end

-- Remove Scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene