### FILES FILTERS & 2JSON
lakes&rivers.json: crop_lakes.shp crop_rivers.shp
	ogr2ogr -f GeoJSON lakes_geo.json crop_lakes.shp
	ogr2ogr -f GeoJSON rivers_geo.json crop_rivers.shp
#---
crop_lakes.shp: ne_10m_lakes_europe.shp
	ogr2ogr -clipsrc 13.43 55.3 94.55 2.54 crop_lakes.shp ne_10m_lakes_europe.shp
crop_rivers.shp: ne_10m_rivers_lake_centerlines_scale_rank.shp
	ogr2ogr -clipsrc 13.43 55.3 94.55 2.54 crop_rivers.shp ne_10m_rivers_lake_centerlines_scale_rank.shp
	# WNES (or WSEN)
#---
### FILES UNZIP:
ne_10m_lakes_europe.shp: lakes.zip
	unzip lakes.zip
	touch ne_10m_lakes_europe.shp
ne_10m_rivers_lake_centerlines_scale_rank.shp: rivers.zip
	unzip rivers.zip
	touch ne_10m_rivers_lake_centerlines_scale_rank.shp

#---
### FILES DOWNLOAD:
lakes.zip:
	curl -L -o lakes.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_lakes_europe.zip'
rivers.zip:
	curl -L -o rivers.zip 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_rivers_lake_centerlines_scale_rank.zip'


clean:
	rm `ls | grep -v 'zip' | grep -v 'Makefile'`
