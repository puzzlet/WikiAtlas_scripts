data: NE ETOPO1

# ---------- TOPOGRAPHIC 1km from NOAA -----------------------------------#
ETOPO1: clean
	mkdir -p ../data/ ../data/ETOPO1
	curl \
		-L -C - 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/georeferenced_tiff/ETOPO1_Ice_g_geotiff.zip' \
		-o ../data/ETOPO1/ETOPO1.zip
	### Downloaded 100%: ETOPO1, topography 1km raster. ###

# ---------- ADMINISTRATIVE from NATURAL EARTH ---------------------------#
NE: clean NE_0 NE_1 NE_2 NE_3 NE_4 NE_5 NE_6
	### Downloaded 100%: NaturalEarthData.com's, admin shapefiles. ###
NE_0:
	mkdir -p ./NE/ 
NE_1:
	curl  \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip' \
		-o ./NE/countries.zip
NE_2:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip' \
		-o ./NE/subunits.zip 
NE_3:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip' \
		-o ./NE/places.zip
NE_4:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_disputed_areas.zip' \
		-o ./NE/disputed.zip
NE_5:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_rivers_lake_centerlines.zip' \
		-o ./NE/rivers.zip
NE_6:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes.zip' \
		-o ./NE/lakes.zip
clean:
#	rm -f ./NE/*.zip
#	rm -f ./NE/*.dbf
#	rm -f ./NE/*.prj 
#	rm -f ./NE/*.shp
#	rm -f ./NE/*.shx
#	rm -f ./ETOPO1/*.zip
#	rm -f ./ETOPO1/*.tif
#	rm -f ./ETOPO1/*.tiff