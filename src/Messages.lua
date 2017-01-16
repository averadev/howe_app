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
require( 'src.BuildRow' )
require( 'src.BuildItem' )
require( 'src.resources.Globals' )
local widget = require( "widget" )
local composer = require( "composer" )
local DBManager = require( 'src.resources.DBManager' )
local RestManager = require( 'src.resources.RestManager' )
--local fxTap = audio.loadSound( "fx/click.wav")

-- Grupos y Contenedores
local screen, grpMessages
local scene = composer.newScene()
local tools
local NotiMessageScreen = display.newGroup()
local groupASvContent = display.newGroup()
local grpDelete = display.newGroup()
local grpEdit = display.newGroup()
local grpBtnDelete = display.newGroup()


local dbConfig = DBManager.getSettings()

--variables
local svMessage
local itemsAdmin
local posY = 0
local idDeleteA = {}
local noLeidoA = {}
local container = {}
local btnCheckOutM = {}
local btnCheckInM = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

---------------------------------------------------
-- @todo Carga los datos de los mensajes
---------------------------------------------------
function setItemsNotiAdmin( items )
	if #items > 0 then
		itemsAdmin = items
		buildMensageItems()
	else
		getNoContent(svMessage,'En este momento no cuentas con mensajes')
	end
end

-------------------------------------------------------------------
-- @todo Muestra un mensaje de error o mensajes no encontrados
-- @params message texto a mostrar
-------------------------------------------------------------------
function noMessages(message)
	getNoContent( svMessage, message )
end

---------------------------------------------------
-- @todo Elimina las visitas selecionadas
---------------------------------------------------
function deleteMessage( event )
	local adminDelete = {}
	for i= 1, #idDeleteA, 1 do
		if idDeleteA[i] ~= 0 then
			adminDelete[#adminDelete + 1] = idDeleteA[i]
		end
	end
	
	tools:setLoading( true, grpLoading )
	RestManager.deleteMsgAdmin(adminDelete)
	return true
end

-------------------------------------------------------------------
-- @todo Limpia los elementos para volver a mostrar los mensajes
-------------------------------------------------------------------
function refreshMessageAdmin()
	
	groupASvContent:removeSelf();
	grpDelete:removeSelf();
	grpEdit:removeSelf();
	grpBtnDelete:removeSelf();
	
	groupASvContent = display.newGroup()
	grpDelete = display.newGroup()
	grpEdit = display.newGroup()
	grpBtnDelete = display.newGroup()
	RestManager.getMessageToAdmin()
	
	tools:setLoading( false, grpLoading )
	
end

---------------------------------------------------
-- @todo Marca el mensaje como leido
---------------------------------------------------
function markReadAdmin( event )
	
	event.target:removeEventListener('tap', markReadAdmin)
	
	if noLeidoA[event.target.posci] then
		noLeidoA[event.target.posci]:removeSelf()
		noLeidoA[event.target.posci] = nil
	end
	
	RestManager.markMessageRead( event.target.id, 1 )
	RestManager.getMessageUnRead()
	
end

---------------------------------------------------
-- @todo Muestra los checkbox
---------------------------------------------------
function showCheckBox( event )
	grpDelete.alpha = 1
	grpBtnDelete.alpha = 1
	grpEdit.alpha = 0
	return true
end

---------------------------------------------------
-- @todo Esconde los checkbox
---------------------------------------------------
function hideCheckBox( event )
	grpDelete.alpha = 0
	grpBtnDelete.alpha = 0
	grpEdit.alpha = 1
	return true
end

---------------------------------------------------
-- @todo Activa o desactiva los checkbox
---------------------------------------------------
function changeCheckBoxM( event )

	local t = event.target
	
	local active
		if t.check == 0 then
		btnCheckOutM[t.posc].alpha = 0
		btnCheckInM[t.posc].alpha = 1
		t.check = 1
		--contDeleteAdmin = contDeleteAdmin + 1
		idDeleteA[t.posc] = t.id
		active = true
	else
		btnCheckInM[t.posc].alpha = 0
		btnCheckOutM[t.posc].alpha = 1
		t.check = 0
		--contDeleteAdmin = contDeleteAdmin - 1
		active = false
		idDeleteA[t.posc] = 0
	end
	
	return true
	
end

---------------------------------------------------
-- @todo Muestra el mensaje seleccionado
-- Manda a la pantalla de message
---------------------------------------------------
function showMessage(event)
        local composer = require( "composer" )
		
        local current = composer.getSceneName( "current" )
		if current ~= "src.Message" then
            composer.removeScene( "src.Message" )
			composer.gotoScene( "src.Message", {
                time = 400,
                effect = "crossFade",
                params = { id = event.target.item.id }
            })
		end
end

---------------------------------------------------------------------------------------
-- @todo Crea los mensajes por interacion
-- @params i interacion, posicion
-- @params srvW anchura del scrollView
-- @params posY posicion en Y donde se acomodara los elementos por interacion
---------------------------------------------------------------------------------------
function createMessages( i, srvW, posY )
	
	container[i] = display.newContainer( srvW, 110 )
	container[i].x = srvW/2
	container[i].y = posY
	container[i].item = itemsAdmin[i]
	container[i].id = itemsAdmin[i].idXref
	container[i].posci = i
	container[i].posY = posY
	groupASvContent:insert( container[i] )
	container[i]:addEventListener( "tap", showMessage )
	container[i].anchorY = 0
	
	local maxShape = display.newRect( 0, 0, 460, 100 )
	maxShape:setFillColor( unpack(cGrayL) )
	maxShape.fill = gGreenBlue
	container[i]:insert( maxShape )

	local maxShape = display.newRect( 0, 0, 456, 98 )
	maxShape:setFillColor( unpack(cWhite) )
	container[i]:insert( maxShape )
	
	local txtFecha = display.newText( {
		text = itemsAdmin[i].dia .. ", " .. itemsAdmin[i].fechaFormat,
		x = -15, y = -30,
		width = srvW,
		font = fLight, fontSize = 16, align = "right",
	})
	txtFecha:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(txtFecha)
	
	-- Agregamos textos
	local txtPartner = display.newText( {
			--text = item.partner,
		text = "DE: " .. itemsAdmin[i].nombreAdmin .. " " .. itemsAdmin[i].apellidosAdmin,
		x = 15, y = -10,
		width = srvW,
		font = fRegular, fontSize = 18, align = "left"
	})
	txtPartner:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(txtPartner)
	
	local txtInfo = display.newText( {
		text = "Asunto: " .. itemsAdmin[i].asunto:sub(1,30).."...",
		x = 15, y = 20, width = srvW,
		font = fRegular, fontSize = 18, align = "left"
	})
	txtInfo:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(txtInfo)
	
	-- checkbox
	local bgCheckA = display.newRect( -150, -25, 50, 50 )
	bgCheckA:translate( srvW + 120, posY + 100 )
	bgCheckA:setFillColor( unpack( cWhite ) )
	bgCheckA.check = 0
	bgCheckA.name = "checkbox"
	bgCheckA.id = itemsAdmin[i].idXref
	bgCheckA.posc = itemsAdmin[i].posc
	bgCheckA.alpha = .02
	grpDelete:insert( bgCheckA )
	bgCheckA:addEventListener( 'tap', changeCheckBoxM )
		
	btnCheckOutM[i] = display.newImage( "img/btn/icono_paraseleccionar.png" )
	btnCheckOutM[i].name = "CheckOut"
	btnCheckOutM[i].height = 30
	btnCheckOutM[i].width = 30
	btnCheckOutM[i]:translate( srvW - 30 , posY + 75 )
	grpDelete:insert( btnCheckOutM[i] )
		
	btnCheckInM[i] = display.newImage( "img/btn/icono_seleccionado.png" )
	btnCheckInM[i].name = "CheckIn"
	btnCheckInM[i].height = 30
	btnCheckInM[i].width = 30
	btnCheckInM[i]:translate( srvW - 30 , posY + 75 )
	btnCheckInM[i].alpha = 0
	grpDelete:insert( btnCheckInM[i] )
	
	-- borbuja no leidos
	noLeidoA[i] = display.newCircle( 315, posY + 75, 12 )
	noLeidoA[i]:setFillColor( 0.5 )
	noLeidoA[i].fill = gGreenBlue
	groupASvContent:insert(noLeidoA[i])
			
	if itemsAdmin[i].leido == "0" then
		container[i]:addEventListener( 'tap', markReadAdmin )
	else
		noLeidoA[i].alpha = 0
	end
	
end

---------------------------------------------------
-- @todo Contruye la carcasa de los mensajes
---------------------------------------------------
function buildMensageItems( event)

	posY = 40
	local srvW = svMessage.contentWidth
	local srvH = svMessage.contentHeight

	svMessage:insert(groupASvContent)
	svMessage:insert(grpDelete)
	grpMessages:insert(grpEdit)
	grpMessages:insert(grpBtnDelete)
	
	grpDelete.alpha = 0
	grpBtnDelete.alpha = 0
	
	posY = h + 95
	
	local bgEdit = display.newRect( midW + 40, posY, srvW - 200, 35 )
    bgEdit:setFillColor( unpack(cWhite) )   
	bgEdit.fill = gGreenBlue
    grpEdit:insert(bgEdit)
	
	btnEdit = display.newRect( midW + 40, posY, srvW - 202, 33 )
    btnEdit:setFillColor( unpack(cWhite) ) 
    grpEdit:insert(btnEdit)
	btnEdit:addEventListener( 'tap', showCheckBox )
	
	local lblEdit = display.newText( {
		text = "EDITAR",
		x = midW + 40, y = posY,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblEdit:setFillColor( unpack(cDarkBlue) )
	grpEdit:insert(lblEdit)
	
	-- btns delete messages
	local btnCancelEdit = display.newRect( srvW / 2 - 10, posY, srvW / 2 - 40, 35 )
    btnCancelEdit:setFillColor( unpack( cWhite ) )
    grpBtnDelete:insert(btnCancelEdit)
	btnCancelEdit:addEventListener( 'tap', hideCheckBox )
	
	local lblCancelEdit  = display.newText( {
		text = "CANCELAR",
		x = srvW / 2 - 10, y = posY,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblCancelEdit:setFillColor( unpack( cDarkBlue ) )
	grpBtnDelete:insert(lblCancelEdit)
	
	local bgAcceptEdit = display.newRect( srvW  - 20, posY, srvW / 2 - 40, 35 )
    bgAcceptEdit:setFillColor( unpack(cWhite) )   
	bgAcceptEdit.fill = gGreenBlue
    grpBtnDelete:insert(bgAcceptEdit)
	
	local btnAcceptEdit = display.newRect( srvW  - 20, posY, srvW / 2 - 42, 33 )
    btnAcceptEdit:setFillColor( unpack(cWhite) )
    grpBtnDelete:insert(btnAcceptEdit)
	btnAcceptEdit:addEventListener( 'tap', deleteMessage )
	
	local lblAcceptEdit  = display.newText( {
		text = "ACEPTAR",
		x = srvW  - 20 , y = posY,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblAcceptEdit:setFillColor( unpack( cDarkBlue ) )
	grpBtnDelete:insert(lblAcceptEdit)
	
	posY = -5
	
	for y = 1, #itemsAdmin, 1 do
		idDeleteA[y] = 0
		itemsAdmin[y].posc = y
		
		createMessages( y, srvW, posY )
		   
		posY = posY + 99
		
	end
	
	tools:setLoading( false, grpLoading )
	
	svMessage:setScrollHeight(posY)
	
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
    grpMessages = display.newGroup()
    screen:insert( grpMessages )
	
	svMessage = widget.newScrollView{
		top =  h + 120,
		left = 86,
		width = intW - 85,
		height = intH - ( h + 69),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	}
	grpMessages:insert(svMessage)
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	tools:setLoading( true, grpLoading )
	
	RestManager.getMessageToAdmin()
	
	
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