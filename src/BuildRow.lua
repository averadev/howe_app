
--variables para el tamaño del entorno
require( 'src.resources.Globals' )

---------------------------------------------------------------------------------
-- MESSAGE
---------------------------------------------------------------------------------
Message = {}
local assigned = 0
local contDeleteAdmin = 0
function Message:new()
    -- Variables
    local self = display.newGroup()
	local btnCheckInA
	function AssignedCoupon(item)
		assigned = item
	end
    
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
	
	function checkBoxDeleteA( event )
	
		local active
		if event.target.check == 0 then
			btnCheckInA.alpha = 1
			event.target.check = 1
			contDeleteAdmin = contDeleteAdmin + 1
			active = true
		else
			btnCheckInA.alpha = 0
			event.target.check = 0
			contDeleteAdmin = contDeleteAdmin - 1
			active = false
		end
		
		if contDeleteAdmin > 0 then
			showBtnDeleteAdmin(true, active, event.target.id, event.target.posc)
		else
			showBtnDeleteAdmin(false,active, event.target.id, event.target.posc)
		end
		
		return true
	end
    
    -- Creamos la pantalla del menu
    --function self:build(isBg, item, image)
	function self:build(item, srvW)
        -- Generamos contenedor
        local container = display.newContainer( srvW, 110 )
        container.x = srvW/2
        container.y = 15
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showMessage )
		container.anchorY = 0

        local maxShape = display.newRect( 0, 0, 460, 100 )
        maxShape:setFillColor( unpack(cGrayL) )
		maxShape.fill = gGreenBlue
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 98 )
        maxShape:setFillColor( unpack(cWhite) )
        container:insert( maxShape )
		
		local txtFecha = display.newText( {
			text = item.dia .. ", " .. item.fechaFormat,
            x = -15, y = -30,
            width = srvW,
            font = fLight, fontSize = 16, align = "right",
        })
        txtFecha:setFillColor( unpack(cDarkBlue ) )
        container:insert(txtFecha)

        -- Agregamos textos
		local txtPartner = display.newText( {
				--text = item.partner,
			text = "DE: " .. item.nombreAdmin .. " " .. item.apellidosAdmin,
            x = 15, y = -15,
            width = srvW,
            font = fRegular, fontSize = 18, align = "left"
        })
        txtPartner:setFillColor( unpack(cDarkBlue ) )
        container:insert(txtPartner)

        local txtInfo = display.newText( {
            text = "Asunto: " .. item.asunto:sub(1,30).."...",
            x = 15, y = 20, width = srvW,
            font = fRegular, fontSize = 18, align = "left"
        })
        txtInfo:setFillColor( unpack(cDarkBlue ) )
        container:insert(txtInfo)
		
		local bgCheckA = display.newRect( -150, -25, 50, 50 )
		bgCheckA:translate( srvW - 80, 40 )
        bgCheckA:setFillColor( unpack(cWhite ) )
		bgCheckA.check = 0
		bgCheckA.id = item.idXref
		bgCheckA.posc = item.posc
		bgCheckA.alpha = .02
        container:insert( bgCheckA )
		bgCheckA:addEventListener( 'tap', checkBoxDeleteA )
		
		local btnCheckOutA = display.newImage( "img/btn/select0.png" )
        btnCheckOutA:translate( srvW - 230, 15 )
        container:insert( btnCheckOutA )
		
		btnCheckInA = display.newImage( "img/btn/select1.png" )
        btnCheckInA:translate( srvW - 227, 13 )
		btnCheckInA.alpha = 0
        container:insert( btnCheckInA )
        
    end

    return self
end

Visit = {}
local assigned = 0
local contDeleteVisit = 0
function Visit:new()
    -- Variables
    local self = display.newGroup()
	local btnCheckIn
	local grpTracing
	local container
	
	function AssignedCoupon(item)
		assigned = item
	end
    
    function showVisit(event)
        local composer = require( "composer" )
        --Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		--hideSearch2()
		--deleteTxt()
		
        local current = composer.getSceneName( "current" )
		if current ~= "src.Visit" then
            composer.removeScene( "src.Visit" )
			composer.gotoScene( "src.Visit", {
                time = 400,
                effect = "crossFade",
                params = { id = event.target.item.id }
            })
		end
    end
	
	function checkBoxDelete( event )
		local active
		if event.target.check == 0 then
			btnCheckIn.alpha = 1
			event.target.check = 1
			contDeleteVisit = contDeleteVisit + 1
			active = true
		else
			btnCheckIn.alpha = 0
			event.target.check = 0
			contDeleteVisit = contDeleteVisit - 1
			active = false
		end
		
		if contDeleteVisit > 0 then
			showBtnDeleteVisit(true, active, event.target.id, event.target.posc)
		else
			showBtnDeleteVisit(false,active, event.target.id, event.target.posc)
		end
		
		return true
	end
	
	function VisitTracking( event )
	
		local t = event.target
	
		if grpTracing then
			grpTracing.alpha = 0
		end
		
		getAccess()
		
		return true
	end
	
	function returnVisitTracking()
		
		local bgAccepted = display.newRect( 0, 70, 360, 60 )
			bgAccepted:setFillColor( unpack( cWhite) )   
			bgAccepted.fill = gGreenBlue
			container:insert(bgAccepted)
		
	end
    
    -- Creamos la pantalla del menu
    --function self:build(isBg, item, image)
	function self:build( item, srvW )
	
        -- Generamos contenedor
        container = display.newContainer( srvW, 220 )
        container.x = srvW/2
        container.y = 0
		container.item = item
        self:insert( container )
		--container:addEventListener( "tap", showVisit )
		container.anchorY = 0

        local maxShape = display.newRect( 0, 0, 460, 220 )
        maxShape:setFillColor( unpack(cGrayL) )
		maxShape.fill = gGreenBlue
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 218 )
        maxShape:setFillColor( unpack(cWhite) )
        container:insert( maxShape )

        -- Agregamos textos
		
		local txtFecha = display.newText( {
			text = item.dia .. ", " .. item.fechaFormat,
            x = 40, y = -90,
            width = srvW,
            font = fBoldItalic, fontSize = 18, align = "left",
        })
        txtFecha:setFillColor( unpack(cDarkBlue ) )
        container:insert(txtFecha)
		
		local txtHora = display.newText( {
			text = item.hora,
            x = -15, y = -90,
            width = srvW,
            font = fBoldItalic, fontSize = 18, align = "right",
        })
        txtHora:setFillColor( unpack(cDarkBlue ) )
        container:insert(txtHora)
        
		local lbl1 = display.newText({
			text = "Visitante: ",
			x = 15, y = -60,
            width = srvW,
            font = fRegular, fontSize = 16, align = "left"
        })
        lbl1:setFillColor( unpack(cDarkBlue ) )
        container:insert(lbl1)
		
        local txtVisit = display.newText( {
			text = item.nombreVisitante:sub(1,20),
			x = 15, y = -50,
            width = srvW,
            font = fBold, fontSize = 20, align = "left"
        })
        txtVisit:setFillColor( unpack(cDarkBlue ) )
        container:insert(txtVisit)
		txtVisit.anchorY = 0
		
		local lbl1 = display.newText({
			text = "Asunto: ",
			x = 15, y = -10,
            width = srvW,
            font = fRegular, fontSize = 16, align = "left"
        })
        lbl1:setFillColor( unpack(cDarkBlue ) )
        container:insert(lbl1)

        local txtInfo = display.newText( {
			text = item.motivo:sub(1,40),
            x = 15, y = 3, width = srvW,
            font = fBold, fontSize = 20, align = "left"
        })
        txtInfo:setFillColor( unpack( cDarkBlue ) )
        container:insert(txtInfo)
		txtInfo.anchorY = 0
		
		if ( item.action == '0' ) then
		
			grpTracing = display.newGroup()
			container:insert(grpTracing)
		
			local bgReject = display.newRect( -95, 70, 170, 60 )
			bgReject:setFillColor( unpack( cWhite) )   
			bgReject.fill = gGreenBlue
			grpTracing:insert(bgReject)
			
			local btnReject = display.newRect( -95, 70, 168, 58 )
			btnReject:setFillColor( unpack( cWhite) )
			btnReject.action = 3 
			grpTracing:insert(btnReject)
			btnReject:addEventListener( 'tap', VisitTracking )
			
			local iconReject = display.newImage( "img/btn/logout.png" )
			iconReject:translate( -157, 70 )
			grpTracing:insert( iconReject )
			iconReject.height = 30
			iconReject.width = 30
			
			local lbl1 = display.newText({
				text = "RECHAZAR",
				x = -85, y = 70,
				width = 170,
				font = fRegular, fontSize = 18, align = "center"
			})
			lbl1:setFillColor( unpack( cDarkBlue ) )
			grpTracing:insert(lbl1)
			
			local btnAccept = display.newRect( 95, 70, 170, 60 )
			btnAccept:setFillColor( unpack(cWhite) )   
			btnAccept.fill = gGreenBlue
			btnAccept.action = 2
			grpTracing:insert(btnAccept)
			btnAccept:addEventListener( 'tap', VisitTracking )
			
			local iconAccept = display.newImage( "img/btn/aceptar.png" )
			iconAccept:translate( 35, 70 )
			grpTracing:insert( iconAccept )
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
			grpTracing:insert(lbl1)
		else
			
			local bgAccepted = display.newRect( 0, 70, 360, 60 )
			bgAccepted:setFillColor( unpack( cWhite) )   
			bgAccepted.fill = gGreenBlue
			container:insert(bgAccepted)
				
			local btnAccepted = display.newRect( 0, 70, 358, 58 )
			btnAccepted:setFillColor( unpack( cWhite) )
			container:insert(btnAccepted)
			
			local lblAccepted = display.newText({
				text = "",
				x = 15, y = 70,
				width = 360,
				font = fRegular, fontSize = 18, align = "center"
			})
			lblAccepted:setFillColor( unpack( cDarkBlue ) )
			container:insert(lblAccepted)
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
			container:insert( iconAccepted )
			iconAccepted.height = 30
			iconAccepted.width = 30
			iconAccepted:setFillColor( unpack(cWhite) ) 
		
		end
        
    end

    return self
end