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
local widget = require( "widget" )
local composer = require( "composer" )
local DBManager = require( 'src.resources.DBManager' )
local RestManager = require( 'src.resources.RestManager' )
--local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpGuardAssi
local scene = composer.newScene()
local tools
local svGuardAssig

local dbConfig = DBManager.getSettings()
-- Variables
local newH = 0
local grpLoading
local itemsGuard
local first = 0

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

------------------------------------------
-- @todo carga los datos del guardia
-- @param item datos obtenidos de WS
------------------------------------------
function setElementGuard(item)

	if #item > 0 then
		itemsGuard = item[1]
		loadImageGuard()
	else
		paintGuardDefault(2)
	end
	
end

---------------------------------------------------
-- @todo desgarga la imagen del guardia en turno
---------------------------------------------------
function loadImageGuard()
	
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
			
		end
	end
	
	print(dbConfig.url..itemsGuard.path..itemsGuard.foto)
		-- Descargamos de la nube
	display.loadRemoteImage( dbConfig.url..itemsGuard.path..itemsGuard.foto, 
	"GET", loadImageListener, "imgGuardTurn." .. extImg, system.TemporaryDirectory )

end


---------------------------------------------------
-- @todo --llama al telefono de la residencia
---------------------------------------------------
function callPhone( event )
	system.openURL( "tel:" .. event.target.phone )
end

------------------------------------------------------------------
-- @todo Crea los elementos del guardia
-- @param existGuard indica si existe datos del guardia en turno
------------------------------------------------------------------
function createGuard(existGuard)

	svGuardAssig = widget.newScrollView{
		top =  h + 71,
		left = 86,
		width = intW - 85,
		height = intH - ( h + 69),
		--horizontalScrollDisabled = true,
		backgroundColor = { unpack(cWhite) }
	}
	grpGuardAssi:insert(svGuardAssig)

	local posY = 75
	
	local bgGuardPhoto = display.newImage("img/btn/bgCircleGradient.png")
	bgGuardPhoto:translate( 75 , posY )
	bgGuardPhoto.screen = "login"
	svGuardAssig:insert( bgGuardPhoto )	
	
	--muestra la foto del guardia si existe o uno default
	local avatar
	local mask = graphics.newMask( "img/bgk/image-mask-mask3.png" )
	if existGuard == 1 then
		avatar = display.newImage( itemsGuard.foto, system.TemporaryDirectory )
	else
		avatar = display.newImage( itemsGuard.foto )
	end
	avatar:translate( 75 , posY )
	avatar.width = 126
	avatar.height = 126
	avatar:setMask( mask )
	avatar.maskScaleY = .68
	avatar.maskScaleX = .68
	svGuardAssig:insert( avatar )
	
	local lblGuardAssig = display.newText({
		text = "Guardia en turno",
		y = posY - 25 ,x = midW + 35, width = 235,
		font = fRegular, fontSize = 16, align = "left"
	})
	lblGuardAssig:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblGuardAssig)
	local lblNameGuard = display.newText({
		text = itemsGuard.nombre .. " " .. itemsGuard.apellidos,
		y = posY - 15 ,x = midW + 35, width = 235,
		font = fBold, fontSize = 30, align = "left"
	})
	lblNameGuard:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblNameGuard)
	lblNameGuard.anchorY = 0
	
	posY = posY + 90
	
	local iconLocation = display.newImage( "img/btn/lugar.png" )
	iconLocation:translate( svGuardAssig.contentWidth - 50 , posY + 35 )
	iconLocation.phone = itemsGuard.telCaseta
	--iconPhone:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert( iconLocation )
	
	local location = { "Av. 135 Sm.326, MZ. 1", "Residenciales del sur", "Camcun, Quintana Roo" }
	
	for i = 1, #location, 1 do
		local lblLocation = display.newText({
			text = location[i],
			y = posY ,x = midW - 35, width = intW - 100,
			font = fLight, fontSize = 16, align = "left"
		})
		lblLocation:setFillColor( unpack(cDarkBlue) )
		svGuardAssig:insert(lblLocation)
		lblLocation.anchorY = 0
		lblLocation.alpha = .85
		posY = posY + 25
	end
	
	posY = posY + 25
	
	local line1 = display.newLine( 0, posY, intW, posY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	svGuardAssig:insert(line1)
	
	-- caseta
	posY = posY + 25
	
	local lblPhoneBooth0 = display.newText({
		text = "Teléfono de caseta",
		y = posY ,x = midW - 35, width = intW - 100,
		font = fRegular, fontSize = 18, align = "left"
	})
	lblPhoneBooth0:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblPhoneBooth0)
	
	posY = posY + 35
	
	local lblPhoneBooth = display.newText({
		text = itemsGuard.telCaseta,
		y = posY ,x = midW - 35, width = intW - 100,
		font = fBold, fontSize = 30, align = "left"
	})
	lblPhoneBooth:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblPhoneBooth)
	
	local iconPhone = display.newImage( "img/btn/llamar2.png" )
	iconPhone:translate( svGuardAssig.contentWidth - 50 , posY )
	iconPhone.phone = itemsGuard.telCaseta
	--iconPhone:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert( iconPhone )
	iconPhone:addEventListener( 'tap', callPhone )
	
	posY = posY + 35
	
	local line1 = display.newLine( 0, posY, intW, posY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	svGuardAssig:insert(line1)
	
	-- administrativo
	posY = posY + 25
	
	local lblPhoneAdmin0 = display.newText({
		text = "Teléfono Administracion",
		y = posY ,x = midW - 35, width = intW - 100,
		font = fRegular, fontSize = 18, align = "left"
	})
	lblPhoneAdmin0:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblPhoneAdmin0)
	
	posY = posY + 35
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
	svGuardAssig:insert(line1)
	
	-- caseta
	
	posY = posY + 25
	
	local lblPhoneLobby0 = display.newText({
		text = "Teléfono de Lobby",
		y = posY ,x = midW - 35, width = intW - 100,
		font = fRegular, fontSize = 18, align = "left"
	})
	lblPhoneLobby0:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblPhoneLobby0)
	
	posY = posY + 35
	
	local lblPhoneLobby = display.newText({
		text = itemsGuard.telLobby,
		y = posY ,x = midW - 35, width = intW - 100,
		font = fBold, fontSize = 30, align = "left"
	})
	lblPhoneLobby:setFillColor( unpack(cDarkBlue) )
	svGuardAssig:insert(lblPhoneLobby)
	
	local iconPhone = display.newImage( "img/btn/llamar2.png" )
	iconPhone:translate( svGuardAssig.contentWidth - 50 , posY )
	--iconPhone:setFillColor( unpack(cDarkBlue) )
	iconPhone.phone = itemsGuard.telLobby
	svGuardAssig:insert( iconPhone )
	iconPhone:addEventListener( 'tap', callPhone )
	
	posY = posY + 35
	
	local line1 = display.newLine( 0, posY, intW, posY )
	line1:setStrokeColor( unpack(cGreenWater) )
	line1.strokeWidth = 1
	line1.alpha = .6
	svGuardAssig:insert(line1)
	
	
	
	tools:setLoading( false, grpLoading )
	
end

------------------------------------------------------------------
-- @todo carga la informacion de un guardia default
-- en caso de no existir uno activo
------------------------------------------------------------------
function paintGuardDefault()
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