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
local screen, grpHome
local scene = composer.newScene()
local tools = Tools:new()

-- Variables
local newH = 0

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------


function gotoScreen( event )
	
	local t = event.target
	
	t.alpha = .75
	
	timer.performWithDelay( 100, function() t.alpha = 1  end )
	
	return true
end


function onTxtFocus( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( event.target.text )

    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    --screen.y = h
    
    local o = display.newRect( midW, midH + h, intW+8, intH )
    o:setFillColor( unpack(cWhite) )   
    screen:insert(o)
	
	--header
	tools:buildHeaderLogin()
    screen:insert(tools)
	
    -- group login
    grpHome = display.newGroup()
    screen:insert( grpHome )
	
	local posY = 155 + h
	
	local lblLogin = display.newText({
		text = "BIENVENIDO",
		y = posY,x = midW,
		font = fBold, fontSize = 30, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	grpHome:insert(lblLogin)
	
	posY = posY + 115
	
	local iconLogo = display.newImage("img/bgk/icono_logo2.png")
	iconLogo:translate( midW , posY)
	grpHome:insert( iconLogo )
	iconLogo.height = 129
	iconLogo.width = 128
	
	posY = posY + 160
	
	--btn visitante
	local bgVisit = display.newRect( midW, posY, intW - 96, 64 )
    bgVisit:setFillColor( unpack(cGrayL) )   
	bgVisit.fill = gGreenBlue
    grpHome:insert(bgVisit)
	
	local btnVisit = display.newRect( midW, posY, intW - 100, 60 )
    btnVisit:setFillColor( unpack(cWhite) )
    grpHome:insert(btnVisit)
	btnVisit:addEventListener( 'tap', gotoScreen )
	
	local lblVisit = display.newText({
		text = "VISITANTE",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblVisit:setFillColor( unpack(cBlack) )
	grpHome:insert(lblVisit)
	
	local imgBgVisit = display.newImage("img/btn/bgCircleGradient.png")
	imgBgVisit:translate( 100 , posY - 5)
	grpHome:insert( imgBgVisit )
	
	local imgBgVisit1 = display.newImage("img/btn/circleWhite.png")
	imgBgVisit1:translate( 100 , posY - 5)
	grpHome:insert( imgBgVisit1 )
	
	local imgVisit = display.newImage("img/btn/visit.png")
	imgVisit:translate( 100 , posY - 5)
	imgVisit:setFillColor( unpack(cBlack) )
	grpHome:insert( imgVisit )
	
	posY = posY + 150
	
	--btn residente
	local bgResident = display.newRect( midW, posY, intW - 96, 64 )
    bgResident:setFillColor( unpack(cGrayL) )   
	bgResident.fill = gGreenBlue
    grpHome:insert(bgResident)
	
	local btnResident = display.newRect( midW, posY, intW - 100, 60 )
    btnResident:setFillColor( unpack(cWhite) )
    grpHome:insert(btnResident)
	btnResident:addEventListener( 'tap', gotoScreen )
	
	local lblResident = display.newText({
		text = "RESIDENTE",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblResident:setFillColor( unpack(cBlack) )
	grpHome:insert(lblResident)
	
    
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