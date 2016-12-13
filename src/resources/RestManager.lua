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
		--url = url.."/playerId/"..urlencode(Globals.playerIdToken)
		
		print(url)
	
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
						getMessageSignIn(data.message, 1)
						DBManager.updateUser(items[1].id, items[1].email, items[1].contrasena, items[1].nombre, items[1].apellido, items[1].condominioId)
						DBManager.insertCondominium(items)
						timeMarker = timer.performWithDelay( 2000, function()
							deleteLoadingLogin()
							deleteMessageSignIn()
							goToHome()
						end, 1 )
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
		print(body)

		local params = {}
		params.headers = headers
		params.body = body
		
		print(url)

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
		--url = url.."/condominioId/"..dbConfig.condominioId
		url = url.."/condominioId/"..50
	
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
	
return RestManager