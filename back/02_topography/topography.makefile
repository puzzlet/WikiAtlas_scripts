#DEFAULT VALUES (customizable):
# inherit ITEM, WEST, NORTH, EAST, SOUTH from master.makefile.
QUANTIZATION=1e4
WIDTH=1280
TOPOJSON_LOC=../node_modules/topojson/bin/topojson
TOPOJSON_GLO=topojson
WIDTH=1280
SLICES=8

# CONTEXT SETTINGS:
SHELL=/bin/bash

#MAKEFILE
topojsonize: geojsonize
	$(TOPOJSON_LOC) --id-property none -q $(QUANTIZATION) --simplify-proportion=0.5 -p name=elev -o levels.topo.json -- levels.geo.json
	# --simplify-proportion=0.05 

geojsonize: merge
	ogr2ogr -f GeoJSON -where "elev < 10000" levels.geo.json levels.shp

merge: polygonize_slices zvals
#	ogr2ogr levels.shp 					level0001.tmp.shp
#	ogr2ogr -update -append levels.shp level0050.tmp.shp
#	ogr2ogr -update -append levels.shp level0100.tmp.shp
#	ogr2ogr -update -append levels.shp level0200.tmp.shp
#	ogr2ogr -update -append levels.shp level0500.tmp.shp
#	ogr2ogr -update -append levels.shp level1000.tmp.shp
#	ogr2ogr -update -append levels.shp level2000.tmp.shp
#	ogr2ogr -update -append levels.shp level3000.tmp.shp
#	ogr2ogr -update -append levels.shp level4000.tmp.shp
#	ogr2ogr -update -append levels.shp level5000.tmp.shp
	Slices=( $$(cat ./tmp.txt) ); \
	for i in "$${Slices[@]}"; do \
		echo $$i ;\
		ogr2ogr -update -append levels.shp level$${i}.tmp.shp; \
	done
	# maybe do factorize such as -append level.shp level0050.tmp.shp level0100.tmp.shp ...

polygonize_slices: raster_slice zvals
#	gdal_polygonize.py level0001.tmp.tif -f "ESRI Shapefile" level0001.tmp.shp level_0001 elev
#	gdal_polygonize.py level0050.tmp.tif -f "ESRI Shapefile" level0050.tmp.shp level_0050 elev
#	gdal_polygonize.py level0100.tmp.tif -f "ESRI Shapefile" level0100.tmp.shp level_0100 elev
#	gdal_polygonize.py level0200.tmp.tif -f "ESRI Shapefile" level0200.tmp.shp level_0200 elev
#	gdal_polygonize.py level0500.tmp.tif -f "ESRI Shapefile" level0500.tmp.shp level_0500 elev
#	gdal_polygonize.py level1000.tmp.tif -f "ESRI Shapefile" level1000.tmp.shp level_1000 elev
#	gdal_polygonize.py level2000.tmp.tif -f "ESRI Shapefile" level2000.tmp.shp level_2000 elev
#	gdal_polygonize.py level3000.tmp.tif -f "ESRI Shapefile" level3000.tmp.shp level_3000 elev
#	gdal_polygonize.py level4000.tmp.tif -f "ESRI Shapefile" level4000.tmp.shp level_4000 elev
#	gdal_polygonize.py level5000.tmp.tif -f "ESRI Shapefile" level5000.tmp.shp level_5000 elev
	Slices=( $$(cat ./tmp.txt) ); \
	for i in "$${Slices[@]}"; do \
		echo $$i ;\
		gdal_polygonize.py level$${i}.tmp.tif -f "ESRI Shapefile" level$${i}.tmp.shp level_$${i} elev ;\
	done;

raster_slice: crop zvals
#	gdal_calc.py -A crop.tmp.tif --outfile=level0001.tmp.tif --calc="1*(A>0)"       	--NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level0050.tmp.tif --calc="50*(A>50)"      	--NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level0100.tmp.tif --calc="100*(A>100)"     	--NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level0200.tmp.tif --calc="200*(A>200)"     	--NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level0500.tmp.tif --calc="500*(A>500)"     	--NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level1000.tmp.tif --calc="1000*(A>1000)"     --NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level2000.tmp.tif --calc="2000*(A>2000)"     --NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level3000.tmp.tif --calc="3000*(A>3000)"     --NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level4000.tmp.tif --calc="4000*(A>4000)"     --NoDataValue=0
#	gdal_calc.py -A crop.tmp.tif --outfile=level5000.tmp.tif --calc="5000*(A>5000)"     --NoDataValue=0
	Slices=( $$(cat ./tmp.txt) ); \
	for i in "$${Slices[@]}"; do \
		echo $$i ;\
		gdal_calc.py -A crop.tmp.tif \
			--outfile=level$$i.tmp.tif \
			--calc="$$i*(A>$$i)" \
			--NoDataValue=0;\
	done

#---- LOWEST-TOPEST
zvals: crop
	zMin=$$(gdalinfo crop.tmp.tif 2>&1 | sed -ne 's/.*z#actual_range=//p'| tr -d ' ' | cut -d "," -f 1 );\
	zMax=$$(gdalinfo crop.tmp.tif 2>&1 | sed -ne 's/.*z#actual_range=//p'| tr -d ' ' | cut -d "," -f 2);\
	echo $$zMin;\
	echo $$zMax;\
	python slice.py $$zMin $$zMax $(SLICES) > ./tmp.txt


# zMin=1107
# zMax=1187
# zSlices=6
# 1105,1110,1020,1030,1150,1170

#---- Crop, resize, regeolocalise
crop: unzip
	gdal_translate -projwin $(WEST) $(NORTH) $(EAST) $(SOUTH) ETOPO1_Ice_g_geotiff.tif crop.tmp.tif
	# ulx uly lrx lry (geodegrees)  // W N E S #todo: add name parameter
#	convert crop.origin.tif 	-resize $(WIDTH) crop.small.tif
#	gdal_translate -a_ullr $(WEST) $(NORTH) $(EAST) $(SOUTH) crop.small.tif crop.tmp.tif
#	gdalinfo -mm crop.tmp.tif

#---- Download
unzip: clean
	unzip -n ../data/ETOPO1/ETOPO1.zip '*.tif' #-n: no overwrite if exist;
	touch ETOPO1_Ice_g_geotiff.tif

# download: clean
#	curl -o ../data/ETOPO1/ETOPO1.zip \
#	-C - 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/georeferenced_tiff/ETOPO1_Ice_g_geotiff.zip'

clean:
	rm -f *.json
	rm -f *.dbf
	rm -f *.prj 
	rm -f *.shp
	rm -f *.shx
	rm -f *.tmp.*
#	rm -f *.tif
#	rm -f *.tiff
	rm -f *.html
	rm -f *.txt
	rm -f *.xml
#	rm -f *.makefile
