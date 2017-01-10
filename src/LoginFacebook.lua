---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
require('src.resources.Globals')
local composer = require( "composer" )
--local DBManager = require('src.resources.DBManager')
--local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpLoginFace
local scene = composer.newScene()
local tools = Tools:new()

-- Variables
local newH = 0
local h = display.topStatusBarContentHeight
local txtEmail, txtPass

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

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
    grpLoginFace = display.newGroup()
    screen:insert(grpLoginFace)
	
	local posY = 115 + h
	
	local lblLogin = display.newText({
		text = "INICIA SESIÓN",
		y = posY,x = midW,
		font = fBold, fontSize = 30, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	grpLoginFace:insert(lblLogin)
	
	posY = posY + 115
	
	local iconLogo = display.newImage("img/bgk/icono_logo2.png")
	iconLogo:translate( midW , posY)
	grpLoginFace:insert( iconLogo )
	iconLogo.height = 129
	iconLogo.width = 128
	
	posY = posY + 150
	
	print(intW - 100)
	
	--btn login facebook
	--[[local btnLoginFace = display.newRect( midW, posY, intW - 96, 64 )
    btnLoginFace:setFillColor( unpack(cGrayL) )   
	btnLoginFace.fill = gGreenBlue
    grpLoginFace:insert(btnLoginFace)
	
	local btnLoginFace1 = display.newRect( midW, posY, intW - 100, 60 )
    btnLoginFace1:setFillColor( unpack(cWhite) )
    grpLoginFace:insert(btnLoginFace1)
	
	local lblLogin = display.newText({
		text = "FACEBOOK",
		y = posY,x = midW,
		font = fBold, fontSize = 25, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	lblLogin.fill = gGreenBlue
	grpLoginFace:insert(lblLogin)]]
	
	local btnLoginFace = display.newImage("img/btn/facebook.png")
	btnLoginFace:translate( midW , posY)
	grpLoginFace:insert( btnLoginFace )
	
	posY = posY + 125
	
	--btn login
	local btnLogin = display.newRect( midW, posY, intW - 96, 64 )
    btnLogin:setFillColor( unpack(cWhite) )   
	btnLogin.screen = "Login"
    grpLoginFace:insert(btnLogin)
	btnLogin:addEventListener( 'tap', gotoScreen )
	
	local lblLogin = display.newText({
		text = "INICIAR SESIÓN CON CORREO",
		y = posY,x = midW,
		font = fLight, fontSize = 22, align = "center"
	})
	lblLogin:setFillColor( unpack(cDarkBlue) )
	grpLoginFace:insert(lblLogin)
	
	posY = posY + 12
	
	local lineLogin = display.newLine( 73, posY, 403, posY )
	lineLogin:setStrokeColor( unpack(cDarkBlue) )
	lineLogin.strokeWidth = 2
	grpLoginFace:insert(lineLogin)
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
end

-- Hide Scene
function scene:hide( event )
	print( event.phase )
end

-- Remove Scene
function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene