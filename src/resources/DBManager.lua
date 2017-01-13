---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db

	-- Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
	    path = system.pathForFile("howe.db", system.DocumentsDirectory)
	    db = sqlite3.open( path )     
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end
	 
	-- Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end
	
	--limpia la tabla de admin, guardia y condominio
    dbManager.clearUser = function()
        openConnection( )
        query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', apellido = '', condominioId = 0, city = 0, residencial = 0, type = 0;"
        db:exec( query )
		query = "delete from condominios;"
        db:exec( query )
		query = "delete from residencial;"
        db:exec( query )
		closeConnection( )
    end
	
	-- Verificamos campo en tabla
    local function updateTable(table, field, typeF)
	    local oldVersion = true
        for row in db:nrows("PRAGMA table_info("..table..");") do
            if row.name == field then
                oldVersion = false
            end
        end

        if oldVersion then
            local query = "ALTER TABLE "..table.." ADD COLUMN "..field.." "..typeF..";"
            db:exec( query )
        end   
	end
	
	-- obtiene los datos de configuracion
	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	--inserta los datos del condominio
	dbManager.insertResidencial = function(items)
		openConnection( )
			query = "DROP TABLE IF EXISTS residencial;"
			db:exec( query )
			query = "CREATE TABLE IF NOT EXISTS residencial (id INTEGER, nombre TEXT, telAdministracion TEXT, telCaseta TEXT, telLobby TEXT, requireFoto INTEGER);"
			db:exec( query )
			for i = 1, #items, 1 do
				local query = "INSERT INTO residencial VALUES ('" .. items[i].id .."', '" .. items[i].nombre .."', '" .. items[i].telAdministracion .."', '" .. items[i].telCaseta .."', '" .. items[i].telLobby .."', 0 );"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--actualiza los datos del admin
    dbManager.updateUser = function(idApp, email, password, name, apellido, condominio)
		openConnection( )
			local query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', apellido = '', condominioId = 0;"
			db:exec( query )
			query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', apellido = '"..apellido.."', condominioId = '"..condominio.."', type = 1;"
			db:exec( query )
		closeConnection( )
	end
	
	
	

	
	--inserta los datos del condominio
	dbManager.insertCondominium = function(items)
		openConnection( )
			query = "DROP TABLE IF EXISTS condominios;"
			db:exec( query )
			query = "CREATE TABLE IF NOT EXISTS condominios (id INTEGER, idUser INTEGER, nombre TEXT );"
			db:exec( query )
			for i = 1, #items, 1 do
				local query = "INSERT INTO condominios VALUES ('" .. items[i].condominioId .."', '" .. items[i].id .."', '" .. items[i].nameCondominious .."');"
				local result = db:exec( query )
			end
			
		closeConnection( )
	end
	
	--actualiza los datos del admin
    dbManager.updateAdmin = function(idApp, email, password, name, city, residencial)
		openConnection( )
        local query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', city = '"..city.."', residencial = '"..residencial.."', type = 2;"
        db:exec( query )
		closeConnection( )
	end
	
	--inserta los guardias de la residencial
	dbManager.insertGuard = function(items)
		openConnection( )
			for i = 1, #items, 1 do
				local query = "INSERT INTO empleados VALUES ('" .. items[i].id .."', '" .. items[i].nombre .."', '" .. items[i].contrasena .."', '" .. items[i].foto .."', '0');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--inserta los datos del condominio
	dbManager.insertCondominiumAdmin = function(items)
		openConnection( )
			for i = 1, #items, 1 do
				local query = "INSERT INTO condominios VALUES ('" .. items[i].id .."', 0 , '" .. items[i].nombre .."');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--inserta los datos de la residencia
	dbManager.insertResidentialAdmin = function(items)
		openConnection( )
		local query = "INSERT INTO residencial VALUES ('" .. items[1].id .."', '" .. items[1].nombre .."', '', '', '', '" .. items[1].requiereFoto .."');"
		db:exec( query )
		closeConnection( )
	end
	
	--inserta los datos de los asuntos
	dbManager.insertAsuntos = function(items)
		openConnection( )
        local query = ""
        for i = 1, #items, 1 do
            query = "INSERT INTO asuntos VALUES ('" .. items[i].id .."', '" .. items[i].name .."');"
            db:exec( query )
        end
		closeConnection( )
	end

	-- Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, apellido TEXT, "..
					" condominioId INTEGER, city INTEGER, residencial INTEGER, type INTEGER, url TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS condominios (id INTEGER, idUser INTEGER, nombre TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS residencial (id INTEGER, nombre TEXT, telAdministracion TEXT, telCaseta TEXT, telLobby TEXT, requireFoto INTEGER);"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS empleados (id INTEGER, nombre TEXT, contrasena TEXT, foto TEXT, "..
					" active INTEGER );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS cat_notificaciones_seguridad (id INTEGER PRIMARY KEY AUTOINCREMENT, idMSG INTEGER, empleadosId INTEGER, asunto TEXT, mensaje TEXT, fechaHora TEXT, enviado INTEGER );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS registro_visitas (id INTEGER PRIMARY KEY AUTOINCREMENT, idRV INTEGER, empleadosId INTEGER, nombreVisitante TEXT, motivo TEXT," ..
		"idFrente TEXT, idVuelta TEXT, condominiosId INTEGER, fechaHora TEXT, enviado INTEGER );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS asuntos (id INTEGER, name TEXT );"
		db:exec( query )

        -- Return if have connection
		for row in db:nrows("SELECT idApp, type FROM config;") do
            closeConnection( )
            if row.idApp == 0  or row.type == 0 then
                return false
            else
                return row.type
            end
		end
		
        -- Populate config
		--query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://www.plantecsafe.com/');"
		--query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://localhost:8080/howe_ws/');"
		query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 0, 0, 0, 'http://geekbucket.com.mx/howe_ws/');"
		
		db:exec( query )
    
		closeConnection( )
    
        return false
	end
	
	-- Setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager