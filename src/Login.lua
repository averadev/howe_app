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
require('src.BuildItem')
require('src.resources.Globals')
local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
--local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpLogIn, grpTextFieldL
local scene = composer.newScene()
local tools = Tools:new()

-- Variables
local newH = 0
local h = display.topStatusBarContentHeight
local txtEmail, txtPass
local btnLogin

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function alertLogin()
	
	
	
end

function goToHome()
	btnLogin:addEventListener( 'tap', gotoLogin)
	btnLogin.alpha = 1
	composer.removeScene("src.Welcome")
	composer.gotoScene("src.Welcome")
end

function errorLogin()
	btnLogin:addEventListener( 'tap', gotoLogin)
	btnLogin.alpha = 1
end

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

function gotoLogin( event )
	btnLogin:removeEventListener( 'tap', gotoLogin )
	btnLogin.alpha = .75
	timer.performWithDelay( 100, function() 
		btnLogin.alpha = 1  
		
		if trimString( txtEmail.text ) ~= '' and trimString( txtPass.text ) ~= '' then
			getLoadingLogin(600, "comprobando usuarios")
			RestManager.validateUser( trimString( txtEmail.text ), trimString( txtPass.text ) )
			
		else
			getMessageSignIn("Campos vacios", 2)
			timeMarker = timer.performWithDelay( 2000, function()
				deleteLoadingLogin()
				deleteMessageSignIn()
				btnLogin:addEventListener( 'tap', gotoLogin )
			end, 1 )
		end
	end )
	
	return true
end


function onTxtFocus( event )
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
    elseif ( event.phase == "submitted" ) then
		if event.target.name == "email" then
			native.setKeyboardFocus(txtPass)
		elseif event.target.name == "password" then
			native.setKeyboardFocus( nil )
			gotoLogin()
		end
	elseif ( event.phase == "ended" ) then
    elseif ( event.phase == "editing" ) then
        
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
    grpTextFieldL:insert(bgUser0)
	
	local bgUser1 = display.newRect( midW, posY, intW - 100, 60 )
    bgUser1:setFillColor( unpack(cWhite) )
    grpTextFieldL:insert(bgUser1)
	
	txtEmail = native.newTextField( midW, posY,  intW - 100, 60 )
    txtEmail.inputType = "email"
	txtEmail.name = "email"
    txtEmail.hasBackground = false
	txtEmail.placeholder = "USUARIO"
	txtEmail.size = 25
    txtEmail:addEventListener( "userInput", onTxtFocus )
	grpTextFieldL:insert(txtEmail)
	
	posY = posY + 100
	
	--text password
	local bgPass0 = display.newRect( midW, posY, intW - 96, 64 )
    bgPass0:setFillColor( unpack(cGrayL) )   
	bgPass0.fill = gGreenBlue
    grpTextFieldL:insert(bgPass0)
	
	local bgPass1 = display.newRect( midW, posY, intW - 100, 60 )
    bgPass1:setFillColor( unpack(cWhite) )
    grpTextFieldL:insert(bgPass1)
	
	txtPass = native.newTextField( midW, posY,  intW - 100, 60 )
    txtPass.inputType = "default"
    txtPass.hasBackground = false
	txtPass.name = "password"
	txtPass.placeholder = "CONTRASEÑA"
	txtPass.isSecure = true
	txtPass.size = 25
    txtPass:addEventListener( "userInput", onTxtFocus )
	grpTextFieldL:insert(txtPass)
	
	posY = posY + 100
	
	--btn login
	btnLogin = display.newRect( midW, posY, intW - 96, 64 )
    btnLogin:setFillColor( unpack(cGrayL) )   
	btnLogin.fill = gGreenBlue
    grpLogIn:insert(btnLogin)
	btnLogin:addEventListener( 'tap', gotoLogin )
	
	local lblLogin = display.newText({
		text = "ENTRAR",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblLogin:setFillColor( unpack(cWhite) )
	grpLogIn:insert(lblLogin)
	
	posY = posY + 100
	
	
	--btn login facebook
	local btnRegister = display.newRect( midW, posY, intW - 96, 64 )
    btnRegister:setFillColor( unpack(cGrayL) )   
	btnRegister.fill = gGreenBlue
	btnRegister.screen = "SignIn"
    grpLogIn:insert(btnRegister)
	btnRegister:addEventListener( 'tap', gotoScreen )
	
	local btnRegister0 = display.newRect( midW, posY, intW - 100, 60 )
    btnRegister0:setFillColor( unpack(cWhite) )
    grpLogIn:insert(btnRegister0)
	
	local lblRegister = display.newText({
		text = "REGISTRARSE",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblRegister:setFillColor( unpack(cBlack) )
	grpLogIn:insert(lblRegister)
	
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	
end

-- Hide Scene
function scene:hide( event )
	if ( event.phase == "will" ) then
		if grpTextFieldL then
			grpTextFieldL:removeSelf()
			grpTextFieldL = nil
		end
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