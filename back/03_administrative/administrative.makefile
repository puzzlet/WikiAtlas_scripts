#DEFAULT VALUES (customizable):
# inherit ITEM, WEST, NORTH, EAST, SOUTH from master.makefile.
SELECTOR_POP_MIN=200000
SELECTOR_L1=admin IN ('$(ITEM)')
SELECTOR_PLACES=ADM0NAME = '$(ITEM)' AND POP_MAX > '$(SELECTOR_POP_MIN)'
QUANTIZATION=1e4
# STILL TO VERIFY:
SHP_ATT2ID=NAME
SHP_ATT2id=name
TOPOJSON_LOC=../node_modules/topojson/bin/topojson

#MAKEFILE
topojson: geojson_filters
	$(TOPOJSON_LOC) \
		--id-property none \
		-p name=NAME \
		-p name=name \
		-p inL1=region \
		-q $(QUANTIZATION) \
		--filter=small \
		-o $(ITEM).administrative.topo.json \
		-- admin_0=countries.geo.json admin_1=subunits.geo.json places=places.geo.json

geojson_filters: crop unzip
	ogr2ogr -f GeoJSON \
		countries.geo.json \
		crop_L0.shp
	ogr2ogr -f GeoJSON -where "$(SELECTOR_L1)" \
		subunits.geo.json \
		ne_10m_admin_1_states_provinces.shp
	ogr2ogr -f GeoJSON -where "$(SELECTOR_PLACES)" \
		places.geo.json \
		ne_10m_populated_places.shp
#or "iso_a2 = 'AT' AND SCALERANK < 20" , see also sr_adm0_a3
#ADM0NAME = 'Egypt' OR ADM0NAME = 'Iran' OR SOV0NAME = 'Saudi Arabia' OR SOV0NAME = 'Lebanon' OR SOV0NAME = 'Turkey' OR SOV0NAME = 'Syria' OR SOV0NAME = 'Iraq' OR ISO_A2 = 'noFR'

crop: unzip touch
	ogr2ogr -clipsrc $(WEST) $(NORTH) $(EAST) $(SOUTH) crop_L0.shp ne_10m_admin_0_countries.shp
	# WNES coordinates        

#unzip -n : no overwrite
touch: unzip
	touch ne_10m_admin_0_countries.shp
	touch ne_10m_admin_1_states_provinces.shp
	touch ne_10m_populated_places.shp
unzip: downloads 
	unzip -n ../data/NE/countries.zip 
	unzip -n ../data/NE/subunits.zip
	unzip -n ../data/NE/places.zip

downloads: clean d0 d1 d2 d3
	# downloads done.

d0:
	mkdir -p ../data/NE/
d1:
	curl  \
		-o ../data/NE/countries.zip \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip'
	## http://www.nacis.org/naturalearth/10m/cultural/NE_10m_admin_0_map_subunits.zip
d2:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip' \
		-o ../data/NE/subunits.zip 
d3:
	curl \
		-L -C - 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip' \
		-o ../data/NE/places.zip	

clean:
	rm -f *.json
	rm -f *.dbf
	rm -f *.prj 
	rm -f *.shp
	rm -f *.shx
	rm -f *.html
	rm -f *.txt
