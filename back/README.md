>: structural.	x: death end.	.: supersed intermadiate or trials.

TOPOJSON GENERATION:
	Make0a 		: crawler (SRTM4).
	Make0b 		: SRTM_V4.1 (250m) => merge => world => crop 	
>	Make1		: shp (L0, L1, places) => admin.topojson
>	Make2		: raster => 1 layer => topographic.topojson
>	Make3		: shp rivers & lakes => output cropt *.geojson(s)
?	Make5		: shaded relief ... (to create)
>	Make7		: merge all relevant json files (3 admins, 1 topography, 1 lakes, 1 rivers)

DATA INJECTION:
?	Make8 		: data jointure (to create)

FILES GENERATION:
>	NodeJS 		: embed D3js code => output SVG



.	MakeA		: creating France and it's L1 divisions.
x	MakeB		: ETOPO1 gdal_contours (death end)
.	MakeC		: topography gdal_polyginize into n layers (heavy)
.	MakeD		: .tif => barymetry topojson

W: western border, N: northern, E: Eastern, S: souther. Vx(%): vertical expansion. FOCUS: *_location_map.svg
# Frames:
		W		N 		E 		S 		Vx(%)	FOCUS
New_Zealand+	165.90	-33.85	179.09	-47.26
Indonesia 		93.00 	6.27 	143.29 	-11.17
India 	67.0   37.5  99.0 05.0 106	
France 	-5.8   41.0  10.0 51.5 140
Cambodia 102.1 14.7 107.8 10.3



Project:
* Location_map WP/Map style		-- Make2/data
* Relief_map WP/Map style    	-- Make4b
* Auto-focus                 	-- http://stackoverflow.com/questions/14492284/center-a-map-in-d3-given-a-geojson-object
** ......... +box margin 5% 	-- http://bl.ocks.org/mbostock/4707858
* Color scale linear&threshold 	-- http://bl.ocks.org/herrstucki/6312708
* Conditional border CSS	 	-- http://bl.ocks.org/mbostock/4136647
* Localisator/Minimap			-- 

* Automatic labels placement 	-- http://stackoverflow.com/questions/17425268/
** ................annealing 	--
* Data Driven Map (WikiData) 	-- http://4thmain.github.io/projects/hacks/wiki-atlas.html
* Cascadic mapping 				-- http://www.zevross.com/tech/d3/)
* Documentation 				-- https://github.com/interactivethings/swiss-maps


Academic :
* Mike Bostock, Line Simplification -- http://bost.ocks.org/mike/simplify/
* Mike Bostock, Command Line Reference -- https://github.com/mbostock/topojson/wiki/Command-Line-Reference
* Map Projection Distortions -- http://bl.ocks.org/mbostock/3709000
Colors:



TODO:
- Label placement
- Color ramp: 
- Localisator:
- map vertical-skretching:
- conditional border:
- Four colors theorem:

DONE:
- 5% margin: Project to Bounding Box (Mike Bostock)