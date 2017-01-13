---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.admin.Panel')
require( 'src.Tools' )
local widget = require( "widget" )
local composer = require( "composer" )
local DBManager = require( 'src.resources.DBManager' )
local RestManager = require( 'src.resources.RestManager' )
--local fxTap = audio.loadSound( "fx/click.wav")

local settings = DBManager.getSettings()
local settingsGuard = DBManager.getGuards()

-- Grupos y Contenedores
local screen, grpGuard, grpGuardS
local scene = composer.newScene()
local tools

-- Variables
local newH = 0
local txtPassGuard
local GuardCondo = {}
local currentGuard = nil

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

--------------------------------------
-- Selecciona a un guardia
--------------------------------------
function SelecGuard( event )
	--btnSignLoginGuard.alpha = 1
	
	if currentGuard == nil then
		currentGuard = 1
	end
	
	GuardCondo[currentGuard].alpha = 1
	
	event.target.alpha = .5
	
	currentGuard = event.target.num
	
	return true
end

function loginGuard( event )
	
	if trimString( txtPassGuard.text ) ~= '' and currentGuard ~= nil then
		local result = DBManager.validateGuard( trimString( txtPassGuard.text ), GuardCondo[currentGuard].id )
		if result == 1 then
			NewAlert( true, "Plantec Security", "Contraseña incorrecta" )
			txtPassGuard.x = intW + 240
			timeMarker = timer.performWithDelay( 2000, function()
				NewAlert( false, "Plantec Security", "Contraseña incorrecta" )
				txtPassGuard.x = 240
			end, 1 )
		else
			--composer.removeScene("src.Home")
			--composer.gotoScene("src.Home")
		end
	else
		local msgError = "Por favor Introduce los siguientes datos faltantes: "
		if currentGuard == nil then
			msgError = msgError .. "\nSelecionar un guardia "
		end
		if trimString( txtPassGuard.text ) == "" then
			msgError = msgError .. "\nContrasela del guardia "
		end
		NewAlert( true, "Datos Faltantes", msgError )
		txtPassGuard.x = intW + 240
		timeMarker = timer.performWithDelay( 2000, function()
			NewAlert( false, "Datos Faltantes", msgError )
			txtPassGuard.x = 240
		end, 1 )
	end
end

function signInGuard()
	
	if trimString( txtPassAdmin.text ) ~= "" then
		RestManager.signOut( trimString( txtPassAdmin.text ) )
		--RestManager.signOut("123")
	else
		NewAlert( true, "Datos Faltantes", "Campo Vacio" )
		txtPassAdmin.x = intW + 240
		timeMarker = timer.performWithDelay( 2000, function()
			NewAlert( false, "Datos Faltantes", msgError )
			txtPassAdmin.x = 240
		end, 1 )
		
	end
	
end

--muestra el formulario para cambiar de condominio
function showChangeCondo( event )
	local t = event.target
	if t.name == "signIn" then
		transition.to( grpGuard, { time= 500, x = -intW, transition = easing.outExpo  } )
		transition.to( grpGuardS, { time= 500, x = 0, transition = easing.outExpo  } )
	elseif t.name == "logIn" then
		transition.to( grpGuardS, { time= 500, x = intW, transition = easing.outExpo  } )
		transition.to( grpGuard, { time= 500, x = 0, transition = easing.outExpo  } )
	end
	return true
end

--------------------------------------
-- Crea los elementos del login
--------------------------------------
function createItemsGuard()
	
	local posY = h + 105
	
	-- Agregamos textos
	local lbl0 = display.newText( {
		text = "SELECCIONA USUARIO",
		x = midW, y = posY,
		font = fBold, fontSize = 26, align = "center"
	})
	lbl0:setFillColor( unpack( cWhite ) )
	grpGuard:insert( lbl0 )
	
	posY = posY + 45
	
	local srvGuard = widget.newScrollView{
		top =  posY,
		left = 0,
		width = intW,
		height = 140,
		verticalScrollDisabled = true,
		backgroundColor = { unpack(cDarkBlue) }
	}
	grpGuard:insert(srvGuard)
	
	local lastX = 70
	
	for i = 1, #settingsGuard, 1 do
		GuardCondo[i] = display.newContainer( 130, 130 )
		GuardCondo[i].x = lastX
		GuardCondo[i].y = 70
		GuardCondo[i].id = settingsGuard[i].id
		GuardCondo[i].num = i
		srvGuard:insert(GuardCondo[i])
		GuardCondo[i]:addEventListener( 'tap', SelecGuard )
		
		local bgGuardPhoto = display.newImage("img/btn/bgCircleGradient.png")
		bgGuardPhoto:translate( 0 , 0 )
		GuardCondo[i]:insert( bgGuardPhoto )
		
		local bgGuardPhoto1 = display.newImage("img/btn/circleWhite.png")
		bgGuardPhoto1:translate( 0 , 0 )
		GuardCondo[i]:insert( bgGuardPhoto1 )
		
		local mask = graphics.newMask( "img/bgk/image-mask-mask3.png" )
		local avatar = display.newImage( settingsGuard[i].foto, system.TemporaryDirectory )
		avatar:translate( 0 , 0 )
		avatar.width = 126
		avatar.height = 126
		avatar:setMask( mask )
		avatar.maskScaleY = .68
		avatar.maskScaleX = .68
		GuardCondo[i]:insert( avatar )
		
		lastX = lastX + 140
	end
	
	-- pass
	posY = posY + 200
	
	local bgPass0 = display.newRect( midW, posY, intW - 50, 60 )
	bgPass0:setFillColor( unpack( cWhite ) )
	bgPass0.fill = gGreenBlue
    grpGuard:insert(bgPass0)
	bgPass0.anchorY = 0
	
	local bgPass1 = display.newRect( midW, posY + 2, intW - 54, 56 )
	bgPass1:setFillColor( unpack( cWhite ) )
    grpGuard:insert(bgPass1)
	bgPass1.anchorY = 0
	
	txtPassGuard = native.newTextField( midW, posY + 3, intW - 58, 54 )
    txtPassGuard.hasBackground = false
	txtPassGuard.placeholder = "ESCRIBA LA CONTRASEÑA DE USUARIO"
	txtPassGuard:setTextColor( unpack(cDarkBlue) )
	txtPassGuard.size = 25
	txtPassGuard.anchorY = 0
    --txtPassGuard:addEventListener( "userInput", onTxtFocus )
	grpGuard:insert( txtPassGuard )
	
	-- btn
	
	posY = posY + 95
	
	local btnLogIn = display.newRect( midW, posY, intW - 50, 60 )
	btnLogIn:setFillColor( unpack( cWhite ) )
	btnLogIn.fill = gGreenBlue
	btnLogIn.anchorY = 0
    grpGuard:insert(btnLogIn)
	btnLogIn:addEventListener( 'tap', loginGuard )
	
	local lbl0 = display.newText( {
		text = "INICIAR SESIÓN",
		x = midW, y = posY + 30,
		font = fRegular, fontSize = 22, align = "center"
	})
	lbl0:setFillColor( unpack( cWhite ) )
	grpGuard:insert( lbl0 )
	
	posY = posY + 95
	
	local btnSignIn = display.newRect( 125, posY, 200, 50 )
	btnSignIn:setFillColor( unpack( cDarkBlue ) )
    grpGuard:insert(btnSignIn)
	btnSignIn.name = "signIn"
	btnSignIn.alpha = .02
	btnSignIn.anchorY = 0
	btnSignIn:addEventListener( 'tap', showChangeCondo )
	
	local iconSignIn = display.newImage( "img/btn/back-48.png" )
	iconSignIn:translate( 46, posY + 25 )
	iconSignIn:setFillColor( unpack( cGreenWater ) )
	grpGuard:insert( iconSignIn )
	
	local lbl0 = display.newText( {
		text = "SALIR",
		x = 105, y = posY + 25,
		font = fRegular, fontSize = 20, align = "center"
	})
	lbl0:setFillColor( unpack( cWhite ) )
	grpGuard:insert( lbl0 )
	
	
end

function createSignInGuard()
	
	local posY = h + 200
	
	-- Agregamos textos
	local lbl0 = display.newText( {
		text = "PARA CAMBIAR EL CONDOMINIO ASIGNADO ES NECESARIO INTRODUCIR LA CONTRASEÑA DEL ADMINISTRADOR",
		x = midW, y = posY, width = intW - 60,
		font = fBold, fontSize = 22, align = "center"
	})
	lbl0:setFillColor( unpack( cWhite ) )
	grpGuardS:insert( lbl0 )
	
	posY = posY + 100
	
	local bgPass0 = display.newRect( midW, posY, intW - 50, 60 )
	bgPass0:setFillColor( unpack( cWhite ) )
	bgPass0.fill = gGreenBlue
    grpGuardS:insert(bgPass0)
	bgPass0.anchorY = 0
	
	local bgPass1 = display.newRect( midW, posY + 2, intW - 54, 56 )
	bgPass1:setFillColor( unpack( cWhite ) )
    grpGuardS:insert(bgPass1)
	bgPass1.anchorY = 0
	
	txtPassAdmin = native.newTextField( midW, posY + 3, intW - 58, 54 )
    txtPassAdmin.hasBackground = false
	txtPassAdmin.placeholder = "CONTRASEÑA"
	txtPassAdmin:setTextColor( unpack(cDarkBlue) )
	txtPassAdmin.size = 25
	txtPassAdmin.anchorY = 0
    --txtPassGuard:addEventListener( "userInput", onTxtFocus )
	grpGuardS:insert( txtPassAdmin )
	
	posY = posY + 100
	
	local btnSignIn = display.newRect( midW, posY, intW - 50, 60 )
	btnSignIn:setFillColor( unpack( cWhite ) )
	btnSignIn.fill = gGreenBlue
	btnSignIn.anchorY = 0
    grpGuardS:insert(btnSignIn)
	btnSignIn:addEventListener( 'tap', signInGuard )
	
	local lbl0 = display.newText( {
		text = "ACEPTAR",
		x = midW, y = posY + 30,
		font = fRegular, fontSize = 22, align = "center"
	})
	lbl0:setFillColor( unpack( cWhite ) )
	grpGuardS:insert( lbl0 )
	
	posY = posY + 95
	
	local btnReturnLogin = display.newRect( 125, posY, 200, 50 )
	btnReturnLogin:setFillColor( unpack( cDarkBlue ) )
    grpGuardS:insert(btnReturnLogin)
	btnReturnLogin.name = "logIn"
	btnReturnLogin.alpha = .02
	btnReturnLogin.anchorY = 0
	btnReturnLogin:addEventListener( 'tap', showChangeCondo)
	
	local iconSignIn = display.newImage( "img/btn/back-48.png" )
	iconSignIn:translate( 46, posY + 25 )
	iconSignIn:setFillColor( unpack( cGreenWater ) )
	grpGuardS:insert( iconSignIn )
	
	local lbl0 = display.newText( {
		text = "REGRESAR",
		x = 135, y = posY + 25,
		font = fRegular, fontSize = 20, align = "center"
	})
	lbl0:setFillColor( unpack( cWhite ) )
	grpGuardS:insert( lbl0 )
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    --screen.y = h
    
    local o = display.newRect( midW, midH + h, intW+8, intH )
    o:setFillColor( unpack(cDarkBlue) )   
    screen:insert(o)
	tools = Tools:new()
	--screen:insert(tools)
	
	local panel = Panel:new()
    panel:build()
	
	--header
	--tools:buildHeader()
	
	--menu left
	--tools:buildTooLeftHome()
   
    -- group login
    grpGuard = display.newGroup()
    screen:insert( grpGuard )
	--grpGuard.x = - intW
	
	grpGuardS = display.newGroup()
    screen:insert( grpGuardS )
	grpGuardS.x = intW
	
	DBManager.updateGuardActive()
	
	local posY = 175 + h
	createItemsGuard()
	createSignInGuard()
	
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