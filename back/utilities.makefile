#---- D3js
success: low_level utilities nodejs GDAL_via_Qgis accessibility      #a task with 4 requirements, as tasks or files
	echo "======================================"   #this is the 1st command
	echo "Wikiatlas setup: done --------> 100% !"
	#tab before each command is COMPULSORY (spaces will bug!).

#---- Sugar
low_level:			#for more advanced coding
	sudo apt-get -y install build-essential        #comment, is this needed ?
	sudo apt-get -y install python g++

utilities:          # a task with no dependency
	sudo apt-get install git curl unzip unrar gdal-bin imagemagick python-software-properties

nodejs:				#for d3js & svg generation
	sudo add-apt-repository -y ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install -y nodejs
	sudo npm update -g npm
	#
	sudo npm install -g topojson jsdom minimist
	npm cache clean

GDAL_via_Qgis:
#	sudo apt-get install add-apt-repository ;
	sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
	sudo apt-get update
	sudo apt-get -y install qgis

accessibility:
	mkdir academic
	curl -o ./academic/ColorOracleJar.zip -C - http://colororacle.org/ColorOracleJar.zip
	unzip -n ./academic/ColorOracleJar.zip -d ./academic
	chmod a+x ./academic/ColorOracle.jar
	./academic/ColorOracle.jar

