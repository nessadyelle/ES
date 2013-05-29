
local maingame = {}

maingame.new = function( params )	local gameGroup = display.newGroup()
		local sprite = require "sprite"	local physics = require "physics"	local ui = require "ui"
		local background	local ground	local charObject	local flower
	local pauseBtn
	local pauseMenuBtn
	local pauseBG
	local menuBtn			local scoreText
	local highScoreText	local plateText	local livesText	local shade	local gameOverScreen	local gameIsActive = false
		local startDrop	local gameLives = 3	local gameScore = 0	local plateCount = 0
	local highScore	local mRand = math.random
		local plateDensity = 1.0	local plateShape = { -12,-13, 12,-13, 12,13, -12,13 }
	local panShape = { 15,-13, 65,-13, 65,13, 15,13 }
		system.setAccelerometerInterval( 100 )		local plateCaughtSound = audio.loadSound( "plate.wav" )	local gameOverSound = audio.loadSound( "gameover.wav" )
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
	
	
	local gameActivate = function()				gameIsActive = true	
		
		pauseBtn.isVisible = true
		pauseBtn.isActive = true			end
		local moveChar = function(event)
		charObject.x = display.contentCenterX - (display.contentCenterX * (event.yGravity*3))
		
		if((charObject.x - charObject.width * 0) < 0) then			charObject.x = charObject.width * 0		elseif((charObject.x + charObject.width * 0) > display.contentWidth) then			charObject.x = display.contentWidth - charObject.width * 0		end	end
	
	local setScore = function( scoreNum )
	
		local newScore = scoreNum				gameScore = newScore				if gameScore < 0 then gameScore = 0; end
		
		scoreText.text = "Score: " .. tostring( gameScore )
		scoreText.xScale = 0.5; scoreText.yScale = 0.5			scoreText.x = (scoreText.contentWidth * 0.5) + 15		scoreText.y = 15	end
	
	local callGameOver = function()
	
		audio.play( gameOverSound )				gameIsActive = false			physics.pause()
		
		
		pauseBtn.isVisible = false
		pauseBtn.isActive = false
		
		shade = display.newRect( 0, 0, 570, 320 )		shade:setFillColor( 0, 0, 0, 255 )		shade.x = 240; shade.y = 160		shade.alpha = 0
		
		gameOverScreen = display.newImageRect( "gameOver.png", 400, 300 )				local newScore = gameScore		setScore( newScore )				gameOverScreen.x = 240; gameOverScreen.y = 160		gameOverScreen.alpha = 0
		
		gameGroup:insert( shade )
		gameGroup:insert( gameOverScreen )
	
		transition.to( shade, { time=200, alpha=0.65 } )
		transition.to( gameOverScreen, { time=500, alpha=1 } )
		
		scoreText.isVisible = false		scoreText.text = "Score: " .. tostring( gameScore )		scoreText.xScale = 0.5; scoreText.yScale = 0.5			scoreText.x = 240		scoreText.y = 160		scoreText:toFront()		timer.performWithDelay( 0, function() scoreText.isVisible = true; end, 1 )
		
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
		
		gameGroup:insert( menuBtn )	end

	local drawBackground = function()
	
		background = display.newImageRect( "bg.png", 570, 380 )		background.x = 240; background.y = 160					gameGroup:insert( background )
		
		ground = display.newImageRect( "grass.png", 570, 76 )		ground.x = 240; ground.y = 325			ground.myName = "ground"			local groundShape = { -285,-18, 285,-18, 285,18, -285,18 }		physics.addBody( ground, "static", { density=1.0, bounce=0, friction=0.5, shape=groundShape } )			gameGroup:insert( ground )		end
	
	local hud = function()
	
		plateText = display.newText( "Caught: " .. tostring( plateCount ), 0, 0, "Arial", 45 )		plateText:setTextColor( 255, 255, 255, 255 )			plateText.xScale = 0.5; plateText.yScale = 0.5			plateText.x = (480 - (plateText.contentWidth * 0.5)) - 15		plateText.y = 305				gameGroup:insert( plateText )
		
		livesText = display.newText( "Lives: " .. tostring( gameLives ), 0, 0, "Arial", 45 )		livesText:setTextColor( 255, 255, 255, 255 )			livesText.xScale = 0.5; livesText.yScale = 0.5			livesText.x = (480 - (livesText.contentWidth * 0.5)) - 15		livesText.y = 15				gameGroup:insert( livesText )
		
		scoreText = display.newText( "Score: " .. tostring( gameScore ), 0, 0, "Arial", 45 )		scoreText:setTextColor( 255, 255, 255, 255 )			scoreText.xScale = 0.5; scoreText.yScale = 0.5		scoreText.x = (scoreText.contentWidth * 0.5) + 15		scoreText.y = 15				gameGroup:insert( scoreText )
		
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
	end

	local livesCount = function()
	
	 	 gameLives = gameLives - 1
	 	 	     livesText.text = "Lives: " .. tostring( gameLives )	     livesText.xScale = 0.5; livesText.yScale = 0.5		 	 livesText.x = (480 - (livesText.contentWidth * 0.5)) - 15	 	 livesText.y = 15
	 	 	     print(gameLives .. " pratos restantes")
	     
	     if gameLives < 1 then
	     		callGameOver()
	     end	end

	local createChar = function()
	
			local characterSheet = sprite.newSpriteSheet( "charSprite.png", 128, 128 )					local spriteSet = sprite.newSpriteSet(characterSheet, 1, 4)			sprite.add( spriteSet, "move", 1, 4, 400, 0 )					charObject = sprite.newSprite( spriteSet )					charObject:prepare("move")			charObject:play()
			
			charObject.x = 240; charObject.y = 250						physics.addBody( charObject, "static", { density=1.0, bounce=0.4, friction=0.15, radius=20, shape=panShape} )			charObject.rotation = 0			charObject.isHit = false			charObject.myName = "character"
			
			flower = display.newImageRect( "flor.png", 40, 23 )			flower.alpha = 1.0			flower.isVisible = false				gameGroup:insert( charObject )			gameGroup:insert( flower )		end

	local onPlateCollision = function( self, event )

		if event.force > 1.0 and self.isHit == false then			audio.play( plateCaughtSound )
				
			self.isHit = true			print( "Prato Quebrado!")			self.isVisible = false			self.isBodyActive = false						flower.x = self.x; flower.y = self.y			flower.alpha = 0			flower.isVisible = true
			
			local fadePlate = function()				transition.to( flower, { time=500, alpha=0 } )				end				transition.to( flower, { time=50, alpha=1.0, onComplete=fadePlate } )				self.parent:remove( self )			self = nil
			
			if event.other.myName == "character" then				plateCount = plateCount + 1				plateText.text = "Caught: " .. tostring( plateCount )				plateText.xScale = 0.5; plateText.yScale = 0.5					plateText.x = (480 - (plateText.contentWidth * 0.5)) - 15				plateText.y = 305				print("Pratos Salvos")								local newScore = gameScore + 500				setScore( newScore )				elseif event.other.myName == "ground" then								livesCount()				print("ground hit")							end
			
			if gameLives < 1 then				timer.cancel( startDrop )				print("Acabou as vidas")			end			end	end

	local plateDrop = function()
		
		local plate = display.newImageRect( "plate1.png", 26, 30 )		plate.x = 240 + mRand( 120 ); plate.y = -100		plate.isHit = false				physics.addBody( plate, "dynamic",{ density=plateDensity, bounce=0, friction=0.5, radius = 20, shape=plateShape } )		plate.isFixedRotation = true		gameGroup:insert( plate )
		
		plate.postCollision = onPlateCollision		plate:addEventListener( "postCollision", plate )			end
	
	local plateTimer = function()
			startDrop = timer.performWithDelay( 1000, plateDrop, 0 )	end
		
	local gameStart = function()
			physics.start( true )			physics.setGravity( 0, 9.8 )
			
			drawBackground()			createChar()			plateTimer()			hud()			gameActivate()
						Runtime:addEventListener("accelerometer", moveChar)
			
			
			local highScoreFilename = "highScore.data"
			local loadedHighScore = loadValue( highScoreFilename )
			
			highScore = tonumber(loadedHighScore)	end

	gameStart()		return gameGroup
	
end

return maingame		
		