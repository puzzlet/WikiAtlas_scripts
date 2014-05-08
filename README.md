NOTE : THIS DOCUMENTATION IS UNDER INTENSIVE WRITING. 
SECTIONS TITLES WITH `(...%)` EXPRESS THE SECTION'S DEGREE OF COMPLETION.

# WikimapsAtlas
## Project (100%)
**Problem:** Making elegant andgeographically accurate encyclopedic maps for Wikipedia have been for years an highly manual process.  The base maps requiring complex digital geographic software (GIS) skills. This results in a poor supply of maps that is unable to meet the demand of accurate and updated maps for various projects and languages.

**Solution:** The WikimapsAtlas project is a push to automate the creation of Wikipedia SVG base maps, in respect of the solid and widely used [Wikipedia:Map\_Workshops cartographic styles guidelines][WP:MAP/Guidelines] together with the latest and most accurate open geographic data.

**Wikimedia Fundation & IEG:** The design and development of this project is supported through an [Individual Engagement Grant](http://meta.wikimedia.org/wiki/Grants:IEG/Wikimaps_Atlas) from the Wikimedia Foundation.

## Repository (100%)

This repository provides a mechanism to generate [TopoJSON](https://github.com/mbostock/topojson) and [SVG](http://en.wikipedia.org/wiki/SVG) base maps for data visualization.

**Process improvement:** Wikimaps Atlas tremendously ease the dowload and processing of publicly available huge GIS resources into elegant, web friendly and data binding friendly SVG maps.

**Style (Wikipedia):** Generated SVGs follow the solid and popular [Wikipedia:Map Workshop cartographic guidelines][WP:MAP/Guidelines] . 

**Data biding:** Generated SVGs are all build according to a strict standard structure. XML polygons have clear `id`, allowing easy data biding.

**Kinds & layers:** We mirror solid best practices refined by Wikipedia cartographers over the past 8 years. Also, we currently provide the following outputs as stand alone files/layers:
* Administrative
 * {ITEM}_administrative_location_map.svg
 * {ITEM}_administrative_location_map-en.svg
* Topography
 * {ITEM}_topography_location_map.svg
* Waters
 * {ITEM}_rivers_location_map.topojson
* Shaded relief:
 * {ITEM}_shaded_relief_map-transparent.png
 * {ITEM}_shaded_relief_map-white.png
 * {ITEM}_shaded_relief_map-wikimaps.png (wp colored relief)

**Customization:** 
Provided layers can be combined, deleted, edited by graphists. For more, relevant `*.makifile` and color palettes can also be edited.

## Metadata (50%)

Wikimaps Atlas jobs is to take the power of GIS to common webdevs, graphists, scientists, journalists and online readers. 
While GIS sources are excessively heavy, precises for coordinates and dozens of metadata (population, areas, various names, years, ...), Wikimaps Atlas simplifies geocoordinates to fit the screens and filters metadata to fit common uses. Metadata kept by default (with an example of value) are:

**Country (L0)**
* *id* ('IT')
* *name* ('ITALY')

**State (L1)**
* *id* (the official id number)
* *name*

**District (L2)**
* *id* (the official id number)
* *name*

**Lake & waters bodies**
* *id* {WHAT}
* *name*

**Rivers**
* *id* {WHAT}
* *name*

**Topography**
* *id* (elevation)

This keeps files to a reasonable size and in most cases you will join other data to your map anyway. If you want to generate your files with more (or less) properties, you should modify the `Makefile`.

### Further Properties (0%)

To keep other properties from the original administrative shapefile, define the `PROPERTIES` variable:

    make topo/ch-cantons.json PROPERTIES=id=+KANTONSNUM,name=NAME,abbr=ABBR

For instructions on how to specify the properties, consult the [TopoJSON Command Line Reference](https://github.com/mbostock/topojson/wiki/Command-Line-Reference#properties).

## Getting Started

### Install (0%)
You need `git` and `make` :

    sudo apt-get install git make # basics

**On Linux Ubuntu**, run the 2 commands below to clone this repository and install needed dependencies.

```
git clone git@github.com:WikimapsAtlas/WikiAtlas_scripts.git #get code
make -f ./wikiAtlas_scripts/back/utilities.makefile #installation
```

The most critical elements we did was to are to install 
* **`gdal`** ([binaries](http://trac.osgeo.org/gdal/wiki/DownloadingGdalBinaries))and the corresponding python-gdal library
* **`Nodejs`-`NPM`** ([official installer](http://nodejs.org/)) then `npm` modules `topojson.js`, `jsdom` 

**On OS X** you can also use [Homebrew](http://mxcl.github.io/homebrew/):
    brew install node
    brew install gdal

Report install issues or ideas [here](https://github.com/WikimapsAtlas/WikiAtlas_scripts/issues).

Final TopoJSON, SVG, and Bitmaps files are placed in the `output/topo/`, `output/svg/`, `output/png/` directories respectively.

### Default Projections and Dimensions (50%)

The coordinates of the output files is the WGS 84 lat/long reference system （LINK）, currently with [non projected coordinates]().

Per default, `make` will generate output topojson files with the following characteristics:

* Non-projected, *cartesian* coordinates
* *Simplified* and *scaled* to a width of **1200px** by default

**Setting** are optimized for screen use. There is a good balance between file size (as light as possible) and quality on screen (no pixelization) so we don't waste neither server nor client performance.

**Reprojection** of spherical coordinates is NOT done, the topojson files we provide are still in WGS 84 lat/long.

If you use our topojson files, you must fire the reprojection of your choice at rendering. 
```javascript
var path = d3.geo.path()
  .projection(d3.geo.albersUsa());
```
See [Reproject shp/topojson : ways to reproject my data and comparative manual?](http://stackoverflow.com/questions/23086493/)

## Run Wikimaps Atlas
Wikimaps Atlas is usually run using the `master.makefile`, which pass variables to sub-module makefiles. Modules can be ran independently as well.


### Master.makefile (100%)
**Action:** When run, the `master.makefile` runs other layer-specialized sub-makefiles. These sub-makefiles download the GIS sources, process them, output topoJSON file(s) which `nodejs`, `jsdom`, and `D3js` code can convert into stand alone SVGs.

**Command:**

    make -f master.makefile ITEM=France WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0

Adapt these parameters to your needs.

Dimension of the bitmap/raster outputs can be changed using `WIDTH=`

**Command:**

    make -f master.makefile ITEM=France WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 WIDTH=1800
	
**Parameters:** minimal parameters are the `ITEM` name, used as title, and `WNES` geocoordinates of your target area.

* `ITEM=`...  : name of the target/central geographic item, according to Natural Earth spelling.
* `WEST=`...  : Western most longitude value of the frame to map. Accept integer between 90.0⁰ & -90.0⁰.
* `NORTH=`... : Northern most latitude value ————. ————.
* `EAST=`...  : Eastern most longitude value ————. ————.
* `SOUTH=`... : Southern most latitude value ————. ————.
* `WIDTH=`... (in px, default: 1280) : width of the final SVG and associated bitmaps (tif, png). The EIGHT is calculated from `WNES` values and the `WIDTH`.

## Modules  (70%)
Modules can be run independently.

### Administrative  (100%)
**Action:** When run, this `administrative.makefile` download administrative L0 (countries), L1 (subunits) GIS sources, process them (unzip, crop, filter), to output an elegant composite stack of your target L1 district upon L0 backgrounds, as topojson and WP styled SVG files.

**Direct command:**

    make -f administrative.makefile WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 ITEM=France SELECTOR_L1="admin IN ('France')"

**Parameters:**
* `SELECTOR_L1=`... (SQL selector, default value `"admin IN ('France')"`) selects and keeps L1 administrative areas respecting SQL query.
* `SELECTOR_PLACES=`... (SQL selector, default value `ADM0NAME = '$(ITEM)' AND POP_MAX > '$(POP_MIN)'`) selects and keeps places administrative areas respecting SQL query.
* `SELECTOR_POP_MIN=`... (integer > 0, default value `200000`) selects and keeps places (towns and cities) with populations **above (>)** value. Easier than `SELECTOR_PLACES=`.

### Topography (70%)
**Action:** When run, this `topography.makefile` download the raster GIS DEM sources, process them (unzip, crop, slice, polygonize, merge), to output an elegant topographic stack of polygons, topojson and WP styled SVG files.

**Direct command:**

    make -f topography.makefile WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 ITEM=France

**Parameters:**
{TO COMPLETE}

### Shaded relief (100%)
**Action:** When run, this `shadedrelief.makefile` download the raster GIS DEM sources, process them (unzip, crop, shaded relief, resize, colorize), to output several elegant shaded relief png/jpg (current) or topojson/svg (planned). Needs WNES.

**Direct command:**

    make -f shadedrelief.makefile ITEM=France WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 

**Output:** 

 * 2 hillshades:
  * hillshade_grey (GIS tif)
  * hillshade_trans (png)
 * 1 color-relief (wikipedia style):
  * color+hillshade_000pc (GIS tif)
 * 3 mix (for comparison):
  * color+hillshade_050pc (jpg)
  * color+hillshade_100pc (jpg)
  * color+hillshade_multiply (jpg)

For similar data and similar px dimensions, file sizes are `.tif`:5.0MB, `.png`:1.6MB, `.jpg`:239KB. Also, whenever possible and relevant, we use the lighter format.
 
**Parameters:**
Derivated from `man gdal` and `man convert`.

* `Z=` (zFactor, integer >0, default 5): vertical exaggeration used to pre-multiply the elevations
* `AZ=` (azimuth, integer [0-359], default: 315): azimuth of the light, in degrees. 0 if it comes from the top of the raster, 90 from the east, ... The default value, 315, should rarely be changed as it is the value generally used to generate shaded maps.
* `ALT=` (altitude of light, in degrees, integer [0-90], default 60): altitude of the light, in degrees. 90 if the light comes from above the DEM, 0 if it is raking light.
* `FUZZ=` (fuzzy selection, integer [0-100], default 7): colors within this distance are considered equal
* `SHADOW=` (integer [0-100]) opacity of the hillshade upon color-relief.
* `WIDTH=`... (in px, default: 1280) : width of the bitmaps (tif, png). The EIGHT is conserved from `WNES` ratio and the `WIDTH`.

**Note:** 
 * if the input GIS raster is in feet, then `s` scale should be edited. See `man gdal`.
 * the download task will automatically download the ETOPO1 (342MB) archive file, which may be time consuming.

## Other Modifications (100%)

For everything else you can edit the `Makefile` and the relevant commands.
See also:

* Mike Bostock's tutorial [Let's Make a Map](http://bost.ocks.org/mike/map/)
* the [ogr2ogr documentation](http://www.gdal.org/ogr2ogr.html)
* the [TopoJSON wiki](https://github.com/mbostock/topojson/wiki)
* the [ImageMagick/Command-Line Options](http://www.imagemagick.org/script/command-line-options.php)

## Examples (0%)

* {HAND OF EXAMPLE HERE}


### Tips

* **Convert topoJSON into ESRI Shapefile:** Use [GDAL/OGR's]() `ogr2ogr` tool to convert the GeoJSON output. [QGIS](http://qgis.org), a free desktop GIS application, do it as well.

        ogr2ogr -f 'Esri Shapefile' -lco=UTF8 output.shp input.geo.json


## Credits (90%)

### Authors (100%)

* [Hugo Lopez](http://twitter.com/hugo_lz) —— project design, prototyping, refining. Technologies: gdal, ogr2ogr, imagemagick, topojson, d3js, nodejs, jsdom.
* [Arun Ganesh](http://twitter.com/planemad) —— project improvement, scaling up, automation. Technologies: gdal, ogr2ogr, topojson, d3js, QuantumGIS, PostgreSQL.

### Assistances (100%)

* [Edouard Lopez](http://twitter.com/edouard_lopez) —— software ingenering suppervision. Technologies: make, bash, git, js.

### Supports (100%)

Individuals:
* Wikipedians : our most massive thanks to all our colleagues on wikipedia. 

Organisations:
* Wikimedia Fundation > [Individual Engagement Grant](http://meta.wikimedia.org/wiki/Grants:IEG/Wikimaps_Atlas)
* Wikimedia-CH
* Wikimedia-FR

### Data Source (100%)

GIS resources used by default :

* NaturalEarth —— for administrative divisions.
 * Admin L0
 * Admin L1
* ETOPO1  ——  for topography.
* SRTM ——  for topography.

Other GIS resources could be processed. For more GIS resources and detailed descriptions, see [Wikipedia:Map Workshop/GIS resources](https://en.wikipedia.org/wiki/Wikipedia:Graphic_Lab/Resources/Gis_sources_and_palettes)


##Licence (100%)

Copyright 2014 LOPEZ Hugo, GANESH Arun, LOPEZ Edouard, offered under the [MIT License](./LICENSE) (where the data source's license does not apply).




----

# TO REMOVE (?)

Make sure you run `make clean` if you've generated files before because `make` won't overwrite them if they already exist.


### Reproject to Spherical Coordinates (0%)

If you want to combine your JSON files with other libraries like [Leaflet](http://leafletjs.com) or want to use another projection, you need to reproject the files to spherical coordinates first. You can do this by simply running

    make topo/ch-cantons.json REPROJECT=true

It's double important that you run `make clean` or `rm -rf shp` first if you've generated files in cartesian coordinates (the default mode) before. Otherwise TopoJSON will throw an error. The `WIDTH` and `HEIGHT` variables will be ignored.

[WP:MAP/Guidelines]: https://en.wikipedia.org/wiki/Wikipedia:WikiProject_Maps/Conventions