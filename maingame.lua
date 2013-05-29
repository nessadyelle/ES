
local maingame = {}

maingame.new = function( params )
	
	
	local pauseBtn
	local pauseMenuBtn
	local pauseBG
	local menuBtn
	local highScoreText
	
	local highScore
	
	local panShape = { 15,-13, 65,-13, 65,13, 15,13 }
	
	local btnSound = audio.loadSound( "btnSound.wav" )
	
	
	local saveValue = function( strFilename, strValue )
		
		local theFile = strFilename
		local theValue = strValue
		
		local path = system.pathForFile( theFile, system.DocumentsDirectory )
		
		local file = io.open( path, "w+" )
		if file then
		   file:write( theValue )
		   io.close( file )
		end
	end
	
	
	local loadValue = function( strFilename )
			
		local theFile = strFilename
		
		local path = system.pathForFile( theFile, system.DocumentsDirectory )
		
		local file = io.open( path, "r" )
		if file then
		   local contents = file:read( "*a" )
		   io.close( file )
		   return contents
		else
		   file = io.open( path, "w" )
		   file:write( "0" )
		   io.close( file )
		   return "0"
		end
	end
	
	
	local gameActivate = function()
		
		pauseBtn.isVisible = true
		pauseBtn.isActive = true
	
		charObject.x = display.contentCenterX - (display.contentCenterX * (event.yGravity*3))
		
		if((charObject.x - charObject.width * 0) < 0) then
	
	local setScore = function( scoreNum )
	
		local newScore = scoreNum
		
		scoreText.text = "Score: " .. tostring( gameScore )
		scoreText.xScale = 0.5; scoreText.yScale = 0.5	
	
	local callGameOver = function()
	
		audio.play( gameOverSound )
		
		
		pauseBtn.isVisible = false
		pauseBtn.isActive = false
		
		shade = display.newRect( 0, 0, 570, 320 )
		
		gameOverScreen = display.newImageRect( "gameOver.png", 400, 300 )
		
		gameGroup:insert( shade )
		gameGroup:insert( gameOverScreen )
	
		transition.to( shade, { time=200, alpha=0.65 } )
		transition.to( gameOverScreen, { time=500, alpha=1 } )
		
		scoreText.isVisible = false
		
		-- Comparar score
		if gameScore > highScore then
			highScore = gameScore
			local highScoreFilename = "highScore.data"
			saveValue( highScoreFilename, tostring(highScore) )
		end
		
		-- Mostrar maior score
		highScoreText = display.newText( "Best Game Score: " .. tostring( highScore ), 0, 0, "Arial", 30 )
		highScoreText:setTextColor( 255, 255, 255, 255 )	
		highScoreText.xScale = 0.5; highScoreText.yScale = 0.5	
		highScoreText.x = 240
		highScoreText.y = 120
		
		gameGroup:insert( highScoreText )
		
		local onMenuTouch = function( event )
			if event.phase == "release" then
				
				audio.play( buttonSound )
				director:changeScene( "mainmenu" )
				
				
			end
		end
		
		menuBtn = ui.newButton{
			defaultSrc = "menubtn.png",
			defaultX = 60,
			defaultY = 60,
			overSrc = "menubtn-over.png",
			overX = 60,
			overY = 60,
			onEvent = onMenuTouch,
			id = "MenuButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}
		
		menuBtn.x = 100; menuBtn.y = 260
		
		gameGroup:insert( menuBtn )

	local drawBackground = function()
	
		background = display.newImageRect( "bg.png", 570, 380 )
		
		ground = display.newImageRect( "grass.png", 570, 76 )
	
	local hud = function()
	
		plateText = display.newText( "Caught: " .. tostring( plateCount ), 0, 0, "Arial", 45 )
		
		livesText = display.newText( "Lives: " .. tostring( gameLives ), 0, 0, "Arial", 45 )
		
		scoreText = display.newText( "Score: " .. tostring( gameScore ), 0, 0, "Arial", 45 )
		
		local onPauseTouch = function( event )
			if event.phase == "release" and pauseBtn.isActive then
				audio.play( buttonSound )
				
				-- Pausa o jogo
				
				if gameIsActive then
				
					gameIsActive = false
					physics.pause()
					
					local function pauseGame()
		                timer.pause( startDrop )
		                print("timer has been paused")
		            end
		            timer.performWithDelay(1, pauseGame)

					
					
					if not shade then
						shade = display.newRect( 0, 0, 570, 380 )
						shade:setFillColor( 0, 0, 0, 255 )
						shade.x = 240; shade.y = 160
						gameGroup:insert( shade )
					end
					shade.alpha = 0.5
					
					if pauseBG then
						pauseBG.isVisible = true
						pauseBG.isActive = true
						pauseBG:toFront()
					end
					
					pauseBtn:toFront()

				else
					
					if shade then
						display.remove( shade )
						shade = nil
					end
					
					
					if pauseBG then
						pauseBG.isVisible = false
						pauseBG.isActive = false
					end
					
					gameIsActive = true
					physics.start()
					
					local function resumeGame()
		                timer.resume( startDrop )
		                print("timer has been resumed")
		            end
		            timer.performWithDelay(1, resumeGame)
		
				end
			end
		end
		
		pauseBtn = ui.newButton{
			defaultSrc = "pausebtn.png",
			defaultX = 44,
			defaultY = 44,
			overSrc = "pausebtn-over.png",
			overX = 44,
			overY = 44,
			onEvent = onPauseTouch,
			id = "PauseButton",
			text = "",
			font = "Helvetica",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}
		
		pauseBtn.x = 38; pauseBtn.y = 288
		pauseBtn.isVisible = false
		pauseBtn.isActive = false
		
		gameGroup:insert( pauseBtn )
		
		pauseBG = display.newImageRect( "pauseoverlay.png", 570, 380 )
		pauseBG.x = 240; pauseBG.y = 160
		pauseBG.isVisible = false
		pauseBG.isActive = false
		
		gameGroup:insert( pauseBG )


	local livesCount = function()
	
	 	 gameLives = gameLives - 1
	 	 
	 	 
	     
	     if gameLives < 1 then
	     		callGameOver()
	     end

	local createChar = function()
	
			local characterSheet = sprite.newSpriteSheet( "charSprite.png", 128, 128 )
			
			charObject.x = 240; charObject.y = 250
			
			flower = display.newImageRect( "flor.png", 40, 23 )

	local onPlateCollision = function( self, event )

		if event.force > 1.0 and self.isHit == false then
				
			self.isHit = true
			
			local fadePlate = function()
			
			if event.other.myName == "character" then
			
			if gameLives < 1 then

	local plateDrop = function()
		
		local plate = display.newImageRect( "plate1.png", 26, 30 )
		
		plate.postCollision = onPlateCollision
	
	local plateTimer = function()
			startDrop = timer.performWithDelay( 1000, plateDrop, 0 )
		
	local gameStart = function()
			physics.start( true )
			
			drawBackground()
			
			
			
			local highScoreFilename = "highScore.data"
			local loadedHighScore = loadValue( highScoreFilename )
			
			highScore = tonumber(loadedHighScore)

	gameStart()
	
end

return maingame		
		