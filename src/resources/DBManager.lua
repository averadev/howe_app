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
			query = "CREATE TABLE IF NOT EXISTS residencial (id INTEGER, nombre TEXT, telAdministracion TEXT, telCaseta TEXT, telLobby TEXT);"
			db:exec( query )
			for i = 1, #items, 1 do
				local query = "INSERT INTO residencial VALUES ('" .. items[i].id .."', '" .. items[i].nombre .."', '" .. items[i].telAdministracion .."', '" .. items[i].telCaseta .."', '" .. items[i].telLobby .."');"
				db:exec( query )
			end
		closeConnection( )
	end
	
	--actualiza los datos del admin
    dbManager.updateUser = function(idApp, email, password, name, apellido, condominio)
		openConnection( )
			local query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', apellido = '', condominioId = 0;"
			db:exec( query )
			query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', apellido = '"..apellido.."', condominioId = '"..condominio.."';"
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

	-- Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, apellido TEXT, "..
					" condominioId INTEGER, url TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS condominios (id INTEGER, idUser INTEGER, nombre TEXT );"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS residencial (id INTEGER, nombre TEXT, telAdministracion TEXT, telCaseta TEXT, telLobby TEXT);"
		db:exec( query )

        -- Return if have connection
		for row in db:nrows("SELECT idApp, condominioId FROM config;") do
            closeConnection( )
            if row.idApp == 0  or row.condominioId == 0 then
                return false
            else
                return true
            end
		end
		
        -- Populate config
		--query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://www.plantecsafe.com/');"
		query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://localhost:8080/howe/');"
		
		db:exec( query )
    
		closeConnection( )
    
        return false
	end
	
	-- Setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager