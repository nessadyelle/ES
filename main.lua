--Escondendo barra de statur
display.setStatusBar( display.HiddenStatusBar )

--Importar director

local director = require("director")

--Criando mainGroup

local mainGroup = display.newGroup()

--Função main

local main = function ()
	
		
	mainGroup:insert(director.directorView)
	
	director:changeScene("loadmainmenu")
	
	return true
end


main()

