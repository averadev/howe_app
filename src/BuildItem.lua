
local widget = require( "widget" )
local Sprites = require('src.resources.Sprites')
local Globals = require('src.resources.Globals')

---------------------------------------------------------------------------------
-- new alert()
---------------------------------------------------------------------------------

--variables para el tamaño del entorno
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local colorSuccess = {68/255, 157/255, 68/255}
local colorDanger = {201/255, 48/255, 44/255}
local colorWarning = {236/255, 151/255, 31/255}

local messageConfirm
local grpMessageLogin

function NewAlert( title ,message, typeAL)

	if not messageConfirm then
    
		local midW = display.contentWidth / 2
		local midH = display.contentHeight / 2
		local intW = display.contentWidth
		local intH = display.contentHeight
		messageConfirm = display.newGroup()
        
		local bgShade = display.newRect( midW, midH + h, intW, intH )
		bgShade:setFillColor( 0, 0, 0, .3 )
		messageConfirm:insert(bgShade)
		bgShade:addEventListener( 'tap', sinAction)
        
		local bg = display.newRoundedRect( midW, 150, 400 + h, 400, 10 )
		bg.anchorY = 0
		bg:setFillColor( 6/255, 24/255, 46/255)
		messageConfirm:insert(bg)
		
		local lineRecordVisit = display.newLine( intW/2 - 200, 310 + h, intW/2 + 200, 310 + h )
		lineRecordVisit:setStrokeColor( 225/255, 0, 4/255 )
		lineRecordVisit.strokeWidth = 4
		lineRecordVisit.y = lineRecordVisit.y - bg.contentHeight/4
		messageConfirm:insert(lineRecordVisit)
		
		local labelTitleNewAlert = display.newText( {   
			x = midW, y = 320 + h,
			text = title,  font = fontDefault, fontSize = 30, align = "center",
		})
		labelTitleNewAlert:setFillColor( 1 )
		labelTitleNewAlert.y = labelTitleNewAlert.y - bg.contentHeight/2 + 50
		messageConfirm:insert(labelTitleNewAlert)
	
		local labelMessageNewAlert = display.newText( {   
			x = midW, y = 250 + h,
			width = 380, height = 300,
			text = message,  font = fontDefault, fontSize = 24, align = "center",
		})
		labelMessageNewAlert:setFillColor( 1 )
		labelMessageNewAlert.y = labelMessageNewAlert.y + labelMessageNewAlert.contentHeight/2
		messageConfirm:insert(labelMessageNewAlert)
		
		if typeAL == 1 then
			
			local btnCloseNewAlert = display.newRoundedRect( midW, 480 + h, 200, 60, 10 )
			btnCloseNewAlert:setFillColor( 51/255, 176/255, 46/255)
			messageConfirm:insert(btnCloseNewAlert)
			btnCloseNewAlert:addEventListener( 'tap', deleteNewAlert)
			
			local labelMessageNewAlert = display.newText( {   
				x = midW, y = 467 + h,
				text = "ACEPTAR",  font = fontDefault, fontSize = 24, align = "center",
			})
			labelMessageNewAlert:setFillColor( 1 )
			labelMessageNewAlert.y = labelMessageNewAlert.y + labelMessageNewAlert.contentHeight/2
			messageConfirm:insert(labelMessageNewAlert)
			
		end
		
	else
	
		messageConfirm:removeSelf()
		messageConfirm = nil
		NewAlert(title, message, typeAL)
		
	end
	
end

function deleteNewAlert()
	if messageConfirm then
		messageConfirm:removeSelf()
		messageConfirm = nil
	end
	local composer = require( "composer" )
	if composer.getSceneName( "current" ) == "src.Suggestions" then
		moveGrpTextField(2)
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

function deleteMessageSignIn()
	if grpMessageLogin then
		transition.to( grpMessageLogin, { y = 200, time = 300, transition = easing.inQuint, onComplete=function()
			grpMessageLogin:removeSelf()
			grpMessageLogin = nil
		end})
	end
	
end

--cargando
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

function deleteLoadingLogin()
	if grpLoadingLogin then
		grpLoadingLogin:removeSelf()
		grpLoadingLogin = nil
	end
end

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
		
		--[[local title = display.newText( txtData, 0, 30, "Chivo", 16)
		title:setFillColor( 0 )
		title.x = obj.contentWidth / 2
		title.y = (obj.height / 2) 
		grpLoading:insert(title) ]]
	else
		grpLoading:removeSelf()
		grpLoading = nil
		getNoContent(obj, txtData)
	end
end


function sinAction( event )
	return true
end