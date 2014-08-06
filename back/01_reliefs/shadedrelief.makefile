#---- RUN
# make -f country.makefile ITEM=India WEST=67.0 NORTH=37.5  EAST=99.0 SOUTH=05.0

#---- DEFAULT VALUES (customizable):
WIDTH=1280
FUZZ=7
AZ=315
Z=5
SHADOW=50

#---- MAKEFILE
#---- End here
all: progressive_transparency shadow_relief clean

regeocoordinates: shadow_relief
	gdal_translate -a_ullr $(WEST) $(NORTH) $(EAST) $(SOUTH) ./color_relief-hillshade-wp-multiply.jpg ./color_relief-hillshade-wp-multiply.gis.jpg

#----PROCESSING RASTER DATA
shadow_relief: color_layer white_layer progressive_transparency
	composite -dissolve $(SHADOW) 	shadedrelief.trans.png color_relief-wp.jpg -alpha Set 		color_relief-hillshade-wp-0$(SHADOW).jpg 	#note: perfect +
	composite -dissolve 100 		shadedrelief.trans.png color_relief-wp.jpg -alpha Set 		color_relief-hillshade-wp-100.jpg 			#note: perfect ++
	convert color_relief-wp.jpg 	shadedrelief.trans.png -compose Multiply -composite 		color_relief-hillshade-wp-multiply.jpg 		#note: perfect +++
	#White+shadow:
	composite -dissolve 100 		shadedrelief.trans.png white.jpg -alpha Set 				white_relief-hillshade-wp-100.jpg #note: perfect
	convert white.jpg 				shadedrelief.trans.png -compose Multiply -composite 		white_relief-hillshade-wp-multiply.jpg 		#note: perfect +++

color_layer: resize
	# $man gdaldem : color-relief
	# Color tiff depending on color_relief.txt file. Format: elevation R G B. 
	# Elevation as floating point value, `nv` keyword, or percentage.
	# 0% being the minimum value found in the raster, 100% the maximum value.
	gdaldem color-relief crop.tiff color_relief-wikimaps.txt color_relief-wp.tiff #GIS file
	#resizing
	convert color_relief-wp.tiff -resize $(WIDTH) color_relief-wp.jpg  #tiff:5.0MB, png:1.6MB, jpg:239KB 

white_layer: resize
	convert shadedrelief.sized.tiff -fill "#ffffffff" white.jpg
#	convert shadedrelief.sized.tiff -fuzz 100% -fill white -opaque white  white.jpg

#--- Trans shades
progressive_transparency: grey_wiping
	convert shadedrelief.grey_no.png -alpha copy -channel alpha -negate +channel shadedrelief.trans.png
	convert shadedrelief.grey_to_white.png -alpha copy -channel alpha -negate +channel shadedrelief.trans2.png
grey_wiping: resize
	convert shadedrelief.sized.tiff -fuzz $(FUZZ)% -transparent "#DDDDDD" shadedrelief.grey_no.png
	convert shadedrelief.sized.tiff -fuzz $(FUZZ)% -fill "#FFFFFF" -opaque "#DDDDDD"  shadedrelief.grey_to_white.png


#---- Crop, GIS Hillshade, Resize
resize: shade
	#How to resize propotionally and keeping data / valid GIS tiff ?
	convert shadedrelief.tiff 	-resize $(WIDTH) shadedrelief.sized.tiff
	#gdal_translate  crop.tiff  -outsize $(WIDTH) 1200 resized.gdal.tif 

shade: crop
	gdaldem hillshade crop.tiff shadedrelief.tiff -z $(Z) -s 111120 -az $(AZ) -alt 60 -compute_edges

crop: unzip
	gdal_translate -projwin $(WEST) $(NORTH) $(EAST) $(SOUTH) ETOPO1_Ice_g_geotiff.tif crop.tiff  #ETOPO1_Ice_g_geotiff.tif
	# ulx uly lrx lry (geodegrees)  // W N E S #todo: add name parameter

#---- DOWNLOADS
unzip: download
	unzip -n ../data/ETOPO1/ETOPO1.zip '*.tif' 
	touch ETOPO1_Ice_g_geotiff.tif

download: clean
	mkdir -p ../data/ ../data/ETOPO1
#	curl  -o ../data/ETOPO1/ETOPO1.zip -C - 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/georeferenced_tiff/ETOPO1_Ice_g_geotiff.zip'
	echo "[fake] download by shadedrelief: done!"

.PHONY: clean

clean:  
	rm -f *.tiff
	rm -f *.jpg
	rm -f *[a-km-z0-9].png #keeps the thumbnail.png
#	rm -f *.tiff
#	rm -f *.dbf
#	rm -f *.prj 
#	rm -f *.shp
#	rm -f *.shx
#	rm -f *.html
#	rm -f *.txt
#	rm -f *.json