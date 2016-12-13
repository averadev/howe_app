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
local screen, grpLogIn, grpTextFieldL
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
    grpLogIn = display.newGroup()
    screen:insert(grpLogIn)
	
	-- LogIn
    grpTextFieldL = display.newGroup()
    screen:insert(grpTextFieldL)
	
	local posY = 110 + h
	
	local lblLogin = display.newText({
		text = "INICIA SESIÓN",
		y = posY,x = midW,
		font = fBold, fontSize = 30, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	grpLogIn:insert(lblLogin)
	
	posY = posY + 110
	
	local iconLogo = display.newImage("img/bgk/icono_logo2.png")
	iconLogo:translate( midW , posY)
	grpLogIn:insert( iconLogo )
	iconLogo.height = 129
	iconLogo.width = 128
	
	posY = posY + 125
	
	--text user
	local bgUser0 = display.newRect( midW, posY, intW - 96, 64 )
    bgUser0:setFillColor( unpack(cGrayL) )   
	bgUser0.fill = gGreenBlue
    grpLogIn:insert(bgUser0)
	
	local bgUser1 = display.newRect( midW, posY, intW - 100, 60 )
    bgUser1:setFillColor( unpack(cWhite) )
    grpLogIn:insert(bgUser1)
	
	txtEmail = native.newTextField( midW, posY,  intW - 100, 60 )
    txtEmail.inputType = "email"
    txtEmail.hasBackground = false
	txtEmail.placeholder = "USUARIO"
	txtEmail.size = 25
    txtEmail:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtEmail)
	
	posY = posY + 100
	
	--text password
	local bgPass0 = display.newRect( midW, posY, intW - 96, 64 )
    bgPass0:setFillColor( unpack(cGrayL) )   
	bgPass0.fill = gGreenBlue
    grpLogIn:insert(bgPass0)
	
	local bgPass1 = display.newRect( midW, posY, intW - 100, 60 )
    bgPass1:setFillColor( unpack(cWhite) )
    grpLogIn:insert(bgPass1)
	
	txtPass = native.newTextField( midW, posY,  intW - 100, 60 )
    txtPass.inputType = "default"
    txtPass.hasBackground = false
	txtPass.placeholder = "CONTRASEÑA"
	txtPass.isSecure = true
	txtPass.size = 25
    txtPass:addEventListener( "userInput", onTxtFocus )
	grpLogIn:insert(txtEmail)
	
	posY = posY + 100
	
	--btn login
	local btnLogin = display.newRect( midW, posY, intW - 96, 64 )
    btnLogin:setFillColor( unpack(cGrayL) )   
	btnLogin.fill = gGreenBlue
    grpLogIn:insert(btnLogin)
	btnLogin:addEventListener( 'tap', gotoScreen )
	
	local lblLogin = display.newText({
		text = "ENTRAR",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblLogin:setFillColor( unpack(cWhite) )
	grpLogIn:insert(lblLogin)
	
	posY = posY + 100
	
	--btn login facebook
	local btnLoginFace = display.newRect( midW, posY, intW - 96, 64 )
    btnLoginFace:setFillColor( unpack(cGrayL) )   
	btnLoginFace.fill = gGreenBlue
    grpLogIn:insert(btnLoginFace)
	
	local btnLoginFace1 = display.newRect( midW, posY, intW - 100, 60 )
    btnLoginFace1:setFillColor( unpack(cWhite) )
    grpLogIn:insert(btnLoginFace1)
	btnLoginFace1:addEventListener( 'tap', gotoScreen )
	
	local lblLogin = display.newText({
		text = "FACEBOOK",
		y = posY,x = midW,
		font = fBold, fontSize = 25, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	lblLogin.fill = gGreenBlue
	grpLogIn:insert(lblLogin)
	
    
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