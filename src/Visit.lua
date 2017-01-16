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
local screen, grpVisit, grpDetail, grpNew
local scene = composer.newScene()
local tools
local svVisit

local dbConfig = DBManager.getSettings()
-- Variables
local newH = 0
local grpLoading
local idMSG

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

--------------------------------------
-- Carga los elementos
-- @params item los datos de la visita
--------------------------------------
function setItemsVisit(item)
	
	itemVisit = item
	getBuildVisitItem()
	tools:setLoading( false, grpLoading )
	
end

--------------------------------------
-- Contruye el mensaje de visita
--------------------------------------
function getBuildVisitItem( event )
	
	lastY = 30
	local srvW = svVisit.contentWidth
	local srvH = svVisit.contentHeight
    
    grpDetail = display.newGroup()
    svVisit:insert(grpDetail)
	
	itemVisit.action = 0
    
   if itemVisit.action == '0' then
        grpNew = display.newGroup()
        svVisit:insert(grpNew)
        
        local bgCancel = display.newRect( 2, 2, 223, 60 )
        bgCancel.anchorX = 0
        bgCancel.anchorY = 0
        bgCancel:setFillColor( .7, 0, 0 )
        bgCancel.access = false
		bgCancel:addEventListener("tap", getAccess)
        grpNew:insert(bgCancel)
        
    end
	
	local labelDate = display.newText( {
        text = itemVisit.fechaFormat,
        x = srvW/2 + 20, y = lastY,
        width = srvW,
        font = fLight, fontSize = 18, align = "left"
    })
    labelDate:setFillColor( unpack(cDarkBlue) )
    grpDetail:insert( labelDate )
	
	local labelDateTime = display.newText( {
        text = itemVisit.hora,
        x = srvW/2 - 20, y = lastY,
        width = srvW,
        font = fLight, fontSize = 18, align = "right"
    })
    labelDateTime:setFillColor( unpack(cDarkBlue) )
    grpDetail:insert( labelDateTime )
	
	lastY = lastY + 70
	
	local imgVisit = display.newImage( "img/btn/visitas.png" )
	imgVisit.y = lastY
	imgVisit.x = 50
    grpDetail:insert(imgVisit)
	
	local labelVisit = display.newText( {
        text = itemVisit.nombreVisitante,
        x = 240, y = lastY,
        width = 290,
        font = fBold, fontSize = 22, align = "left"
    })
    labelVisit:setFillColor( unpack(cDarkBlue) )
    grpDetail:insert( labelVisit )
	
	lastY = lastY + 80
	
	local labelInfo = display.newText( {
        text = itemVisit.motivo,
		x = srvW/2, y = lastY,
		width = srvW - 30,
        font = fRegular, fontSize = 20, align = "left"
    })
    labelInfo:setFillColor( unpack(cDarkBlue) )
    grpDetail:insert( labelInfo )
	labelInfo.anchorY = 0
	
	lastY = lastY + labelInfo.height + 100
	
	svVisit:setScrollHeight(lastY)
	
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
    grpVisit = display.newGroup()
    screen:insert( grpVisit )
	
	svVisit = widget.newScrollView{
		top =  h + 71,
		left = 86,
		width = intW - 85,
		height = intH - ( h + 69),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	}
	grpVisit:insert(svVisit)
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	tools:setLoading( true, grpLoading )
	
	RestManager.getMessageToVisitById(idMSG)
	
	
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