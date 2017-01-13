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
	--composer.gotoScene( "src.admin.login", {
	composer.gotoScene( "src.UserType", {
		time = 400,
		effect = "crossFade"
	})
else
	if isUser == 1 then
		--composer.gotoScene( "src.Visits" )
		composer.gotoScene( "src.Home", {
			time = 400,
			effect = "crossFade",
			params = { id = 20 }
		})
	elseif isUser == 2 then
		--composer.gotoScene( "src.Visits" )
		composer.gotoScene( "src.admin.LoginGuard", {
			time = 400,
			effect = "crossFade",
			params = { id = 20 }
		})
	end
end
