success: utilities something Qgis low_level nodejs		#a task with 4 requirements
	echo "======================================"	#this is the 1st command
	echo "Wikiatlas setup: done --------> 100% !"
	#tab before each command is COMPULSORY (spaces will bug!).

utilities:			# a task with no dependency
	sudo apt-get install make curl unzip unrar gdal-bin 
 
something:
	sudo apt-get install build-essential		#comment, is this needed ?

Qgis:
#	sudo apt-get install add-apt-repository ;
	sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable ;
	sudo apt-get update ;
	sudo apt-get install qgis


nodejs:				#for d3js & svg generation
	sudo add-apt-repository ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install nodejs
	sudo npm install -g topojson jsdom
 
low_level:			#for more advanced coding