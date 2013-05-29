--Carregando tela principal
local loadmainmenu = {}

-- Função main
loadmainmenu.new = function( params )
	local localGroup = display.newGroup()
	
	local myTimer
	local loadingImage
	
	local loadScreen = function()
		loadingImage = display.newImageRect( "loading.png", 570, 380 )
		loadingImage.x = 240; loadingImage.y = 160
		
		local goToMenu = function()
			director:changeScene( "mainmenu", "crossfade")
		end
		
		myTimer = timer.performWithDelay( 1000, goToMenu, 1 )
	end
	
	loadScreen()
	
	local initVars = function()

	  localGroup:insert(loadingImage)

    end
	
	clean = function()
	
		if myTimer then timer.cancel( myTimer ); end
		
	end
	
	initVars()
	
	
	return localGroup
end

return loadmainmenu		
		