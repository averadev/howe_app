---------------------------------------------------------------------------------
-- Howe
-- Alfredo Zum
-- GeekBucket 2016
---------------------------------------------------------------------------------

-- Mediciones de pantalla
intW = display.contentWidth
intH = display.contentHeight
midW = display.contentCenterX
midH = display.contentCenterY
hm3 = intH / 3
h = display.topStatusBarContentHeight

numCondominium = 0
	
-- token de usuario
playerIdToken = 0

-- Colors
cBlack = { 0 }
cGrayL = { .93 }
cGrayB = { .88 }
cWhite = { 1 }
cGreenWater = { 0, .72, .43 }
cBluenWater = { 0, .76, .78 }
--cDarkBlue = { .03, .07, .16 }
cDarkBlue = { .05, .09, .20 }
cDarkBlue2 = { .03, .07, .25  }
cDarkBlue = { .05, .09, .20 }

gGreenBlue = {
    type = "gradient",
    color1 = { unpack(cGreenWater) },
    color2 = { unpack(cBluenWater) },
    direction = "right"
}

gBlueWhite0 = {
    type = "gradient",
    color1 = { unpack(cDarkBlue) },
    color2 = { unpack(cDarkBlue2) },
    direction = "down"
}

gBlueWhite1 = {
    type = "gradient",
    color1 = { unpack(cDarkBlue) },
    color2 = { unpack(cDarkBlue2) },
    direction = "up"
}

-- Fonts
local environment = system.getInfo( "environment" )
if environment == "simulator" then
	fBold = native.systemFontBold
	fBoldItalic = native.systemFontBold
	fLight = native.systemFont
	fRegular = native.systemFont
else
	fBold = "Raleway-Bold.ttf"
	fBoldItalic = "Raleway-BoldItalic.ttf"
	fLight = "Raleway-Light.ttf"
	fRegular = "Raleway-Regular.ttf"
end