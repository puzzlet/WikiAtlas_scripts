all: countries.json subunits.json places.json
    # fake step so "countries.json:" is not looked as the final step (not needing subunits nor places)

### TO JSON WITH FILTERS
countries.json: crop_L0.shp
	ogr2ogr -f GeoJSON countries.geo.json crop_L0.shp
subunits.json: ne_10m_admin_1_states_provinces_shp
	ogr2ogr -f GeoJSON -where "admin IN ('$(ITEM)')" subunits.geo.json ne_10m_admin_1_states_provinces_shp.shp
places.json: ne_10m_populated_places.shp	
	ogr2ogr -f GeoJSON -where "ADM0NAME = '$(ITEM)' AND POP_MAX > '200000'" places.geo.json ne_10m_populated_places.shp
#or "iso_a2 = 'AT' AND SCALERANK < 20" , see also sr_adm0_a3
#ADM0NAME = 'Egypt' OR ADM0NAME = 'Iran' OR SOV0NAME = 'Saudi Arabia' OR SOV0NAME = 'Lebanon' OR SOV0NAME = 'Turkey' OR SOV0NAME = 'Syria' OR SOV0NAME = 'Iraq' OR ISO_A2 = 'noFR'


### CROP
crop_L0.shp: ne_10m_admin_0_sovereignty.shp
	ogr2ogr -clipsrc $(WEST) $(NORTH) $(EAST) $(SOUTH) crop_L0.shp ne_10m_admin_0_sovereignty.shp
	# WNES coordinates        

### FILES UNZIP:
ne_10m_admin_0_sovereignty.shp: countries
	unzip ../data/NE/countries.zip
	touch ne_10m_admin_0_sovereignty.shp
ne_10m_admin_1_states_provinces_shp: subunits
	unzip ../data/NE/subunits.zip
	touch ne_10m_admin_1_states_provinces_shp.shp
ne_10m_populated_places.shp: places
	unzip ../data/NE/places.zip
	touch ne_10m_populated_places.shp

### FILES DOWNLOAD:
countries:
#	curl -L -o ../data/NE/countries.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_sovereignty.zip'
#	## http://www.nacis.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip
	echo "download L0: done! [fake]"
subunits:
#	curl -L -o ../data/NE/subunits.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces_shp.zip'
	echo "download L1: done! [fake]"
places:
#	curl -L -o ../data/NE/places.zip 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_populated_places.zip'	
	echo "download PLACES: done! [fake]"

clean:
	rm `ls | grep -v '.makefile'`














