---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

require( "src.resources.Globals" )
local widget = require( "widget" )
local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
	local grpLoading
    local bgShadow, iconPlaying
    self.y = h
	
	-------------------------------------
    -- Creamos el header de login
    ------------------------------------ 
    function self:buildHeaderLogin()
	
        local toolbar = display.newRect( 0, 0, display.contentWidth, 70 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        --toolbar:setFillColor( unpack(cBluen) )
		toolbar.fill = gGreenBlue
        self:insert(toolbar)

        local lblLogo = display.newText({
			text = "HOWE",
			y = 35 ,x = midW,
			font = fBold, fontSize = 25, align = "center"
		})
		lblLogo:setFillColor( unpack(cWhite) )
		self:insert(lblLogo)
		
		
		local currScene = composer.getSceneName( "current" )
	
		if ( currScene == "src.SignIn" ) then
			local iconBack = display.newImage("img/btn/regresar.png")
			iconBack:translate( 40 , 35 )
			iconBack.screen = "login"
			self:insert( iconBack )
			iconBack.height = 40
			iconBack.width = 40
			iconBack:addEventListener( 'tap', toScreen )
		end
		

    end
	
    -------------------------------------
    -- Creamos el top bar
    ------------------------------------ 
    function self:buildHeader()
	
		local lastY = 0
        
        local bgToolbar = display.newRect( 0, lastY, display.contentWidth, 70 )
        bgToolbar.anchorX = 0
        bgToolbar.anchorY = 0
        bgToolbar:setFillColor( unpack(cDarkBlue) )
        self:insert(bgToolbar)
		
		local bgToolbar0 = display.newRect( 5, lastY + 5, display.contentWidth - 10, 30 )
        bgToolbar0.anchorX = 0
        bgToolbar0.anchorY = 0
		bgToolbar0.fill = gBlueWhite0
        self:insert(bgToolbar0)
		
		local bgToolbar0 = display.newRect( 5, 35 + lastY, display.contentWidth - 10, 30 )
        bgToolbar0.anchorX = 0
        bgToolbar0.anchorY = 0
        bgToolbar0.fill = gBlueWhite1
        self:insert(bgToolbar0)

		local iconHome = display.newImage("img/btn/regresar.png")
		iconHome:translate( 40 , 35 + lastY )
		self:insert( iconHome )
		iconHome.height = 40
		iconHome.width = 40
		
        local lblLogo = display.newText({
			text = "RESIDENCIAL ALBORADA",
			y = 35 + lastY,x = midW + 25,
			font = fBold, fontSize = 22, align = "center"
		})
		lblLogo:setFillColor( unpack(cWhite) )
		self:insert(lblLogo)
        
    end
	
	-----------------------------------------------
    -- Creamos el menu izquierdo general
    -----------------------------------------------
	function self:buildTooLeft()
	
		local lastY = 0
	
		local scvToolbar = widget.newScrollView({
			top = 70 + lastY,
			left = 0,
			width = 80,
			height = intH - 68 - h,
			scrollWidth = 600,
			scrollHeight = 800,
			horizontalScrollDisabled = true,
			isBounceEnabled = false,
			backgroundColor = { unpack(cWhite) }
			--listener = scrollListener
		})
		self:insert(scvToolbar)
		
		local bg0 = display.newRect( 0, lastY, 80, intH - 70 - h )
		bg0.anchorX = 0
		bg0.anchorY = 0
		bg0:setFillColor( unpack(cDarkBlue) )
		scvToolbar:insert(bg0)
		
		local lineScv = display.newLine( 83, 70 + lastY, 83, intH )
		lineScv:setStrokeColor( 171/255, 172/255, 176/255 )
		lineScv.strokeWidth = 6
		lineScv.alpha = .6
		self:insert(lineScv)
		
		local lastY = 0
		
		local optionTool = { "GuardAssigned", "Messages", "visit", "report", "invitation", "pass", "alert" }
		local iconTool = { "guardia.png", "message.png", "vistas.png", "reportes.png", "invitaciones.png", "pases.png", "alert.png" }
		local optionLabel = { "GUARDIA EN TURNO", "MENSAJES", "VISITAS", "REPORTES", "INVITACIONES", "PASES", "EMITIR ALERTA" }
		local optionSubLabel = { "Comunicáte a Caseta", "Enviar mensaje a Administración", "Agenda y Solicita visitas programadas", 
			"Envia Reportes", "Envia Invitaciones", "Otorga pases a tus invitados", "" }
		
		local lastY = 0
		
		for i = 1, #optionTool, 1 do	
			
			local bg0 = display.newRect( 0, lastY, 80, 100 )
			bg0.anchorX = 0
			bg0.anchorY = 0
			bg0.screen = optionTool[i]
			bg0:setFillColor( unpack(cDarkBlue) )
			scvToolbar:insert(bg0)
			bg0:addEventListener( 'tap', toScreen )
			
			print()
			
			local currScene = composer.getSceneName( "current" )
			if currScene == "src." .. optionTool[i] then
				--bg0:setFillColor( unpack(cWhite) )
				bg0.fill = gGreenBlue
			end
			
			local icon0 = display.newImage("img/btn/" .. iconTool[i])
			icon0:translate( 40 , lastY + 50 )
			--icon0.height = 40
			--icon0.width = 40
			scvToolbar:insert( icon0 )
			
			lastY = lastY + 100
			
		end
		
		scvToolbar:setScrollHeight(lastY)
	 
	end
	
	-----------------------------------------------
    -- Creamos el menu izquierdo en el home
    ------------------------------------ ----------
	function self:buildTooLeftHome()
	
		local lastY = 0
	
		local scvToolbar = widget.newScrollView({
			top = 70 + lastY,
			left = 0,
			width = intW + 1,
			height = intH - 68 - h,
			scrollWidth = 600,
			scrollHeight = 800,
			horizontalScrollDisabled = true,
			isBounceEnabled = false,
			backgroundColor = { unpack(cWhite) }
			--listener = scrollListener
		})
		self:insert(scvToolbar)
		
		local bg0 = display.newRect( 0, lastY, 80, intH - 70 - h )
		bg0.anchorX = 0
		bg0.anchorY = 0
		bg0:setFillColor( unpack(cDarkBlue) )
		scvToolbar:insert(bg0)
		
		local lineScv = display.newLine( 82, 70 + lastY, 82, intH )
		lineScv:setStrokeColor( 171/255, 172/255, 176/255 )
		lineScv.strokeWidth = 6
		lineScv.alpha = .6
		self:insert(lineScv)
		
		local optionTool = { "GuardAssigned", "Messages", "visit", "report", "invitation", "pass", "alert" }
		local iconTool = { "guardia.png", "message.png", "vistas.png", "reportes.png", "invitaciones.png", "pases.png", "alert.png" }
		local optionLabel = { "GUARDIA EN TURNO", "MENSAJES", "VISITAS", "REPORTES", "INVITACIONES", "PASES", "EMITIR ALERTA" }
		local optionSubLabel = { "Comunicáte a Caseta", "Enviar mensaje a Administración", "Agenda y Solicita visitas programadas", 
			"Envia Reportes", "Envia Invitaciones", "Otorga pases a tus invitados", "" }
		
		local lastY = 0
		
		for i = 1, #optionTool, 1 do
		
			local bg1 = display.newRect( 80, lastY, intW - 79, 100 )
			bg1.anchorX = 0
			bg1.anchorY = 0
			bg1.screen = optionTool[i]
			bg1:setFillColor( unpack(cWhite) )
			scvToolbar:insert(bg1)
			bg1:addEventListener( 'tap', toScreen )
			
			local bg0 = display.newRect( 0, lastY, 80, 100 )
			bg0.anchorX = 0
			bg0.anchorY = 0
			bg0:setFillColor( unpack(cDarkBlue) )
			scvToolbar:insert(bg0)
			
			local icon0 = display.newImage("img/btn/" .. iconTool[i])
			icon0:translate( 40 , lastY + 50 )
			--icon0.height = 40
			--icon0.width = 40
			scvToolbar:insert( icon0 )
			
			local lbl0 = display.newText({
				text = optionLabel[i],
				y = lastY + 43,x = midW + 70, width = intW - 80,
				font = fRegular, fontSize = 22, align = "left"
			})
			lbl0:setFillColor( unpack(cDarkBlue) )
			scvToolbar:insert(lbl0)
			
			local lbl1 = display.newText({
				text = optionSubLabel[i],
				y = lastY + 65,x = midW + 70, width = intW - 80,
				font = fLight, fontSize = 16, align = "left"
			})
			lbl1:setFillColor( unpack(cDarkBlue) )
			scvToolbar:insert(lbl1)
			
			local line1 = display.newLine( 80, lastY - 3, intW, lastY  - 3 )
			line1:setStrokeColor( unpack(cGreenWater) )
			line1.strokeWidth = 2
			line1.alpha = .6
			scvToolbar:insert(line1)
			
			lastY = lastY + 100
			
		end
		
		scvToolbar:setScrollHeight(lastY)
	 
	end
    
    -- Cambia pantalla
    function toMenu(event)
        composer.gotoScene("src.Menu", { time = 400, effect = "slideLeft" } )
        return true
    end
    
    -- Cambia pantalla
    function toScreen(event)
        local t = event.target
		composer.removeScene( "src."..t.screen )
		composer.gotoScene("src."..t.screen )
        --composer.gotoScene("src."..t.screen, { time = 400, effect = t.animation, params = { item = t.item } } )
        return true
    end
    
    -- Cambia pantalla
    function toPrevious(event)
        local t = event.target
        composer.gotoScene(composer.getSceneName( "previous" ), { time = 400, effect = 'slideLeft' } )
        return true
    end
	
	-- trim
	function trimString( s )
		return string.match( s,"^()%s*$") and "" or string.match(s,"^%s*(.*%S)" )
	end
    
	 -------------------------------------
    -- Creamos el cargando ( loading )
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
	function self:setLoading( isLoading, parent )
        if isLoading then
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
            grpLoading = display.newGroup()
            parent:insert(grpLoading)
            
			-- local bg = display.newRect( (display.contentWidth / 2), (parent.height / 2), display.contentWidth, parent.height )
			local bg = display.newRect( midW, (parent.height / 2), parent.width, parent.height )
			--bg:setFillColor( .5 )
            bg:setFillColor( .95 )
            bg.alpha = .3
            grpLoading:insert(bg)
			bg:addEventListener( 'tap', noAction )
            
            local sheet, loading
          
			sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
			loading = display.newSprite(sheet, Sprites.loading.sequences)
		   
			loading.x = 125
			loading.y = midH - 50
            grpLoading:insert(loading)
            loading:setSequence("play")
            loading:play()
        else
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
        end
    end
	
	function noAction( )
		return true
	end
	
    return self
end











