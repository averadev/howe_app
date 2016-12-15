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
local groupABtnSvContent = display.newGroup()

local dbConfig = DBManager.getSettings()

--variables
local svMessage
local itemsAdmin
local posY = 0
local idDeleteA = {}
local noLeidoA = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function setItemsNotiAdmin( items )

	print(#items)
	
	if #items > 0 then
		itemsAdmin = items
		buildMensageItems()
		--deleteLoadingLogin()
	else
		getNoContent(svMessage,'En este momento no cuentas con mensajes')
		--deleteLoadingLogin()
	end
	
end

--muestra y/o oculta el boton de eliminar visitas
function showBtnDeleteAdmin(isTrue, isActive, idVisit, posc)
	
	if isTrue then
		groupASvContent.y = 80
		groupABtnSvContent.alpha = 1
		svMessage:setScrollHeight(posY + 80)
	else
		groupASvContent.y = 0
		groupABtnSvContent.alpha = 0
		svMessage:setScrollHeight(posY)
	end
	if isActive then
		idDeleteA[posc] = idVisit
	else
		idDeleteA[posc] = 0
	end
	
end

--elimina las visitas selecionadas
function deleteAdmin( event )
	--table.remove(idDeleteA,2)
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

function refreshMessageAdmin()
	
	groupASvContent:removeSelf();
	groupABtnSvContent:removeSelf();
	groupASvContent = display.newGroup()
	groupABtnSvContent = display.newGroup()
	RestManager.getMessageToAdmin()
	
	tools:setLoading( false, grpLoading )
	
end

function markReadAdmin( event )

	print( event.target.id)
	
	event.target:removeEventListener('tap', markReadAdmin)
	
	if noLeidoA[event.target.posci] then
		noLeidoA[event.target.posci]:removeSelf()
		noLeidoA[event.target.posci] = nil
		--[[noLeidoA[event.target.posci]:removeSelf()
		noLeidoA[event.target.posci] =  display.newImage( "img/btn/mensaje-leido.png" )
		noLeidoA[event.target.posci].x = 110
		noLeidoA[event.target.posci].y = event.target.pocY + 60
		svContent:insert(noLeidoA[event.target.posci])]]
	end
	
	RestManager.markMessageRead( event.target.id, 1 )
	RestManager.getMessageUnRead()
	
end


function buildMensageItems( event)

	posY = 35
	
	local srvW = svMessage.contentWidth
	local srvH = svMessage.contentHeight

	svMessage:insert(groupASvContent)
	svMessage:insert(groupABtnSvContent)
	
	groupABtnSvContent.alpha = 0
	
	--[[local bgDeleteMsg = display.newRoundedRect( 0, posY + 30, 170, 60, 5 )
	bgDeleteMsg.anchorX = 0
	bgDeleteMsg:setFillColor( 0, 80/255, 0 )
	svMessage:insert(bgDeleteMsg)]]
	
	local bgDeleteAdmin = display.newRect( srvW/2, posY, srvW - 30, 60 )
    bgDeleteAdmin:setFillColor( unpack(cWhite) )   
	bgDeleteAdmin.fill = gGreenBlue
    groupABtnSvContent:insert(bgDeleteAdmin)
	
	btnDeleteAdmin = display.newRect( srvW/2, posY, srvW - 34, 56 )
    btnDeleteAdmin:setFillColor( unpack(cWhite) ) 
    groupABtnSvContent:insert(btnDeleteAdmin)
	btnDeleteAdmin:addEventListener( 'tap', deleteAdmin )
	
	local txtBtnDeleteAdmin = display.newText( {
		text = "Borrar mensajes",
		x = srvW/2, y = posY,
		font = fRegular, fontSize = 24, align = "center"
	})
	txtBtnDeleteAdmin:setFillColor( unpack(cDarkBlue) )
	groupABtnSvContent:insert(txtBtnDeleteAdmin)
	
	for y = 1, #itemsAdmin, 1 do
		
		idDeleteA[y] = 0
	
		itemsAdmin[y].posc = y
	
		local message = Message:new()
		groupASvContent:insert(message)
		message:build(itemsAdmin[y], srvW)
		message.y = posY
		message.id = itemsAdmin[y].idXref
		message.posci = y
		message.posY = posY
		--message:addEventListener('tap', markReadAdmin)
		
		
			noLeidoA[y] = display.newCircle( 315, posY + 30, 12 )
			noLeidoA[y]:setFillColor( 0.5 )
			noLeidoA[y].fill = gGreenBlue
			groupASvContent:insert(noLeidoA[y])
			
		if itemsAdmin[y].leido == "0" then
			message:addEventListener( 'tap', markReadAdmin )
		else
			noLeidoA[y].alpha = 0
		end
		
		
		
		--[[if itemsAdmin[y].leido == "0" then
			noLeidoA[y] =  display.newImage( "img/btn/mensaje-nvo.png" )
		else
			noLeidoA[y] =  display.newImage( "img/btn/mensaje-leido.png" )
		end
		noLeidoA[y].x = 110
		noLeidoA[y].y = posY + 60
		groupASvContent:insert(noLeidoA[y])]]
		
		--[[if itemsAdmin[y].leido == "0" then
				noLeidoA[y] =  display.newImage( "img/btn/mensaje-nvo.png" )
			else
				noLeidoA[y] =  display.newImage( "img/btn/mensaje-leido.png" )
            end
			noLeidoA[y].x = 110
			noLeidoA[y].y = posY + 60
			groupASvContent:insert(noLeidoA[y])
           ]]
		   
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
		top =  h + 71,
		left = 86,
		width = intW - 85,
		height = intH - ( h + 69),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	}
	grpMessages:insert(svMessage)
	
	--createGuard()
	
	grpLoading = display.newContainer( (intW + midW) - 85, (intH * 2)  )
	screen:insert( grpLoading )
	grpLoading.y = - intH + (70 + h)
	grpLoading.x = -midW + 86
	grpLoading.anchorY = 0
	grpLoading.anchorX = 0
	
	tools:setLoading( true, grpLoading )
	
	RestManager.getMessageToAdmin()
	
	--getBuildMessageItem() 
	
	--RestManager.getLastGuard()
	
	
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