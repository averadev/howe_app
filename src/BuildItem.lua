---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

local widget = require( "widget" )
local Sprites = require('src.resources.Sprites')
require('src.resources.Globals')

---------------------------------------------------------------------------------
-- new alert()
---------------------------------------------------------------------------------
local screenW = intW - 85

local colorSuccess = {68/255, 157/255, 68/255}
local colorDanger = {201/255, 48/255, 44/255}
local colorWarning = {236/255, 151/255, 31/255}

local messageConfirm
local grpMessageLogin

---------------------------------------
-- Muestra un mensaje
-- @param isOpen indica si el mensaje se mostrara
-- @param title titulo de la alerta
-- @param message mensaj que se mostrara
---------------------------------------
function NewAlert( isOpen, title, message )
	local posY = 300 + h
	if isOpen then
		if messageConfirm then
			messageConfirm:removeSelf()
			messageConfirm = nil
		end
		messageConfirm = display.newGroup()
		
		local bgShade = display.newRect( midW, midH + h, intW, intH )
		bgShade:setFillColor( 0, 0, 0, .3 )
		messageConfirm:insert(bgShade)
		bgShade:addEventListener( 'tap', sinAction)
		
		local bg0 = display.newRect( screenW/2 + 85, posY - 43, screenW - 70, 200 )
		bg0.anchorY = 0
		bg0:setFillColor( unpack( cWhite ) )
		bg0.fill = gGreenBlue
		messageConfirm:insert(bg0)
		
		local bg1 = display.newRect( screenW/2 + 85, posY - 42, screenW - 72, 198 )
		bg1.anchorY = 0
		bg1:setFillColor( unpack( cWhite ) )
		messageConfirm:insert(bg1)
		
		local lblTitle = display.newText( {
			text = title,
			x = screenW/2 + 85, y = posY -17,
			width = screenW - 30,
			font = fRegular, fontSize = 18, align = "center"
		})
		lblTitle:setFillColor( unpack(cDarkBlue) )
		messageConfirm:insert( lblTitle )
		
		posY = posY + 10
		
		local line1 = display.newLine( 120, posY, intW - 35, posY )
		line1:setStrokeColor( unpack(cGreenWater) )
		line1.strokeWidth = 1
		line1.alpha = .6
		messageConfirm:insert(line1)
		
		posY = posY + 30
		
		local lblMessage = display.newText( {
			text = message,
			x = screenW/2 + 85, y = posY -17,
			width = screenW - 100,
			font = fRegular, fontSize = 16, align = "left"
		})
		lblMessage:setFillColor( unpack(cDarkBlue) )
		lblMessage.anchorY = 0
		messageConfirm:insert( lblMessage )
		
	else
		if messageConfirm then
			messageConfirm:removeSelf()
			messageConfirm = nil
		end
	end
end

---mensaje del login
function getMessageSignIn(meessage, typeS)

	if not grpMessageLogin then
		
		grpMessageLogin = display.newGroup()
		--LoginScreen:insert(grpMessageLogin)
		grpMessageLogin.y = intH
		
		local bgIconPasswordLogin = display.newRect( intW/2, intH - 62, intW, 125 )
		if typeS == 1 then
			bgIconPasswordLogin:setFillColor( colorSuccess[1], colorSuccess[2], colorSuccess[3], .9 )
		else
			bgIconPasswordLogin:setFillColor( colorWarning[1], colorWarning[2], colorWarning[3], .9 )
		end
		grpMessageLogin:insert(bgIconPasswordLogin)
		
		--[[local title = display.newText( meessage, 0, 15, fontDefault, 30)
		title:setFillColor( colorWhite )
		title.x = display.contentWidth / 2
		title.y = intH - 85
		grpMessageLogin:insert(title)]]
		
		local title = display.newText( {
			text = meessage,     
			x = display.contentWidth / 2, y = intH - 85, width = intW,
			font = fontDefault, fontSize = 28, align = "center"
		})
		grpMessageLogin:insert(title)
		
		if typeS == 1 then
			iconMessageSignIn= display.newImage( "img/btn/iconTickWhite.png"  )
		else
			iconMessageSignIn= display.newImage( "img/btn/iconWarningWhite.png"  )
		end
		iconMessageSignIn.width = 35
		iconMessageSignIn.height = 35
		iconMessageSignIn.x = intW/2
		iconMessageSignIn.y = intH - 40
		grpMessageLogin:insert(iconMessageSignIn)
		
		--deleteLoadingLogin()
		
		transition.to( grpMessageLogin, { y = 0, time = 600, transition = easing.outExpo, onComplete=function()
				--[[transition.to( grpMessageLogin, { y = 0, time = 600, transition = easing.outExpo, onComplete=function()
						transition.to( grpMessageLogin, { y = 200, time = 600, transition = easing.inQuint, onComplete=function()
							end
						})
					end
				})]]
			end
		})
		
	end
	
end

---------------------------------------
-- Elimina el mensaje de login
---------------------------------------
function deleteMessageSignIn()
	if grpMessageLogin then
		transition.to( grpMessageLogin, { y = 200, time = 300, transition = easing.inQuint, onComplete=function()
			grpMessageLogin:removeSelf()
			grpMessageLogin = nil
		end})
	end
	
end

---------------------------------------
-- Cargando
---------------------------------------
function getLoadingLogin(poscY, titleLogin)
	if not grpLoadingLogin then
		
		grpLoadingLogin = display.newGroup()
			
		-- Sprite and text
		local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
		local loadingBottom = display.newSprite(sheet, Sprites.loading.sequences)
		loadingBottom.x = intW / 2
		loadingBottom.y = poscY
		grpLoadingLogin:insert(loadingBottom)
		loadingBottom:setSequence("play")
		loadingBottom:play()

		--[[local title = display.newText( "Cargando", 0, 30, fontLatoRegular, 24)
		title:setFillColor( 1 )
		title.x = display.contentWidth / 2
		title.y = poscY + 60
		grpLoadingLogin:insert(title)
		title.text = titleLogin]]
	else
		grpLoadingLogin:removeSelf()
		grpLoadingLogin = nil
		getLoadingLogin(poscY, titleLogin)
	end
end

---------------------------------------
-- Elimina el cargando
---------------------------------------
function deleteLoadingLogin()
	if grpLoadingLogin then
		grpLoadingLogin:removeSelf()
		grpLoadingLogin = nil
	end
end

---------------------------------------
-- Muestra mensaje de no encontrado
-- @param obj objeto padre donde se insertara los elementos
-- @param txtData texto
---------------------------------------
function getNoContent(obj, txtData)
	if not grpLoading then
		grpLoading = display.newGroup()
		obj:insert(grpLoading)
			
		local noData = display.newImage( "img/bgk/SIN-MENSAJES.png" )
		noData.x = obj.contentWidth / 2
		noData.y = (obj.height / 2) - 100
		grpLoading:insert(noData)
		noData.height = 331
		noData.width = 250
	else
		grpLoading:removeSelf()
		grpLoading = nil
		getNoContent(obj, txtData)
	end
end

---------------------------------------
-- impide la expancion del tap
---------------------------------------
function sinAction( event )
	return true
end