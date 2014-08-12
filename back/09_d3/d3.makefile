#---- RUN
# make -f country.makefile ITEM=India WEST=67.0 NORTH=37.5  EAST=99.0 SOUTH=05.0

#---- DEFAULT VALUES (customizable):
# Some variables are defined by master.makefile & called by svgcreator.node.js 
#	geo: { WEST, NORTH, EAST, SOUTH } ==> see master file's variable declaration
#   script: { DATE, VERSION }         ==> see master file's variable declaration

#---- MAKEFILE
output: clean
	node svgcreator.node.js > $(ITEM)-administrative_map_\(WA2014\).svg

clean:
	rm -f *.svg
#	rm -f *.json
#	rm -f *.dbf
#	rm -f *.prj 
#	rm -f *.shp
#	rm -f *.shx
#	rm -f *0.tif
#	rm -f *1.tif
#	rm -f *.html
#	rm -f *.txt
#	rm -f *.tif
#	rm -f *.makefile