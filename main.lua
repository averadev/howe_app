---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')

local isUser = DBManager.setupSquema()

if not isUser then
	composer.gotoScene("src.Login")
else
	composer.gotoScene("src.Messages")
end
