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
require( 'src.BuildRow' )
require( 'src.BuildItem' )
require( 'src.resources.Globals' )
local widget = require( "widget" )
local composer = require( "composer" )
local DBManager = require( 'src.resources.DBManager' )
local RestManager = require( 'src.resources.RestManager' )
--local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpMessage
local scene = composer.newScene()
local tools

local dbConfig = DBManager.getSettings()

--variables
local svMessage
local idMSG
local itemAdmin

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Carga los datos del mensaje
-------------------------------------
function setItemsAdmin( item )
	itemAdmin = item
	
	getBuildMessageItem()
	tools:setLoading( false, grpLoading )
end

-------------------------------------
-- Contruye el mensaje
-------------------------------------
function getBuildMessageItem( event )
	
	lastY = 30
	
	local srvW = svMessage.contentWidth
	local srvH = svMessage.contentHeight
	
	local bgMessage0 = display.newRect( srvW/2, 15, srvW - 20, 200 )
	bgMessage0:setFillColor( unpack(cGrayB) )   
    svMessage:insert(bgMessage0)
	bgMessage0.anchorY = 0
	
	local bgMessage = display.newRect( srvW/2, 16, srvW - 22, 198 )
	bgMessage:setFillColor( unpack(cWhite) )   
    svMessage:insert(bgMessage)
	bgMessage.anchorY = 0
	
	--svMessage
	local labelDate = display.newText( {
        text = itemAdmin.dia .. ", " .. itemAdmin.fechaFormat .. " " .. itemAdmin.hora,
        x = srvW/2 + 20, y = lastY,
        width = srvW - 30,
        font = fLight, fontSize = 14, align = "left"
    })
    labelDate:setFillColor( unpack(cDarkBlue) )
    svMessage:insert( labelDate )
	labelDate.alpha = .73
	
	lastY = lastY + 25
	
	local labelFrom = display.newText( {
        text = "DE: Administracion",
         x = srvW/2 + 20, y = lastY,
        width = srvW - 30,
        font = fBold, fontSize = 16, align = "left"
    })
    labelFrom:setFillColor( unpack(cDarkBlue) )
    svMessage:insert( labelFrom )
	
	lastY = lastY + 25
	
	local labelSubject = display.newText( {
        text = "Asunto: " .. itemAdmin.asunto,
         x = srvW/2 + 20, y = lastY,
        width = srvW - 30,
        font = fBold, fontSize = 16, align = "left"
    })
    labelSubject:setFillColor( unpack(cDarkBlue) )
    svMessage:insert( labelSubject )
	
	lastY = lastY + 25
	
	local line1 = display.newLine( 10, lastY, srvW - 10, lastY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	svMessage:insert(line1)
	
	lastY = lastY + 10
	
	local labelMessage = display.newText( {
        text = itemAdmin.mensaje,
		x = srvW/2 + 20, y = lastY,
		width = srvW - 30,
        font = fRegular, fontSize = 14, align = "left"
    })
    labelMessage:setFillColor( unpack(cDarkBlue) )
    svMessage:insert( labelMessage )
	labelMessage.anchorY = 0
	
	bgMessage0.height = lastY + labelMessage.height + 32
	
	bgMessage.height = lastY + labelMessage.height + 30
	
	lastY = lastY + 85
	
	local bg0 = display.newRect( srvW/2, lastY, srvW - 20, 50 )
	bg0:setFillColor( unpack(cGrayL) )
    svMessage:insert(bg0)
	bg0.anchorY = 0
	bg0.alpha = .02
	bg0.screen = "Messages"
	bg0:addEventListener( 'tap', toScreen )
	
	local iconReturn = display.newImage( "img/btn/return.png" )
	iconReturn:translate( 65 , lastY + 25 )
	iconReturn:setFillColor( unpack(cDarkBlue) )
	svMessage:insert( iconReturn )
	--iconReturn.height = 29
	--iconReturn.width = 30
	
	local labelReturn = display.newText( {
        text = "Regresar a Mensajes",
		x = srvW/2 + 90, y = lastY + 25,
		width = srvW,
        font = fRegular, fontSize = 15, align = "left"
    })
    labelReturn:setFillColor( unpack(cDarkBlue) )
    svMessage:insert( labelReturn )
	
	lastY = lastY + labelMessage.height + 100
	
	svMessage:setScrollHeight(lastY)
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    --screen.y = h
	
	idMSG = event.params.id
    
    local o = display.newRect( midW, midH + h, intW+8, intH )
    o:setFillColor( unpack(cWhite) )   
    screen:insert(o)
	tools = Tools:new()
	screen:insert(tools)
	--header
	tools:buildHeader()
	
	--menu left
	tools:buildTooLeft()
	
    -- group login
    grpMessage = display.newGroup()
    screen:insert( grpMessage )
	
	svMessage = widget.newScrollView{
		top =  h + 71,
		left = 86,
		width = intW - 85,
		height = intH - ( h + 69),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	}
	grpMessage:insert(svMessage)
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	tools:setLoading( true, grpLoading )
	
	RestManager.getMessageToAdminById(idMSG)
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide Scene
function scene:hide( event )
end

-- Remove Scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene