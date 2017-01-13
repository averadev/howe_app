---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

require( 'src.resources.Globals' )
local widget = require( "widget" )
local composer = require( "composer" )
local RestManager = require('src.resources.RestManager')

Panel = {}
function Panel:new()
    -- Variables
    local self = display.newGroup()
    --local fxTap = audio.loadSound( "fx/click.wav")
    local notif =  {}
	local srvPanel
    
    -------------------------------------
    -- Creamos el top bar
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
    function self:build()
        
       --[[ bg = display.newRect( intW - 75, h, 150, intH - h )
        bg.anchorY = 0
        bg:setFillColor( .5, .2 )
        self:insert(bg)]]
		
		srvPanel = widget.newScrollView{
			top =  h,
			left = 0,
			width = intW,
			height = 60,
			verticalScrollDisabled = true,
			backgroundColor = { .5, .2  }
		}
		self:insert(srvPanel)
		
        
        reloadPanel()
    end
    
    function reloadPanel()
        clearNotif()
        RestManager.getNotif()
    end
    
    function clearNotif()
        for i=1, #notif do
            if notif[i] then
                notif[i]:removeSelf()
                notif[i] = nil
            end
        end
        notif =  {}
    end
    
    function updateAction(event)
        clearNotif()
        RestManager.updateVisitAction(event.target.idVisit, event.target.newAction)
    end
    
    function drawNotif(items)
        local lastX = 50
        for z = 1, #items, 1 do 
            local idx = #notif + 1
			
			notif[idx] = display.newContainer( 100, 60 )
            notif[idx].x = lastX
            notif[idx].y = 30
            srvPanel:insert( notif[idx] )
			
			 local btnNotif = display.newRect( 0, 0, 100, 58 )
            notif[idx]:insert(btnNotif)
			if items[z].action == "0" then
                btnNotif:setFillColor( .7)
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( .5 )
                btnNotif.idVisit = items[z].id
            elseif items[z].action == "2" then
                btnNotif:setFillColor( 0, 102/255, 0 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 0, 50/255, 0 )
                btnNotif.idVisit = items[z].id
                btnNotif.newAction = 4
                btnNotif:addEventListener( 'tap', updateAction )
            elseif items[z].action == "3" then
                btnNotif:setFillColor( 102/255, 0, 0 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 50/255, 0, 0 )
                btnNotif.idVisit = items[z].id
                btnNotif.newAction = 5
                btnNotif:addEventListener( 'tap', updateAction )
            elseif items[z].action == "4" then
                btnNotif:setFillColor( 0, 102/255, 0, .2 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 0, 50/255, 0, .2 )
            elseif items[z].action == "5" then
                btnNotif:setFillColor( 102/255, 0, 0, .2 )
                btnNotif.strokeWidth = 8
                btnNotif:setStrokeColor( 50/255, 0, 0, .2 )
            end 
			
			if items[z].action == "0" then
               local labelNumCondo = display.newText( {
                    text = items[z].nombre,   
                    x = 0, y = -10,
                    font = fontDefaultBold, fontSize = 18, align = "center"
                })
                labelNumCondo:setFillColor( 1 )
                notif[idx]:insert(labelNumCondo)
                local labelNumCondo = display.newText( {
                    text = "Pendiente",   
                    x = 0, y = 12,
                    font = fontDefault, fontSize = 14, align = "center"
                })
                labelNumCondo:setFillColor( 1 )
                notif[idx]:insert(labelNumCondo)
            else
                local labelNumCondo = display.newText( {
                    text = items[z].nombre,   
                    x = 0, y = 0,
                    font = fontDefaultBold, fontSize = 18, align = "center"
                })
                labelNumCondo:setFillColor( 1 )
                notif[idx]:insert(labelNumCondo)
            end
			
			lastX = lastX + 100
			
        end
        
    end
    
    return self
end







