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
local screen, grpUserType
local scene = composer.newScene()
local tools = Tools:new()

-- Variables
local newH = 0

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

------------------------------------------------------
-- Envia al tipo de usuario seleccionado
------------------------------------------------------
function gotoScreen( event )
	
	local t = event.target
	
	t.alpha = .75
	
	timer.performWithDelay( 100, function() 
		t.alpha = 1  
		composer.removeScene( "src."..t.screen )
		--composer.gotoScene("src."..t.screen )
        composer.gotoScene("src."..t.screen, { time = 400, effect = "fromRight" } )
	end )
	
	return true
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
    grpUserType = display.newGroup()
    screen:insert( grpUserType )
	
	local posY = 115 + h
	
	local lblLogin = display.newText({
		text = "BIENVENIDO",
		y = posY,x = midW,
		font = fBold, fontSize = 30, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	grpUserType:insert(lblLogin)
	
	posY = posY + 115
	
	local iconLogo = display.newImage("img/bgk/icono_logo2.png")
	iconLogo:translate( midW , posY)
	grpUserType:insert( iconLogo )
	iconLogo.height = 129
	iconLogo.width = 128
	
	posY = posY + 150
	
	--btn guardia
	local bgVisit = display.newRect( midW, posY, intW - 96, 64 )
    bgVisit:setFillColor( unpack(cGrayL) )
	
	bgVisit.fill = gGreenBlue
    grpUserType:insert(bgVisit)
	
	local btnVisit = display.newRect( midW, posY, intW - 100, 60 )
    btnVisit:setFillColor( unpack(cWhite) )
    grpUserType:insert(btnVisit)
	btnVisit.screen = "admin.Login"
	btnVisit:addEventListener( 'tap', gotoScreen )
	
	local lblVisit = display.newText({
		text = "SEGURIDAD",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblVisit:setFillColor( unpack(cBlack) )
	grpUserType:insert(lblVisit)
	
	local imgBgVisit = display.newImage("img/btn/bgCircleGradient.png")
	imgBgVisit:translate( 90 , posY - 5)
	grpUserType:insert( imgBgVisit )
	
	local imgBgVisit1 = display.newImage("img/btn/circleWhite.png")
	imgBgVisit1:translate( 90 , posY - 5)
	grpUserType:insert( imgBgVisit1 )
	
	local imgVisit = display.newImage("img/btn/guardia2.png")
	imgVisit:translate( 90 , posY - 5)
	imgVisit:setFillColor( unpack(cBlack) )
	grpUserType:insert( imgVisit )
	
	posY = posY + 150
	
	--btn residente
	local bgResident = display.newRect( midW, posY, intW - 96, 64 )
    bgResident:setFillColor( unpack(cGrayL) )   
	bgResident.fill = gGreenBlue
    grpUserType:insert(bgResident)
	
	local btnResident = display.newRect( midW, posY, intW - 100, 60 )
    btnResident:setFillColor( unpack(cWhite) )
	btnResident.screen = "LoginFacebook"
    grpUserType:insert(btnResident)
	btnResident:addEventListener( 'tap', gotoScreen )
	
	local lblResident = display.newText({
		text = "RESIDENTE",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblResident:setFillColor( unpack(cBlack) )
	grpUserType:insert(lblResident)
	
	local imgBgVisit = display.newImage("img/btn/bgCircleGradient.png")
	imgBgVisit:translate( intW - 90 , posY - 5)
	grpUserType:insert( imgBgVisit )
	
	local imgBgVisit1 = display.newImage("img/btn/circleWhite.png")
	imgBgVisit1:translate( intW - 90 , posY - 5)
	grpUserType:insert( imgBgVisit1 )
	
	local imgVisit = display.newImage("img/btn/visit.png")
	imgVisit:translate( intW - 90 , posY - 5)
	imgVisit:setFillColor( unpack(cBlack) )
	grpUserType:insert( imgVisit )
	
    
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