#---- D3js
success: utilities GDAL_via_Qgis nodejs low_level accessibility      #a task with 4 requirements, as tasks or files
	echo "======================================"   #this is the 1st command
	echo "Wikiatlas setup: done --------> 100% !"
	#tab before each command is COMPULSORY (spaces will bug!).

utilities:          # a task with no dependency
	sudo apt-get install git make curl unzip unrar gdal-bin imagemagick python-software-properties


nodejs:				#for d3js & svg generation
	sudo add-apt-repository ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install nodejs
	sudo npm install -g topojson jsdom

#---- Sugar
low_level:			#for more advanced coding
	sudo apt-get install build-essential        #comment, is this needed ?
	sudo apt-get install python g++
GDAL_via_Qgis:
#	sudo apt-get install add-apt-repository ;
	sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable ;
	sudo apt-get update ;
	sudo apt-get install qgis
accessibility:
	mkdir academic
	curl -o ./academic/ColorOracleJar.zip -C - http://colororacle.org/ColorOracleJar.zip
	unzip -n ./academic/ColorOracleJar.zip -d ./academic
	chmod a+x ./academic/ColorOracle.jar
	./academic/ColorOracle.jar
