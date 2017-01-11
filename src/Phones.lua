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
local screen, grpPhones
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

function getPhones( items )
	if #items > 0 then
		CreatePhonesItem( items[1] )
	end
end

function callPhone( event )
	system.openURL( "tel:" .. event.target.phone )
	return true
end

function CreatePhonesItem( item )
	
	local screenW = intW - 85

	posY = 115 + h
	
	local bgTitle = display.newRect( screenW/2 + 85, posY - 45, screenW, 45 )
	bgTitle:setFillColor( unpack( cWhite ) )   
    grpPhones:insert(bgTitle)
	bgTitle.anchorY = 0
	
	-- titulo
	local lblTitle = display.newText( {
        text = "Teléfonos de Emergencia",
        x = screenW/2 + 85, y = posY - 23,
        width = screenW - 30,
        font = fBold, fontSize = 18, align = "center"
    })
    lblTitle:setFillColor( unpack(cDarkBlue) )
    grpPhones:insert( lblTitle )
	
	local line1 = display.newLine( 85, posY, intW, posY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	grpPhones:insert(line1)
	
	-- administrativo
	
	local titlePhone = { "Teléfono Administracion:", "Teléfono de caseta:", "Teléfono de Lobby:" }
	local numberPhone = { item.telAdministracion, item.telCaseta, item.telLobby }
	
	for i = 1, #titlePhone, 1 do
	
		local bg0 = display.newRect( screenW/2 + 85, posY, screenW, 100 )
		bg0:setFillColor( unpack( cWhite ) )
		bg0.fill = gGreenBlue
		grpPhones:insert(bg0)
		bg0.anchorY = 0
		
		local bg0 = display.newRect( screenW/2 + 85, posY, screenW, 99 )
		bg0:setFillColor( unpack( cWhite ) )
		grpPhones:insert(bg0)
		bg0.anchorY = 0
		
		local lblPhoneTitle = display.newText({
			text = titlePhone[i],
			y = posY + 25,x = screenW/2 + 100, width = intW - 100,
			font = fRegular, fontSize = 18, align = "left"
		})
		lblPhoneTitle:setFillColor( unpack(cDarkBlue) )
		grpPhones:insert(lblPhoneTitle)
		
		local lblPhone = display.newText({
			text = numberPhone[i],
			y = posY + 60,x = screenW/2 + 100, width = intW - 100,
			font = fBold, fontSize = 26, align = "left"
		})
		lblPhone:setFillColor( unpack(cDarkBlue) )
		grpPhones:insert(lblPhone)
		
		local iconPhone = display.newImage( "img/btn/llamar2.png" )
		iconPhone:translate( intW - 50 , posY + 57 )
		--iconPhone:setFillColor( unpack(cDarkBlue) )
		iconPhone.phone = numberPhone[i]
		grpPhones:insert( iconPhone )
		iconPhone:addEventListener( 'tap', callPhone )
		
		posY = posY + 100
		
		
		
	end
	
	--[[local lblPhoneAdmin0 = display.newText({
		text = "Teléfono Administracion",
		y = posY ,x = midW - 35, width = intW - 100,
		font = fRegular, fontSize = 18, align = "left"
	})
	lblPhoneAdmin0:setFillColor( unpack(cDarkBlue) )
	grpPhones:insert(lblPhoneAdmin0)]]
	
	--[[posY = posY + 35
	local lblPhoneAdmin = display.newText({
		text = itemsGuard.telAdministracion,
		y = posY ,x = midW - 35, width = intW - 100,
		font = fBold, fontSize = 30, align = "left"
	})
	lblPhoneAdmin:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblPhoneAdmin)
	
	local iconPhone = display.newImage( "img/btn/llamar2.png" )
	iconPhone:translate( svGuardAssig.contentWidth - 50 , posY )
	--iconPhone:setFillColor( unpack(cDarkBlue) )
	iconPhone.phone = itemsGuard.telAdministracion
	svGuardAssig:insert( iconPhone )
	iconPhone:addEventListener( 'tap', callPhone )
	
	posY = posY + 35
	local lblAttentionSchedule = display.newText({
		text = "Horarios de Atención:",
		y = posY ,x = midW - 35, width = intW - 100,
		font = fLight, fontSize = 16, align = "left"
	})
	lblAttentionSchedule:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblAttentionSchedule)
	lblAttentionSchedule.alpha = .85
	
	posY = posY + 10
	local lblAttentionSchedule0 = display.newText({
		text = "Lunes a viernes de 09:00 a 17:00 \nSabados de 9:00 a 14:00 \n Domingos N/A",
		y = posY ,x = midW - 35, width = intW - 100,
		font = fLight, fontSize = 16, align = "left"
	})
	lblAttentionSchedule0:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblAttentionSchedule0)
	lblAttentionSchedule0.anchorY = 0
	lblAttentionSchedule0.alpha = .85
	
	posY = posY + 80
	
	local line1 = display.newLine( 0, posY, intW, posY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	svGuardAssig:insert(line1)]]
	
	
	
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    --screen.y = h
    
    local o = display.newRect( midW, midH + h, intW+8, intH )
    o:setFillColor( unpack(cGrayL) )   
    screen:insert(o)
	tools = Tools:new()
	screen:insert(tools)
	--header
	tools:buildHeader()
	
	--menu left
	tools:buildTooLeft()
	
    -- group login
    grpPhones = display.newGroup()
    screen:insert( grpPhones )
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	RestManager.getEmergencyCalls()
	
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