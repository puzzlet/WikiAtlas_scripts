# $(WEST) $(NORTH) $(EAST) $(SOUTH)

output: clean
	node jsdom.node.js > item.svg
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