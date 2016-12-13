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
local screen, grpGuardAssi
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

function setElementGuard(item)

	if #item > 0 then
		itemsGuard = item[1]
		loadImageGuard()
	else
		paintGuardDefault(2)
	end
	
end

function loadImageGuard()
	local json = require( "json" )
	--itemsGuard.foto = "hola.jpg"
	--[[local nameImg
	for k, v in string.gmatch( itemsGuard.foto, "(%w+).(%w+)" ) do
		nameImg = k
		extImg = v
		print(extImg)
	end]]
	
	--print(itemsGuard.foto)
	
	local extImg = itemsGuard.extension

	-- Listener de la carga de la imagen del servidor
	local function loadImageListener( event )
		if ( event.isError ) then
			native.showAlert( "Plantec Resident", "Network error :(", { "OK"})
		else
			if event.target then
				event.target.alpha = 0
				event.target:removeSelf()
			end
			if event.status == 200 then
				itemsGuard.foto = "imgGuardTurn." .. extImg
				if first == 0 then
					createGuard(1)
					first = 1
				end
			end
		
			--event.target.alpha = 0
			--itemsGuard.foto = "imgGuardTurn." .. extImg
			--if first == 0 then
				--buildItemGuardTurn(1)
				--first = 1
			--end
			
		end
	end
	
	print(dbConfig.url..itemsGuard.path..itemsGuard.foto)
		-- Descargamos de la nube
	display.loadRemoteImage( dbConfig.url..itemsGuard.path..itemsGuard.foto, 
	"GET", loadImageListener, "imgGuardTurn." .. extImg, system.TemporaryDirectory )

end

function createGuard(typePhoto)

	local posY = 150 + h
	
	local bgGuardPhoto = display.newImage("img/btn/bgCircleGradient.png")
	bgGuardPhoto:translate( 160 , posY )
	bgGuardPhoto.screen = "login"
	grpGuardAssi:insert( bgGuardPhoto )	
	
	--RestManager.getLastGuard()
	local avatar
	local mask = graphics.newMask( "img/bgk/image-mask-mask3.png" )
	if typePhoto == 1 then
		avatar = display.newImage( itemsGuard.foto, system.TemporaryDirectory )
	else
		avatar = display.newImage( itemsGuard.foto )
	end
	--local imgPhotoGuard = display.newImage( "img/bgk/fotoGuard.jpeg" )
	--avatar.anchorY = 0
	avatar:translate( 160 , posY )
	avatar.width = 126
	avatar.height = 126
	avatar:setMask( mask )
	avatar.maskScaleY = .68
	avatar.maskScaleX = .68
	grpGuardAssi:insert( avatar )
	
	local lblGuardAssig = display.newText({
		text = "Guardia en turno",
		y = posY - 25 ,x = midW + 100,
		font = fRegular, fontSize = 20, align = "center"
	})
	lblGuardAssig:setFillColor( unpack(cDarkBlue) )
	grpGuardAssi:insert(lblGuardAssig)
	
	local lblNameGuard = display.newText({
		text = itemsGuard.nombre .. " " .. itemsGuard.apellidos,
		y = posY + 25 ,x = midW + 100, width = 265,
		font = fBold, fontSize = 28, align = "center"
	})
	lblNameGuard:setFillColor( unpack(cDarkBlue) )
	grpGuardAssi:insert(lblNameGuard)
	
	posY = posY + 125
	
	local lblGuardAge = display.newText({
		text = "Edad: " .. itemsGuard.edad .. " años",
		y = posY ,x = midW + 50, width = intW - 100,
		font = fLight, fontSize = 20, align = "left"
	})
	lblGuardAge:setFillColor( unpack(cDarkBlue) )
	grpGuardAssi:insert(lblGuardAge)
	
	posY = posY  + 40
	
	local lblWorkingTime = display.newText({
		text = "Empleado desde: " .. itemsGuard.workingTime,
		y = posY ,x = midW + 50, width = intW - 100,
		font = fLight, fontSize = 20, align = "left"
	})
	lblWorkingTime:setFillColor( unpack(cDarkBlue) )
	grpGuardAssi:insert(lblWorkingTime)
	
	posY = posY  + 40
	
	local lblBusiness = display.newText({
		text = "Empresa: Guardias Force",
		y = posY ,x = midW + 50, width = intW - 100,
		font = fLight, fontSize = 20, align = "left"
	})
	lblBusiness:setFillColor( unpack(cDarkBlue) )
	grpGuardAssi:insert(lblBusiness)
	
	tools:setLoading( false, grpLoading )
	
end

-- muestra un guardia por defecto
function paintGuardDefault()
	print("hola")
	itemsGuard = {}
	itemsGuard.nombre = "SIN GUARDIAS REGISTRADOS"
	itemsGuard.apellidos = ""
	itemsGuard.foto =  "img/bgk/visitas.png"
	itemsGuard.edad =  "Desconocida"
	itemsGuard.workingTime =  "Desconocido"
	
	createGuard(2)
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
    grpGuardAssi = display.newGroup()
    screen:insert( grpGuardAssi )
	
	--createGuard()
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	tools:setLoading( true, grpLoading )
	
	RestManager.getLastGuard()
	
	
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