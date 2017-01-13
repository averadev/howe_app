---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local RestManager = {}
	require('src.BuildItem')
	local mime = require( "mime" )
	local json = require( "json" )
	local crypto = require( "crypto" )
	require( 'src.resources.Globals' )
    local DBManager = require('src.resources.DBManager')
    local dbConfig = DBManager.getSettings()

    local site = "http://localhost/tuki_ws/"
    --local site = "http://mytuki.com/api/"
	
	--------------------------------------------
    -- codifica la cadena para enviar por get
    --------------------------------------------
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end

    function reloadConfig()
        dbConfig = DBManager.getSettings()
    end

	--------------------------------------------
    -- Envia al metodo
    --------------------------------------------
    function goToMethod(obj)
        if obj.name == "" then
        end
    end
	
	--------------------------------------------
    -- comprueba si existe conexion a internet
    --------------------------------------------
	function networkConnection()
		local netConn = require('socket').connect('www.google.com', 80)
		if netConn == nil then
			return false
		end
		netConn:close()
		return true
	end

	---------------------------------- Pantalla Login ----------------------------------
	
	--valida el logueo de residentes
	RestManager.validateUser = function(email, password)
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
		url = url.."/playerId/"..urlencode(playerIdToken)
	
        local function callback(event)
            if ( event.isError ) then
				deleteLoadingLogin()
				native.showAlert( "Plantec Resident", event.isError, { "OK"})
            else
                local data = json.decode(event.response)
                if data.success then
					local items = data.items
					local residencial = data.residencial
					DBManager.insertResidencial(residencial)
					if #items == 1 then
						messageWelcome(data.message)
						deleteLoadingLogin()
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, items[1].condominioId)
						DBManager.insertCondominium(items)
						timeMarker = timer.performWithDelay( 2000, function()
							goToHome()
						end, 1 )
						--[[getMessageSignIn(data.message, 1)
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, items[1].condominioId)
						DBManager.insertCondominium(items)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
							goToHome()
						end, 1 )]]
					else
						getMessageSignIn(data.message, 1)
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, 0)
						DBManager.insertCondominium(items)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
							goToSelectCondominiousLogin()
						end, 1 )
						
					end
                else
					getMessageSignIn(data.message, 2)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteLoadingLogin()
						deleteMessageSignIn()
						errorLogin()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
		
	---------------------------------- Pantalla SignIn ----------------------------------	
		
	--valida el logueo de residentes
	RestManager.RegisterUser = function(email, password)
	
		reloadConfig()
	
		-- local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = dbConfig.url
        url = url.."Api/RegisterUser/format/json"
        --url = url.."/idApp/"..settings.idApp
        --url = url.."/email/"..urlencode(email)
        --url = url.."/password/"..password
	
        local function networkListener( event )
			if ( event.isError ) then
				print("error")
			else
				local data = json.decode(event.response)
				if data then
					if data.success then
						getMessageSignIn(data.message, 1)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
						end, 1 )
					else
						getMessageSignIn(data.message, 1)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
						end, 1 )
					end
				else
					getMessageSignIn("Error con el servidor", 1)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteLoadingLogin()
						deleteMessageSignIn()
					end, 1 )
				end
			end
		end

		local headers = {}

		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"

		local body = ""
		body = body.."idApp=" .. dbConfig.idApp
		body = body.."&email=" .. email
		body = body.."&password=" .. password

		local params = {}
		params.headers = headers
		params.body = body

		network.request( url, "POST", networkListener, params )
		
    end
	
	---------------------------------- Pantalla guardAssigned ----------------------------------
	
	--obtiene la info del ultimo guardia en turno
	RestManager.getLastGuard = function()
		
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getLastGuard/format/json"
        url = url.."/idApp/"..dbConfig.idApp
		url = url.."/condominioId/"..dbConfig.condominioId
		
		print(url)
		
        local function callback(event)
            if ( event.isError ) then
				paintGuardDefault()
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						if data.items then
							local items = data.items
							setElementGuard(items)
						else
							paintGuardDefault()
						end
					else
						paintGuardDefault()
					end
				else
					paintGuardDefault()
				end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
	
	end
	
	---------------------------------- Pantalla messages ----------------------------------
	
	--obtiene los mensajes de administracion
	RestManager.getMessageToAdmin = function()
		
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getMessageToAdmin/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/condominioId/"..dbConfig.condominioId
	
        local function callback(event)
            if ( event.isError ) then
				noMessages("Problemas con el servidor, intente mas tarde :(")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						local items = data.items
						setItemsNotiAdmin(items)
					else
						if data.message then
							noMessages(data.message)
						else
							noMessages("Problemas con el servidor, intente mas tarde :(")
						end
					end
				else
					noMessages("Problemas con el servidor, intente mas tarde :(")
				end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	
	end
	
	--elimina los mensajes seleccionados
	RestManager.deleteMsgAdmin = function(adminId)
	
		local encoded = json.encode( adminId, { indent = true } )
		
		reloadConfig()
		
		local dbConfig = DBManager.getSettings()
        -- Set url
        local url = dbConfig.url
        url = url.."api/deleteMsgAdmin/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/idMSG/".. urlencode(encoded)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					refreshMessageAdmin()
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--marca el mesaje como leidos
	RestManager.markMessageRead = function(id, typeM)
		
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/markMessageRead/format/json"
        url = url.."/idApp/".. dbConfig.idApp
        url = url.."/idMSG/".. id
		url = url.."/typeM/".. typeM
	
        local function callback(event)
            if ( event.isError ) then
            else
				--RestManager.getMessageUnRead()
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--obtiene el numero de mensajes no leidos de visitas
	RestManager.getMessageUnRead = function()
	
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getMessageUnRead/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/condominium/"..dbConfig.condominioId
		
        local function callback(event)
            if ( event.isError ) then
				native.showAlert( "Plantec Resident", "Error con el servidor", { "OK"})
            else
                local data = json.decode(event.response)
				if data.success then
					--createNotBubble(data.items, data.items2)
                else
                   native.showAlert( "Plantec Resident", "Error con el servidor", { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	
	end
	
	--------------------------------- Pantalla message ----------------------------------
	
	--obtiene el mensaje de visitante por id
	RestManager.getMessageToAdminById = function(id)
		local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/getMessageToAdminById/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idMSG/".. id
		
		print(url)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					local items = data.items
					if #items > 0 then
						setItemsAdmin(items[1])
					else
					
					end
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	---------------------------------- Pantalla visits ----------------------------------
	
	--obtiene los mensajes de visitantes
	RestManager.getMessageToVisit = function()
		
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getMessageToVisit/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/condominioId/"..dbConfig.condominioId
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					local items = data.items
					setItemsVisits(items)
                else
                    native.showAlert( "Plantec Resident", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	
	end
	
	RestManager.updateVisitAction = function( idMSG, action, posc )
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/updateVisitAction/format/json"
        url = url.."/idMSG/".. idMSG
        url = url.."/action/".. action
	
        local function callback(event)
             if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					ChangeVisitTracking( posc, action )
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene el mensaje de visitante por id
	RestManager.deleteMsgVisit = function(visitId)
		local encoded = json.encode( visitId, { indent = true } )
	
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/deleteMsgVisit/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/idMSG/".. urlencode(encoded)
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					refreshMessageVisit()
                else
					
                end
            end
            return true
        end
		
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--------------------------------- Pantalla visit ----------------------------------
	
	--obtiene el mensaje de visitante por id
	RestManager.getMessageToVisitById = function(id)
		
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getMessageToVisitById/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/idMSG/".. id
	    
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
				if data.success then
					local items = data.items
					if #items then
						setItemsVisit(items[1])
					else
					
					end
                else
					
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--------------------------------- Report ----------------------------------
	
	--envia el mensaje de sugerencia
	RestManager.sendSuggestion = function( subject, message )
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/saveSuggestion/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/subject/".. urlencode(subject)
		url = url.."/message/".. urlencode(message)
	
        local function callback(event)
            if ( event.isError ) then
				resultMessage("Error al enviar el mensaje")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						resultMessage(data.message)
						cleanTextFieldReport()
					else
						resultMessage("Error al enviar el mensaje")
					end
				else
					resultMessage("Error al enviar el mensaje")
					
				end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
		--------------------------------- Phones ----------------------------------
	
	--envia el mensaje de sugerencia
	RestManager.getEmergencyCalls = function(  )
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getEmergencyCalls/format/json"
        url = url.."/idApp/"..dbConfig.idApp
		url = url.."/condominioId/"..dbConfig.condominioId
		 
		print(url)
		 
        local function callback(event)
            if ( event.isError ) then
				--resultMessage("Error al enviar el mensaje")
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						getPhones(data.items)
						--cleanTextFieldReport()
					else
						--resultMessage("Error al enviar el mensaje")
					end
				else
					--resultMessage("Error al enviar el mensaje")
					
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
		
	end
	
	--------------------------------- logout ----------------------------------
	
	RestManager.deletePlayerIdOfUSer = function()
	
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/deletePlayerIdOfUSer/format/json"
        url = url.."/idApp/"..dbConfig.idApp
		url = url.."/condominioId/"..dbConfig.condominioId
		--url = url.."/playerId/"..urlencode('hola')
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					local items = data.items
					
					--getMessageSignIn(data.message, 1)
					timeMarker = timer.performWithDelay( 1000, function()
						--deleteMessageSignIn()
						SignOut2()
					end, 1 )
					
                else
					--getMessageSignIn(data.message, 2)
					timeMarker = timer.performWithDelay( 2000, function()
						--deleteMessageSignIn()
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
	
	end
	
	------------------------------------------------------------------
	---------------------------------
	-- ADMIN/GUARD APP
	---------------------------------
	------------------------------------------------------------------
	
	--------------------------------- panel ----------------------------------
	
	RestManager.getNotif = function()
	
        reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/getNotif/format/json"
		url = url.."/residencial/"..dbConfig.residencial
		print(url)
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					drawNotif(data.items)
                end
            end
            return true
        end
        -- Do request
       network.request( url, "GET", callback ) 
    end
	
	--marca el mesaje como leidos
	RestManager.updateVisitAction = function(idMSG, action)
		
		reloadConfig()
        -- Set url
        local url = dbConfig.url
        url = url.."api/updateVisitAction/format/json"
        url = url.."/idMSG/".. idMSG
        url = url.."/action/".. action
		url = url.."/residencial/"..dbConfig.residencial
		print(url)
        local function callback(event)
            RestManager.getNotif()
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	--------------------------------- login ----------------------------------
	
	RestManager.validateAdmin = function(email, password, city)
	
        reloadConfig()
        -- Set url
        local url = dbConfig.url
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = dbConfig.url
        url = url.."api/validateAdmin/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
        url = url.."/playerId/".. urlencode(playerIdToken)
		
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					messageWelcome(data.message)
					deleteLoadingLogin()
					DBManager.updateAdmin(data.items[1].id, data.items[1].email, data.items[1].contrasena, data.items[1].nombre, data.items[1].ciudadesId, data.items[1].residencialId)
					DBManager.insertGuard(data.items2)
					DBManager.insertCondominiumAdmin(data.items3)
					DBManager.insertResidentialAdmin(data.items4)
					DBManager.insertAsuntos(data.asuntos)
					setItemsGuard(data.items2)
					--[[timeMarker = timer.performWithDelay( 2000, function()
						goToGuard()
					end, 1 )]]
					--[[NewAlert("Plantec Security","Usuario correcto", 0)
					DBManager.updateUser(data.items[1].id, data.items[1].email, data.items[1].contrasena, data.items[1].nombre, data.items[1].ciudadesId, data.items[1].residencialId)
					DBManager.insertGuard(data.items2)
					DBManager.insertCondominium(data.items3)
					DBManager.insertResidential(data.items4)
                    DBManager.insertAsuntos(data.asuntos)
					setItemsGuard(data.items2)]]
                    --admin@booking.com
                else
					getMessageSignIn(data.message, 2)
					timeMarker = timer.performWithDelay( 2000, function()
						deleteLoadingLogin()
						deleteMessageSignIn()
						errorLogin()
					end, 1 )
                    --native.showAlert( "Plantec Security", data.message, { "OK"})
					--[[NewAlert("Howe Security","Usuario Incorrecto", 0)
					timeMarker = timer.performWithDelay( 2000, function()
						NewAlert("Howe Security","Usuario Incorrecto", 0)
					end, 1 )]]
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.signOut = function(password)
	
        reloadConfig()
        -- Set url
        local url = dbConfig.url
        local url = dbConfig.url
        url = url.."api/signOut/format/json"
        url = url.."/idApp/"..dbConfig.idApp
        url = url.."/password/"..password
	
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                if data.success then
					print("entro")
					--DBManager.clearUser()
					--signOut()
                else
                    --native.showAlert( "Plantec Security", data.message, { "OK"})
					NewAlert(true, "Plantec Security", data.message)
					timeMarker = timer.performWithDelay( 2000, function()
						NewAlert(false, "Plantec Security", data.message)
					end, 1 )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	
return RestManager