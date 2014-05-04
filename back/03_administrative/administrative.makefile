#DEFAULT VALUES (customizable):
# inherit ITEM, WEST, NORTH, EAST, SOUTH from master.makefile.
SELECTOR_POP_MIN=200000
SELECTOR_L1=admin IN ('$(ITEM)')
SELECTOR_PLACES=ADM0NAME = '$(ITEM)' AND POP_MAX > '$(SELECTOR_POP_MIN)'

#MAKEFILE
geojson_filters: crop unzip
	ogr2ogr -f GeoJSON countries.geo.json crop_L0.shp
	ogr2ogr -f GeoJSON -where "$(SELECTOR_L1)" subunits.geo.json ne_10m_admin_1_states_provinces_shp.shp
	ogr2ogr -f GeoJSON -where "$(SELECTOR_PLACES)" places.geo.json ne_10m_populated_places.shp
#or "iso_a2 = 'AT' AND SCALERANK < 20" , see also sr_adm0_a3
#ADM0NAME = 'Egypt' OR ADM0NAME = 'Iran' OR SOV0NAME = 'Saudi Arabia' OR SOV0NAME = 'Lebanon' OR SOV0NAME = 'Turkey' OR SOV0NAME = 'Syria' OR SOV0NAME = 'Iraq' OR ISO_A2 = 'noFR'

crop: unzip
	ogr2ogr -clipsrc $(WEST) $(NORTH) $(EAST) $(SOUTH) crop_L0.shp ne_10m_admin_0_sovereignty.shp
	# WNES coordinates        

#unzip -n : no overwrite
unzip: downloads 
	unzip -n ../data/NE/countries.zip 
	unzip -n ../data/NE/subunits.zip
	unzip -n ../data/NE/places.zip
	touch ne_10m_admin_0_sovereignty.shp
	touch ne_10m_admin_1_states_provinces_shp.shp
	touch ne_10m_populated_places.shp

downloads: clean
#	curl -L -o ../data/NE/countries.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_sovereignty.zip'
#	## http://www.nacis.org/naturalearth/10m/cultural/ne_10m_admin_0_map_subunits.zip
	echo "download L0: done! [fake]"
#	curl -L -o ../data/NE/subunits.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces_shp.zip'
	echo "download L1: done! [fake]"
#	curl -L -o ../data/NE/places.zip 'http://www.nacis.org/naturalearth/10m/cultural/ne_10m_populated_places.zip'	
	echo "download PLACES: done! [fake]"

clean:
	rm -f *.json
	rm -f *.dbf
	rm -f *.prj 
	rm -f *.shp
	rm -f *.shx
	rm -f *.html
	rm -f *.txt











