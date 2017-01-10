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
local screen, grpVisits
local scene = composer.newScene()
local tools
local svVisits
local grpSvVisits = display.newGroup()
local grpDelete = display.newGroup()
local grpEdit = display.newGroup()
local grpBtnDelete = display.newGroup()

local dbConfig = DBManager.getSettings()
-- Variables
local newH = 0
local grpLoading
local itemsGuard
local first = 0
local posY = 0
local idDeleteV = {}
local itemsVisit = {}
local noLeido = {}
local visits = {}
local container = {}
local btnCheckOutV = {}
local btnCheckInV = {}
local grpTracing = {}
	

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function setItemsVisits( items )
	if #items > 0 then
		itemsVisit = items
		buildVisitItems()
		--deleteLoadingLogin()
	else
		getNoContent(svVisits,'En este momento no cuentas con visitantes')
		
	end
	tools:setLoading( false, grpLoading )
end

function getAccess()
	
	RestManager.updateVisitAction(idMSG, 2)
	
end

--muestra y/o oculta el boton de eliminar visitas
function showBtnDeleteVisit(isTrue, isActive, idVisit, posc)
	
	if isTrue then
		grpSvVisits.y = 80
		grpDelete.alpha = 1
		svVisits:setScrollHeight(posY + 80)
	else
		grpSvVisits.y = 0
		grpDelete.alpha = 0
		svVisits:setScrollHeight(posY)
	end
	if isActive then
		idDeleteV[posc] = idVisit
	else
		idDeleteV[posc] = 0
	end
	
end

--elimina las visitas selecionadas
function deleteVisit( event )
	--table.remove(idDeleteV,2)
	local visitDelete = {}
	for i= 1, #idDeleteV, 1 do
		if idDeleteV[i] ~= 0 then
			visitDelete[#visitDelete + 1] = idDeleteV[i]
		end
	end
	RestManager.deleteMsgVisit(visitDelete)
	return true
end

--obtiene los mensajes de las visitas
function refreshMessageVisit()
	grpSvVisits:removeSelf();
	grpDelete:removeSelf();
	grpEdit:removeSelf();
	grpBtnDelete:removeSelf();
	
	grpSvVisits = display.newGroup()
	grpDelete = display.newGroup()
	grpEdit = display.newGroup()
	grpBtnDelete = display.newGroup()
	
	RestManager.getMessageToVisit()
	tools:setLoading( false, grpLoading )
end

function markRead( event )

	event.target:removeEventListener('tap', markRead)
	
	if noLeido[event.target.posci] then
		noLeido[event.target.posci]:removeSelf()
		noLeido[event.target.posci] = nil
	end
	
	RestManager.markMessageRead( event.target.id, 2 )
	RestManager.getMessageUnRead()
end


function showCheckBoxV( event )
	grpDelete.alpha = 1
	grpBtnDelete.alpha = 1
	grpEdit.alpha = 0
	return true
end

function hideCheckBoxV( event )
	grpDelete.alpha = 0
	grpBtnDelete.alpha = 0
	grpEdit.alpha = 1
	return true
end

function changeCheckBoxV( event )

	local t = event.target
	
	local active
		if t.check == 0 then
		btnCheckOutV[t.posc].alpha = 0
		btnCheckInV[t.posc].alpha = 1
		t.check = 1
		--contDeleteAdmin = contDeleteAdmin + 1
		idDeleteV[t.posc] = t.id
		active = true
	else
		btnCheckInV[t.posc].alpha = 0
		btnCheckOutV[t.posc].alpha = 1
		t.check = 0
		--contDeleteAdmin = contDeleteAdmin - 1
		active = false
		idDeleteV[t.posc] = 0
	end
	
	return true
	
end

function VisitTracking( event )
	local t = event.target
	RestManager.updateVisitAction( t.id, t.action, t.posc )
end

function ChangeVisitTracking(i, action)
	
	grpTracing[i]:removeSelf()
	grpTracing[i] = display.newGroup()
	container[i]:insert( grpTracing[i] )
	
	local bgAccepted = display.newRect( 0, 70, 360, 60 )
	bgAccepted:setFillColor( unpack( cWhite) )   
	bgAccepted.fill = gGreenBlue
	container[i]:insert(bgAccepted)
				
	local btnAccepted = display.newRect( 0, 70, 358, 58 )
	btnAccepted:setFillColor( unpack( cWhite) )
	container[i]:insert(btnAccepted)
			
	local lblAccepted = display.newText({
		text = "",
		x = 15, y = 70,
		width = 360,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblAccepted:setFillColor( unpack( cDarkBlue ) )
	container[i]:insert(lblAccepted)
	local iconName = ""
	if ( action == 2 ) then
		lblAccepted.text = "VISITA ACEPTADA"
		iconName = "img/btn/icono_seleccionado.png"
	elseif ( action == 3 ) then
		lblAccepted.text = "VISITA RECHAZADA"
		iconName = "img/btn/logout.png"
	end
	local iconAccepted = display.newImage( iconName )
	iconAccepted:translate( -95, 70 )
	container[i]:insert( iconAccepted )
	iconAccepted.height = 30
	iconAccepted.width = 30
	iconAccepted:setFillColor( unpack(cWhite) ) 
	
	
end

function createVisits( i, srvW, posY )
	
	local item = itemsVisit[i]
	
	container[i] = display.newContainer( srvW, 220 )
	container[i].x = srvW/2
	container[i].y = posY
	container[i].item = item
	container[i].id = item.id
	container[i].posci = i
	grpSvVisits:insert( container[i] )
	--container:addEventListener( "tap", showVisit )
	container[i].anchorY = 0
	
	local maxShape = display.newRect( 0, 0, 460, 220 )
	maxShape:setFillColor( unpack(cGrayL) )
	maxShape.fill = gGreenBlue
	container[i]:insert( maxShape )

	local maxShape = display.newRect( 0, 0, 456, 218 )
	maxShape:setFillColor( unpack(cWhite) )
	container[i]:insert( maxShape )
	
	-- Agregamos textos
		
	local txtFecha = display.newText( {
		text = item.dia .. ", " .. item.fechaFormat,
		x = 40, y = -90,
		width = srvW,
		font = fBoldItalic, fontSize = 18, align = "left",
	})
	txtFecha:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(txtFecha)
	
	local txtHora = display.newText( {
		text = item.hora,
		x = -15, y = -90,
		width = srvW,
		font = fBoldItalic, fontSize = 18, align = "right",
	})
	txtHora:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(txtHora)
	
	local lbl1 = display.newText({
		text = "Visitante: ",
		x = 15, y = -60,
		width = srvW,
		font = fRegular, fontSize = 16, align = "left"
	})
	lbl1:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(lbl1)
	
	local txtVisit = display.newText( {
		text = item.nombreVisitante:sub(1,20),
		x = 15, y = -50,
		width = srvW,
		font = fBold, fontSize = 20, align = "left"
	})
	txtVisit:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(txtVisit)
	txtVisit.anchorY = 0
	
	local lbl1 = display.newText({
		text = "Asunto: ",
		x = 15, y = -10,
		width = srvW,
		font = fRegular, fontSize = 16, align = "left"
	})
	lbl1:setFillColor( unpack(cDarkBlue ) )
	container[i]:insert(lbl1)

	local txtInfo = display.newText( {
		text = item.motivo:sub(1,40),
		x = 15, y = 3, width = srvW,
		font = fBold, fontSize = 20, align = "left"
	})
	txtInfo:setFillColor( unpack( cDarkBlue ) )
	container[i]:insert(txtInfo)
	txtInfo.anchorY = 0
	
	if ( item.action == '0' ) then
		
		grpTracing[i] = display.newGroup()
		container[i]:insert( grpTracing[i] )
		
		local bgReject = display.newRect( -95, 70, 170, 60 )
		bgReject:setFillColor( unpack( cWhite) )   
		bgReject.fill = gGreenBlue
		grpTracing[i]:insert(bgReject)
			
		local btnReject = display.newRect( -95, 70, 168, 58 )
		btnReject:setFillColor( unpack( cWhite) )
		btnReject.id = item.id
		btnReject.action = 3 
		btnReject.posc = i
		grpTracing[i]:insert(btnReject)
		btnReject:addEventListener( 'tap', VisitTracking )
			
		local iconReject = display.newImage( "img/btn/logout.png" )
		iconReject:translate( -157, 70 )
		grpTracing[i]:insert( iconReject )
		iconReject.height = 30
		iconReject.width = 30
		
		local lbl1 = display.newText({
			text = "RECHAZAR",
			x = -85, y = 70,
			width = 170,
			font = fRegular, fontSize = 18, align = "center"
		})
		lbl1:setFillColor( unpack( cDarkBlue ) )
		grpTracing[i]:insert(lbl1)
			
		local btnAccept = display.newRect( 95, 70, 170, 60 )
		btnAccept:setFillColor( unpack(cWhite) )   
		btnAccept.fill = gGreenBlue
		btnAccept.id = item.id
		btnAccept.action = 2
		btnAccept.posc = i
		grpTracing[i]:insert(btnAccept)
		btnAccept:addEventListener( 'tap', VisitTracking )
			
		local iconAccept = display.newImage( "img/btn/aceptar.png" )
		iconAccept:translate( 35, 70 )
		grpTracing[i]:insert( iconAccept )
		iconAccept.height = 30
		iconAccept.width = 30
		iconAccept:setFillColor( unpack(cWhite) ) 
			
		local lbl1 = display.newText({
			text = "ACEPTAR",
			x = 105, y = 70,
			width = 170,
			font = fRegular, fontSize = 18, align = "center"
		})
		lbl1:setFillColor( unpack( cWhite ) )
		grpTracing[i]:insert(lbl1)
		
	else
	
		local bgAccepted = display.newRect( 0, 70, 360, 60 )
		bgAccepted:setFillColor( unpack( cWhite) )   
		bgAccepted.fill = gGreenBlue
		container[i]:insert(bgAccepted)
				
		local btnAccepted = display.newRect( 0, 70, 358, 58 )
		btnAccepted:setFillColor( unpack( cWhite) )
		container[i]:insert(btnAccepted)
			
		local lblAccepted = display.newText({
			text = "",
			x = 15, y = 70,
			width = 360,
			font = fRegular, fontSize = 18, align = "center"
		})
		lblAccepted:setFillColor( unpack( cDarkBlue ) )
		container[i]:insert(lblAccepted)
		local iconName = ""
		if ( item.action == '2' ) then
			lblAccepted.text = "VISITA ACEPTADA"
			iconName = "img/btn/icono_seleccionado.png"
		elseif ( item.action == '3' ) then
			lblAccepted.text = "VISITA RECHAZADA"
			iconName = "img/btn/logout.png"
		end
		local iconAccepted = display.newImage( iconName )
		iconAccepted:translate( -95, 70 )
		container[i]:insert( iconAccepted )
		iconAccepted.height = 30
		iconAccepted.width = 30
		iconAccepted:setFillColor( unpack(cWhite) ) 
	
	end
	
	-- checkbox
	local bgCheckV = display.newRect( -175, -15, 50, 50 )
	bgCheckV:translate( srvW + 120, posY + 100 )
	bgCheckV:setFillColor( unpack( cWhite ) )
	bgCheckV.check = 0
	bgCheckV.name = "checkbox"
	bgCheckV.id = item.id
	bgCheckV.posc = item.posc
	bgCheckV.alpha = .02
	grpDelete:insert(bgCheckV)
	bgCheckV:addEventListener( 'tap', changeCheckBoxV )
	
	btnCheckOutV[i] = display.newImage( "img/btn/icono_paraseleccionar.png" )
	btnCheckOutV[i].name = "CheckOut"
	btnCheckOutV[i].height = 30
	btnCheckOutV[i].width = 30
	btnCheckOutV[i]:translate( srvW - 55 , posY + 85 )
	grpDelete:insert( btnCheckOutV[i] )
		
	btnCheckInV[i] = display.newImage( "img/btn/icono_seleccionado.png" )
	btnCheckInV[i].name = "CheckIn"
	btnCheckInV[i].height = 30
	btnCheckInV[i].width = 30
	btnCheckInV[i]:translate( srvW - 55 , posY + 85  )
	btnCheckInV[i].alpha = 0
	grpDelete:insert( btnCheckInV[i] )
	
	-- mensajes no leidos
	noLeido[i] = display.newCircle( 20, posY + 20, 12 )
	noLeido[i]:setFillColor( 0.5 )
	noLeido[i].fill = gGreenBlue
	grpSvVisits:insert(noLeido[i])
		
	if itemsVisit[i].leido == "0" then
		container[i]:addEventListener( 'tap', markRead )
	else
		noLeido[i].alpha = 0
	end
	
end

function buildVisitItems()
	
	posY = 40
	local srvW = svVisits.contentWidth
	local srvH = svVisits.contentHeight
	
	svVisits:insert(grpSvVisits)
	svVisits:insert(grpDelete)
	grpVisits:insert(grpEdit)
	grpVisits:insert(grpBtnDelete)
	
	--svContent:insert(groupSvContent)
	--svContent:insert(groupBtnSvContent)
	
	grpBtnDelete.alpha = 0
	grpDelete.alpha = 0
	
	posY = h + 100
	
	-- btn edit
	
	local bgEdit = display.newRect( midW + 40, posY, srvW - 200, 35 )
    bgEdit:setFillColor( unpack(cWhite) )   
	bgEdit.fill = gGreenBlue
    grpEdit:insert(bgEdit)
	
	btnEdit = display.newRect( midW + 40, posY, srvW - 202, 33 )
    btnEdit:setFillColor( unpack(cWhite) ) 
    grpEdit:insert(btnEdit)
	btnEdit:addEventListener( 'tap', showCheckBoxV )
	
	local lblEdit = display.newText( {
		text = "EDITAR",
		x = midW + 40, y = posY,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblEdit:setFillColor( unpack(cDarkBlue) )
	grpEdit:insert(lblEdit)
	
	-- btn delete and cancel
	
	local btnCancelEdit = display.newRect( srvW / 2 - 10, posY, srvW / 2 - 40, 35 )
    btnCancelEdit:setFillColor( unpack( cWhite ) )
    grpBtnDelete:insert(btnCancelEdit)
	btnCancelEdit:addEventListener( 'tap', hideCheckBoxV )
	
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
	btnAcceptEdit:addEventListener( 'tap', deleteVisit )
	
	local lblAcceptEdit  = display.newText( {
		text = "ACEPTAR",
		x = srvW  - 20 , y = posY,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblAcceptEdit:setFillColor( unpack( cDarkBlue ) )
	grpBtnDelete:insert(lblAcceptEdit)
	
	-- items
	
	posY = 0
	
	for y = 1, #itemsVisit, 1 do
	--for y = 1, 1, 1 do
	
		idDeleteV[y] = 0
        itemsVisit[y].posc = y
		
		createVisits( y, srvW, posY )
		
		--[[local visit = Visit:new()
		grpSvVisits:insert(visit)
		visit:build( itemsVisit[y], srvW )
		visit.y = posY
		visit.id = itemsVisit[y].id
		visit.posci = y]]
		
		--[[noLeido[y] = display.newCircle( 315, posY + 30, 12 )
		noLeido[y]:setFillColor( 0.5 )
		noLeido[y].fill = gGreenBlue
		grpSvVisits:insert(noLeido[y])
		
		if itemsVisit[y].leido == "0" then
			visit:addEventListener( 'tap', markRead )
		else
			noLeido[y].alpha = 0
		end]]
		
		posY = posY + 220
	
	end
	
	--[[local bgDeleteVisits = display.newRect( srvW/2, posY, srvW - 30, 60 )
    bgDeleteVisits:setFillColor( unpack(cWhite) )   
	bgDeleteVisits.fill = gGreenBlue
    grpDelete:insert(bgDeleteVisits)
	
	btnDeleteVisits = display.newRect( srvW/2, posY, srvW - 34, 56 )
    btnDeleteVisits:setFillColor( unpack(cWhite) ) 
    grpDelete:insert(btnDeleteVisits)
	btnDeleteVisits:addEventListener( 'tap', deleteVisit )
	
	local txtBtnDeleteVisits = display.newText( {
		text = "Borrar visitas",
		x = srvW/2, y = posY,
		font = fRegular, fontSize = 24, align = "center"
	})
	txtBtnDeleteVisits:setFillColor( unpack(cDarkBlue) )
	grpDelete:insert(txtBtnDeleteVisits)
	
	for y = 1, #itemsVisit, 1 do
	
		idDeleteV[y] = 0
        itemsVisit[y].posc = y
		
		local visit = Visit:new()
		grpSvVisits:insert(visit)
		visit:build( itemsVisit[y], srvW )
		visit.y = posY
		visit.id = itemsVisit[y].id
		visit.posci = y
		
		noLeido[y] = display.newCircle( 315, posY + 30, 12 )
		noLeido[y]:setFillColor( 0.5 )
		noLeido[y].fill = gGreenBlue
		grpSvVisits:insert(noLeido[y])
		
		if itemsVisit[y].leido == "0" then
			visit:addEventListener( 'tap', markRead )
		else
			noLeido[y].alpha = 0
		end
		
		posY = posY + 99
	
	end]]
	
	svVisits:setScrollHeight(posY)
	
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
    grpVisits = display.newGroup()
    screen:insert( grpVisits )
	
	svVisits = widget.newScrollView{
		top =  h + 130,
		left = 86,
		width = intW - 85,
		height = intH - ( h + 69),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	}
	grpVisits:insert(svVisits)
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	tools:setLoading( true, grpLoading )
	
	RestManager.getMessageToVisit()
	
	
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