# SOURCES:
#	http://www.imagemagick.org/script/command-line-options.php
#--------------------------------------------------------------------------

#DEFAULT VALUES (customizable):
WIDTH=1280
FUZZ=7
AZ=315
Z=5
SHADOW=50

#MAKEFILE
all: progressive_transparency merge_relief-color

# layer_opacity:
#	convert input.png -alpha set -channel A -evaluate set 50% output.png

merge_relief-color: GIS_color_relief progressive_transparency
	python ./hsv_merge.py hill-relief-f.tiff shadedrelief.r.tiff			hill-relief-merged-f.tiff
	python ./hsv_merge.py hill-relief-o.tiff shadedrelief.r.tiff			hill-relief-merged-o.tiff
	python ./hsv_merge.py hill-relief-w.tiff shadedrelief.r.tiff			hill-relief-merged-w1.tiff #note: get clear
	python ./hsv_merge.py hill-relief-w.tiff $(ITEM).shadedrelief.trans.png hill-relief-merged-w2.tiff #note: get silver
	convert 			  hill-relief-w.tiff $(ITEM).shadedrelief.trans.png \
		-alpha Off -compose CopyOpacity -composite 							hill-relief-merged-w3.tiff #note: get trans
	convert 			  hill-relief-w.tiff $(ITEM).shadedrelief.trans.png -compose Multiply -composite hill-relief-merged-w4.tiff #note: perfect
	composite -dissolve $(SHADOW) $(ITEM).shadedrelief.trans.png hill-relief-w.tiff -alpha Set hill-relief-merged-w5.tiff #note: perfect

#Color tiff depending on color_relief.txt file. Format: elevation R G B.
GIS_color_relief: resize
	# $man gdaldem : color-relief
	# 	The elevation value can be any floating point value, or the nv keyword 
	# 	for nodata value.. The elevation can also be expressed as a percentage : 
	# 	0% being the minimum value found in the raster, 100% the maximum value.
	gdaldem color-relief crop.tiff color_relief-white.txt    hill-relief-f.tiff
	gdaldem color-relief crop.tiff color_relief-wikimaps.txt hill-relief-w.tiff
	gdaldem color-relief crop.tiff color_relief-origin.txt   hill-relief-o.tiff
	#resizing
	convert hill-relief-f.tiff -resize $(WIDTH) hill-relief-f.tiff
	convert hill-relief-w.tiff -resize $(WIDTH) hill-relief-w.tiff
	convert hill-relief-o.tiff -resize $(WIDTH) hill-relief-o.tiff

#--- Trans shades
progressive_transparency: grey_wiping
	convert shadedrelief.grey_no.png -alpha copy -channel alpha -negate +channel $(ITEM).shadedrelief.trans.png

grey_wiping: resize
	convert shadedrelief.r.tiff -fuzz $(FUZZ)% -transparent "#DDDDDD" shadedrelief.grey_no.png

#---- Crop, GIS Hillshade, Resize
resize: shade
	#How to resize propotionally and keeping data / valid GIS tiff ?
	convert crop.tiff 			-resize $(WIDTH) crop.r.tiff
	convert shadedrelief.tiff 	-resize $(WIDTH) shadedrelief.r.tiff
	#gdal_translate  crop.tif  -outsize $(WIDTH) 1200 resized.gdal.tif 

shade: crop
	gdaldem hillshade crop.tiff shadedrelief.tiff -z $(Z) -s 111120 -az $(AZ) -alt 60 -compute_edges

crop: unzip
	gdal_translate -projwin $(WEST) $(NORTH) $(EAST) $(SOUTH) ETOPO1_Ice_g_geotiff.tif crop.tiff  #ETOPO1_Ice_g_geotiff.tif
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
	rm -f `ls | grep -v '.makefile'| grep -v '.tif' | grep -v '.txt' | grep -v '.py' `
	#$(RM) $(filter-out $(wildcard *.zip) Makefile,$(wildcard *))
