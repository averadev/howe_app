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
local screen, grpLogout
local scene = composer.newScene()
local tools

local dbConfig = DBManager.getSettings()
-- Variables
local newH = 0
local grpLoading
local itemsGuard
local first = 0

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

---------------------------------------------------
-- @todo Cierra la sesión actual
---------------------------------------------------
function SignOut( event )

	tools:setLoading( true, grpLoading )
	
	RestManager.deletePlayerIdOfUSer()
	return true
end

---------------------------------------------------
-- @todo Manda a la pantalla de login
---------------------------------------------------
function SignOut2( )
	DBManager.clearUser()
	composer.removeScene("src.LoginFacebook")
	composer.gotoScene( "src.LoginFacebook", { time = 400, effect = "slideLeft" })
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
	tools = Tools:new()
	screen:insert(tools)
	--header
	tools:buildHeader()
	
	--menu left
	tools:buildTooLeft()
	
    -- group login
    grpLogout = display.newGroup()
    screen:insert( grpLogout )
	
	--[[local bgEdit = display.newRect( 360/2, posY, 360 - 20, 35 )
    bgEdit:setFillColor( unpack(cWhite) )   
	bgEdit.fill = gGreenBlue
    grpLogout:insert(bgEdit)
	bgMessage0.anchorY = 0]]
	
	posY = 300
	
	local lblLogout = display.newText( {
		text = "¿Desea cerrar sesión?",
		x = 285, y = posY, width = 300,
		font = fBold, fontSize = 24, align = "center"
	})
	lblLogout:setFillColor( unpack(cDarkBlue) )
	grpLogout:insert(lblLogout)
	
	posY = posY + 65
	
	local bgLogout = display.newRect( 285, posY, 300, 60 )
    bgLogout:setFillColor( unpack(cWhite) )   
	bgLogout.fill = gGreenBlue
    grpLogout:insert(bgLogout)
	
	local btnLogout = display.newRect( 285, posY, 298, 58 )
    btnLogout:setFillColor( unpack(cWhite) )
    grpLogout:insert(btnLogout)
	btnLogout:addEventListener( 'tap', SignOut )
	
	local lblAceppt = display.newText( {
		text = "ACEPTAR",
		x = 285, y = posY, width = 300,
		font = fRegular, fontSize = 20, align = "center"
	})
	lblAceppt:setFillColor( unpack(cDarkBlue) )
	grpLogout:insert(lblAceppt)
	
	--createGuard()
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	
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