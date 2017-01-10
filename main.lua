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
	--composer.gotoScene( "src.LoginFacebook" )
	composer.gotoScene( "src.LoginFacebook", {
		time = 400,
		effect = "crossFade"
	})
else
	--composer.gotoScene( "src.Visits" )
	composer.gotoScene( "src.LoginFacebook", {
		time = 400,
		effect = "crossFade",
		params = { id = 20 }
	})
end
