# ACTION: 
# When run, this shadedrelief.makefile download the raster GIS DEM sources, process them (unzip, crop, shaded relief, resize), to output an elegant shaded relief png (current) or topojson/svg.
# RUN:
#	cd ./home/.../wikimaps/
#	make -f shadedrelief.makefile WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 ITEM=France
# SOURCES:
#	http://www.imagemagick.org/script/command-line-options.php#alpha

#--------------------------------------------------------------------------

#DEFAULT VALUES (customizable):
WIDTH=1500
FUZZ=7
#MAKEFILE
progressive_transparency: grey_wiping
	convert shadedrelief.grey_no.png -alpha copy -channel alpha -negate +channel $(ITEM).shadedrelief.trans.png

grey_wiping: resizing
	convert $(ITEM).shadedrelief.grey.png -fuzz $(FUZZ)% -transparent "#DDDDDD" shadedrelief.grey_no.png

resizing: shading
	convert shadedrelief.tif -resize $(WIDTH) $(ITEM).shadedrelief.grey.png

shading: crop
	gdaldem hillshade crop.tif shadedrelief.tif -z 5 -s 111120 -az 315 -alt 60

#---- Crop
crop: unzip
	gdal_translate -projwin $(WEST) $(NORTH) $(EAST) $(SOUTH) ETOPO1_Ice_g_geotiff.tif crop.tif  #ETOPO1_Ice_g_geotiff.tif
	# ulx uly lrx lry (geodegrees)  // W N E S #todo: add name parameter

#---- Download
unzip: download
	unzip -n ../data/ETOPO1/ETOPO1.zip '*.tif' #-n: no overwrite if exist;
	touch ETOPO1_Ice_g_geotiff.tif

download: clean
#	curl -o ../data/ETOPO1/ETOPO1.zip 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/georeferenced_tiff/ETOPO1_Ice_g_geotiff.zip'
	echo "download by shadedrelief: done!"

clean:  
	# task commands to improve!
	echo "hello" > fakefile.ext
	rm `ls | grep -v '.makefile'| grep -v '.tif'`
	#$(RM) $(filter-out $(wildcard *.zip) Makefile,$(wildcard *))