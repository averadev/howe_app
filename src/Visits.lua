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
local grpBtnSvVisits = display.newGroup()

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
		grpBtnSvVisits.alpha = 1
		svVisits:setScrollHeight(posY + 80)
	else
		grpSvVisits.y = 0
		grpBtnSvVisits.alpha = 0
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
	grpBtnSvVisits:removeSelf();
	grpSvVisits = display.newGroup()
	grpBtnSvVisits = display.newGroup()
	RestManager.getMessageToVisit()
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


function buildVisitItems()
	
	posY = 40
	local srvW = svVisits.contentWidth
	local srvH = svVisits.contentHeight
	
	svVisits:insert(grpSvVisits)
	svVisits:insert(grpBtnSvVisits)
	
	--svContent:insert(groupSvContent)
	--svContent:insert(groupBtnSvContent)
	
	grpBtnSvVisits.alpha = 0
	
	posY = h + 100

	local bgEdit = display.newRect( midW + 40, posY, srvW - 200, 35 )
    bgEdit:setFillColor( unpack(cWhite) )   
	bgEdit.fill = gGreenBlue
    grpVisits:insert(bgEdit)
	
	btnEdit = display.newRect( midW + 40, posY, srvW - 202, 33 )
    btnEdit:setFillColor( unpack(cWhite) ) 
    grpVisits:insert(btnEdit)
	btnEdit:addEventListener( 'tap', deleteVisit )
	
	local lblEdit = display.newText( {
		text = "EDITAR",
		x = midW + 40, y = posY,
		font = fRegular, fontSize = 18, align = "center"
	})
	lblEdit:setFillColor( unpack(cDarkBlue) )
	grpVisits:insert(lblEdit)
	
	posY = 0
	
	for y = 1, #itemsVisit, 1 do
	--for y = 1, 1, 1 do
	
		idDeleteV[y] = 0
        itemsVisit[y].posc = y
		
		local visit = Visit:new()
		grpSvVisits:insert(visit)
		visit:build( itemsVisit[y], srvW )
		visit.y = posY
		visit.id = itemsVisit[y].id
		visit.posci = y
		
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
    grpBtnSvVisits:insert(bgDeleteVisits)
	
	btnDeleteVisits = display.newRect( srvW/2, posY, srvW - 34, 56 )
    btnDeleteVisits:setFillColor( unpack(cWhite) ) 
    grpBtnSvVisits:insert(btnDeleteVisits)
	btnDeleteVisits:addEventListener( 'tap', deleteVisit )
	
	local txtBtnDeleteVisits = display.newText( {
		text = "Borrar visitas",
		x = srvW/2, y = posY,
		font = fRegular, fontSize = 24, align = "center"
	})
	txtBtnDeleteVisits:setFillColor( unpack(cDarkBlue) )
	grpBtnSvVisits:insert(txtBtnDeleteVisits)
	
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