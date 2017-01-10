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
local screen, grpSignIn, grpTextFieldS
local scene = composer.newScene()
local tools = Tools:new()

-- Variables
local txtEmail, txtPass, txtRePass
local btnSignIn

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function closeKeyboard()
	native.setKeyboardFocus( nil )
	return true
end

function gotoScreen( event )
	local t = event.target
	t.alpha = .75
	timer.performWithDelay( 100, function() t.alpha = 1  end )
	return true
end

function gotoSignIn( event )
	btnSignIn:removeEventListener( 'tap', gotoSignIn )
	btnSignIn.alpha = .75
	timer.performWithDelay( 100, function() 
		btnSignIn.alpha = 1  
		
		if trimString( txtEmail.text ) ~= '' and trimString( txtPass.text ) ~= '' and trimString( txtRePass.text ) ~= '' then
			if trimString( txtPass.text ) == trimString( txtRePass.text ) then
				getLoadingLogin(600, "registrando usuarios")
				RestManager.RegisterUser( trimString( txtEmail.text ), trimString( txtPass.text ) )
			else
				getMessageSignIn("Contraseñas distintas", 2)
				timeMarker = timer.performWithDelay( 2000, function()
					deleteLoadingLogin()
					deleteMessageSignIn()
					btnSignIn:addEventListener( 'tap', gotoSignIn )
				end, 1 )
			end
		else
			getMessageSignIn("Campos vacios", 2)
			timeMarker = timer.performWithDelay( 2000, function()
				deleteLoadingLogin()
				deleteMessageSignIn()
				btnSignIn:addEventListener( 'tap', gotoSignIn )
			end, 1 )
		end
	end )
	
	return true
end

function onTxtFocus( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        

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
	o:addEventListener( 'tap', closeKeyboard )
	
	--header
	tools:buildHeaderLogin()
    screen:insert(tools)
	
    -- group login
    grpSignIn = display.newGroup()
    screen:insert(grpSignIn)
	
	-- LogIn
    grpTextFieldS = display.newGroup()
    screen:insert(grpTextFieldS)
	
	local posY = 110 + h
	
	local lblLogin = display.newText({
		text = "INICIA SESIÓN",
		y = posY,x = midW,
		font = fBold, fontSize = 30, align = "center"
	})
	lblLogin:setFillColor( unpack(cBlack) )
	grpSignIn:insert(lblLogin)
	
	posY = posY + 110
	
	local iconLogo = display.newImage("img/bgk/icono_logo2.png")
	iconLogo:translate( midW , posY)
	grpSignIn:insert( iconLogo )
	iconLogo.height = 129
	iconLogo.width = 128
	
	posY = posY + 125
	
	--text user
	local bgUser0 = display.newRect( midW, posY, intW - 96, 64 )
    bgUser0:setFillColor( unpack(cGrayL) )   
	bgUser0.fill = gGreenBlue
    grpTextFieldS:insert(bgUser0)
	
	local bgUser1 = display.newRect( midW, posY, intW - 100, 60 )
    bgUser1:setFillColor( unpack(cWhite) )
    grpTextFieldS:insert(bgUser1)
	
	txtEmail = native.newTextField( midW, posY,  intW - 100, 60 )
    txtEmail.inputType = "email"
    txtEmail.hasBackground = false
	txtEmail.placeholder = "USUARIO"
	txtEmail:setTextColor( unpack(cDarkBlue) )
	txtEmail.size = 25
    txtEmail:addEventListener( "userInput", onTxtFocus )
	grpTextFieldS:insert(txtEmail)
	
	posY = posY + 100
	
	--text password
	local bgPass0 = display.newRect( midW, posY, intW - 96, 64 )
    bgPass0:setFillColor( unpack(cGrayL) )   
	bgPass0.fill = gGreenBlue
    grpTextFieldS:insert(bgPass0)
	
	local bgPass1 = display.newRect( midW, posY, intW - 100, 60 )
    bgPass1:setFillColor( unpack(cWhite) )
    grpTextFieldS:insert(bgPass1)
	
	txtPass = native.newTextField( midW, posY,  intW - 100, 60 )
    txtPass.inputType = "default"
    txtPass.hasBackground = false
	txtPass.placeholder = "CONTRASEÑA"
	txtPass:setTextColor( unpack(cDarkBlue) )
	txtPass.isSecure = true
	txtPass.size = 25
    txtPass:addEventListener( "userInput", onTxtFocus )
	grpTextFieldS:insert(txtPass)
	
	posY = posY + 100
	
	--text re password
	local bgRePass0 = display.newRect( midW, posY, intW - 96, 64 )
    bgRePass0:setFillColor( unpack(cGrayL) )   
	bgRePass0.fill = gGreenBlue
    grpTextFieldS:insert(bgRePass0)
	
	local bgRePass1 = display.newRect( midW, posY, intW - 100, 60 )
    bgRePass1:setFillColor( unpack(cWhite) )
    grpTextFieldS:insert(bgRePass1)
	
	txtRePass = native.newTextField( midW, posY,  intW - 100, 60 )
    txtRePass.inputType = "default"
    txtRePass.hasBackground = false
	txtRePass.placeholder = "CONFIRMAR CONTRASEÑA"
	txtRePass:setTextColor( unpack(cDarkBlue) )
	txtRePass.isSecure = true
	txtRePass.size = 25
    txtRePass:addEventListener( "userInput", onTxtFocus )
	grpTextFieldS:insert(txtRePass)
	
	posY = posY + 100
	
	--btn login
	btnSignIn = display.newRect( midW, posY, intW - 96, 64 )
    btnSignIn:setFillColor( unpack(cGrayL) )   
	btnSignIn.fill = gGreenBlue
    grpSignIn:insert(btnSignIn)
	btnSignIn:addEventListener( 'tap', gotoSignIn )
	
	local lblLogin = display.newText({
		text = "ENTRAR",
		y = posY,x = midW,
		font = fRegular, fontSize = 25, align = "center"
	})
	lblLogin:setFillColor( unpack(cWhite) )
	grpSignIn:insert(lblLogin)
	
	posY = posY + 100
    
end	
-- Called immediately after scene has moved onscreen:
function scene:show( event )
	
end

-- Hide Scene
function scene:hide( event )
	native.setKeyboardFocus( nil )
	if ( event.phase == "will" ) then
		if grpTextFieldS then
			grpTextFieldS:removeSelf()
			grpTextFieldS = nil
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