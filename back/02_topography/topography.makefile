#make4b!
# topojsoning: 
levels.topo.json:  levels.geo.json
	topojson --id-property none -q 1e4 --simplify-proportion=0.5 -p name=elev -o levels.topo.json -- levels_geo.json
	# --simplify-proportion=0.05 

## shp2jsoning:
levels.geo.json: levels.shp
	ogr2ogr -f GeoJSON -where "elev < 10000" levels_geo.json levels.shp

## merge
levels.shp: levels_shp
	ogr2ogr levels.shp level0001.shp
	ogr2ogr -update -append levels.shp level0050.shp
	ogr2ogr -update -append levels.shp level0100.shp
	ogr2ogr -update -append levels.shp level0200.shp
	ogr2ogr -update -append levels.shp level0500.shp
	ogr2ogr -update -append levels.shp level1000.shp
	ogr2ogr -update -append levels.shp level2000.shp
	ogr2ogr -update -append levels.shp level3000.shp
	ogr2ogr -update -append levels.shp level4000.shp
	ogr2ogr -update -append levels.shp level5000.shp
	# maybe do factorize such as -append level.shp level0050.shp level0100.shp ...

# Polygonize slices:
levels_shp: levels_tif
	gdal_polygonize.py level0001.tif -f "ESRI Shapefile" level0001.shp level_0001 elev
	gdal_polygonize.py level0050.tif -f "ESRI Shapefile" level0050.shp level_0050 elev
	gdal_polygonize.py level0100.tif -f "ESRI Shapefile" level0100.shp level_0100 elev
	gdal_polygonize.py level0200.tif -f "ESRI Shapefile" level0200.shp level_0200 elev
	gdal_polygonize.py level0500.tif -f "ESRI Shapefile" level0500.shp level_0500 elev
	gdal_polygonize.py level1000.tif -f "ESRI Shapefile" level1000.shp level_1000 elev
	gdal_polygonize.py level2000.tif -f "ESRI Shapefile" level2000.shp level_2000 elev
	gdal_polygonize.py level3000.tif -f "ESRI Shapefile" level3000.shp level_3000 elev
	gdal_polygonize.py level4000.tif -f "ESRI Shapefile" level4000.shp level_4000 elev
	gdal_polygonize.py level5000.tif -f "ESRI Shapefile" level5000.shp level_5000 elev


# Raster slicing:
levels_tif: crop
	gdal_calc.py -A crop.tif --outfile=level0001.tif --calc="1*(A>0)"       	--NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level0050.tif --calc="50*(A>50)"      	--NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level0100.tif --calc="100*(A>100)"     	--NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level0200.tif --calc="200*(A>200)"     	--NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level0500.tif --calc="500*(A>500)"     	--NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level1000.tif --calc="1000*(A>1000)"     --NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level2000.tif --calc="2000*(A>2000)"     --NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level3000.tif --calc="3000*(A>3000)"     --NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level4000.tif --calc="4000*(A>4000)"     --NoDataValue=0
	gdal_calc.py -A crop.tif --outfile=level5000.tif --calc="5000*(A>5000)"     --NoDataValue=0

#---- Crop
crop: unzip
	gdal_translate -projwin $(WEST) $(NORTH) $(EAST) $(SOUTH) ETOPO1_Ice_g_geotiff.tif crop.tif
	# ulx uly lrx lry (geodegrees)  // W N E S #todo: add name parameter

#---- Download
unzip: download
	unzip -n ../data/ETOPO1/ETOPO1.zip '*.tif' #-n: no overwrite if exist;
	touch ETOPO1_Ice_g_geotiff.tif

download: clean
#	curl -o ../data/ETOPO1/ETOPO1.zip 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/georeferenced_tiff/ETOPO1_Ice_g_geotiff.zip'
	echo "download by topography: done!"

clean:
	rm `ls | grep -v '.makefile'`