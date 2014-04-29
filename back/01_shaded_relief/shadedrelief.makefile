# ACTION: 
# When run, this shadedrelief.makefile download the raster GIS DEM sources, process them (unzip, crop, shaded relief, resize), to output an elegant shaded relief png (current) or topojson/svg.
# RUN:
#	cd ./home/.../wikimaps/
#	make -f shadedrelief.makefile WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 ITEM=France
# SOURCES:
#	http://www.imagemagick.org/script/command-line-options.php#alpha

#--------------------------------------------------------------------------

#DEFAULT VALUES (customizable):
WIDTH=1280
FUZZ=7
AZ=315
Z=5
#MAKEFILE
all: progressive_transparency merge_relief-color

# layer_opacity:
#	convert input.png -alpha set -channel A -evaluate set 50% output.png

merge_relief-color: color_relief progressive_transparency
	python ./hsv_merge.py hill-relief-w.tiff shadedrelief.tif hill-relief-merged-w.tiff
	python ./hsv_merge.py hill-relief-c.tiff shadedrelief.tif hill-relief-merged-c.tiff
	python ./hsv_merge.py hill-relief-c.tiff $(ITEM).shadedrelief.trans.png hill-relief-merged-c2.tiff
	python ./hsv_merge.py hill-relief-o.tiff shadedrelief.tif hill-relief-merged-o.tiff
	convert hill-relief-c.tiff $(ITEM).shadedrelief.trans.png \
         -alpha Off -compose CopyOpacity -composite \
         hill-relief-merged-c3.tiff
         
#Color tiff depending on color_relief.txt file. Format: elevation R G B.
color_relief: shading
	gdaldem color-relief crop.tif color_relief-white.txt    hill-relief-w.tiff
	gdaldem color-relief crop.tif color_relief-wikimaps.txt hill-relief-c.tiff
	gdaldem color-relief crop.tif color_relief-origin.txt   hill-relief-o.tiff

progressive_transparency: grey_wiping
	convert shadedrelief.grey_no.png -alpha copy -channel alpha -negate +channel $(ITEM).shadedrelief.trans.png

grey_wiping: resizing
	convert $(ITEM).shadedrelief.grey.png -fuzz $(FUZZ)% -transparent "#DDDDDD" shadedrelief.grey_no.png

resizing: shading
	convert shadedrelief.tif -resize $(WIDTH) $(ITEM).shadedrelief.grey.png
	convert hill-relief-merged-c.tiff -resize $(WIDTH) $(ITEM).shadedrelief-c.png

shading: crop
	gdaldem hillshade crop.tif shadedrelief.tif -z $(Z) -s 111120 -az $(AZ) -alt 60

#---- Crop
crop: unzip
	gdal_translate -projwin $(WEST) $(NORTH) $(EAST) $(SOUTH) ETOPO1_Ice_g_geotiff.tif crop.tif  #ETOPO1_Ice_g_geotiff.tif
	# ulx uly lrx lry (geodegrees)  // W N E S #todo: add name parameter

#---- Download
unzip: download
	unzip -n ../data/ETOPO1/ETOPO1.zip '*.tif' #-n: no overwrite if exist;
	touch ETOPO1_Ice_g_geotiff.tif

download: clean
	# curl -o ../data/ETOPO1/ETOPO1.zip 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/georeferenced_tiff/ETOPO1_Ice_g_geotiff.zip'
	echo "[fake] download by shadedrelief: done!"

clean:  
	# task commands to improve!
	echo "hello" > fakefile.ext
	rm `ls | grep -v '.makefile'| grep -v '.tif' | grep -v '.txt' | grep -v '.py' `
	#$(RM) $(filter-out $(wildcard *.zip) Makefile,$(wildcard *))
