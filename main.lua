---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

-- Your code here

display.setStatusBar( display.TranslucentStatusBar )

local composer = require( "composer" )
local DBManager = require('src.resources.DBManager')

local isUser = DBManager.setupSquema()

if not isUser then
	composer.gotoScene("src.UserType")
else
	composer.gotoScene("src.Home")
end
