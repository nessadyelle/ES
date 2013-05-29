-- Carregando jogo
local loadgame = {}

-- Função main
loadgame.new = function( params )
	local localGroup = display.newGroup()
	
	local myTimer
	local loadingImage
	
	local loadGame = function()
		loadingImage = display.newImageRect( "loading.png", 570, 380 )
		loadingImage.x = 240; loadingImage.y = 160
		
		local goToGame = function()
			director:changeScene( "maingame", "crossfade" )
		end
		
		myTimer = timer.performWithDelay( 1000, goToGame, 1 )
	end
	
	loadGame()
	
	local initVars = function()

	  localGroup:insert(loadingImage)

    end
	
	clean = function()
	
		if myTimer then timer.cancel( myTimer ); end
		
	end
	
	--Variáveis
	initVars()
	
	--Retorna
	return localGroup
end

return loadgame	
		