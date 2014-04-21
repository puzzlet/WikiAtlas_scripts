NOTE : THIS DOCUMENTATION IS UNDER INTENSIVE WRITING.

# WikimapsAtlas
## Introduction
**Problem:** Making encyclopedic maps for Wikipedia have been for years an highly manual process resulting in a poor supply of maps that is unable to meet the demand of accurate and updated maps for various projects and languages.

**Solution:** The WikimapsAtlas project is a push to automate the creation of Wikipedia SVG base maps, in respect of the solid and widely used [Wikipedia:Map\_Workshops cartographic styles guidelines](https://en.wikipedia.org/wiki/Wikipedia:WikiProject_Maps/Conventions) together with the latest and most accurate open geographic data.

**Wikimedia Fundation & IEG:** The design and development of this project is supported through an [Individual Engagement Grant](http://meta.wikimedia.org/wiki/Grants:IEG/Wikimaps_Atlas) from the Wikimedia Foundation.

## Repository

This repository provides a mechanism to generate [TopoJSON](https://github.com/mbostock/topojson) and [SVG](http://en.wikipedia.org/wiki/SVG) base maps for data visualization.

**Process improvement:** _Wikimaps Atlas_ tremendously ease the dowload and processing of publicly available GIS resources into elegant (Wikipedia maps guidelines complient), web friendly and data binding friendly maps.

**Style:** Generated SVGs follow the Wikipedia:Map Workshop cartographic guidelines.

**Data biding:** Generated SVGs are all build according to a standard structure. XML polygons have clear `id`, allowing easy data biding.

**Kinds & layers:** We mirror solid best practices refined by Wikipedia cartographers. Also, we provide the following outputs:
* Administrative
 * {ITEM}_administrative_location_map.svg
 * {ITEM}_administrative_location_map-en.svg
* Topography
 * {ITEM}_topography_location_map.svg
* Shaded relief:
 * {ITEM}_shaded_relief_map-transparent.png
 * {ITEM}_shaded_relief_map-white.png
 * {ITEM}_shaded_relief_map-color_ramp.png

## Getting Started

### Dependencies

To generate the TopoJSON and GeoJSON files you need to install Node.js, either with the [official Node.js installer](http://nodejs.org/) or via [Homebrew](http://mxcl.github.io/homebrew/):

    brew install node
    
You also need GDAL and the corresponding python-gdal library installed. Links to the binaries are in the [GDAL Wiki](http://trac.osgeo.org/gdal/wiki/DownloadingGdalBinaries). On OS X you can also use Homebrew:

    brew install gdal

To get started, clone this repository and run `make`.

    git clone https://github.com/...
    cd ...
    make

Final TopoJSON, SVG, and Bitmaps files are placed in the `output/topo/`, `output/svg/`, `output/png/` directories respectively.

## Default Projections and Dimensions

The coordinates of the output files is the WGS 84 lat/long reference system （LINK）, currently with [non projected coordinates]().

Per default, `make` will generate output topojson files with the following characteristics:

* Non-projected, *cartesian* coordinates
* *Simplified* and *scaled* to a width of **1200px** by default

**Setting** are optimized for screen use. There is a good balance between file size (as light as possible) and quality on screen (no pixelization) so we don't waste neither server nor client performance.

**Reprojection** of spherical coordinates is NOT done, the topojson files we provide are still in WGS 84 lat/long.

If you use our topojson files, you must enable the reprojection of your choice at rendering. 
```javascript
var path = d3.geo.path()
  .projection(d3.geo.albersUsa());
```
See [Reproject shp/topojson : ways to reproject my data and comparative manual?](http://stackoverflow.com/questions/23086493/)

## WikimapsAtlas parameters

### Minimal

To map our demo area :

    make -f master.makefile     # mapping default demo area.

To map an area of your choice, do something such :

    make -f master.makefile ITEM=France WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0
	
**Parameters:** minimal parameters are the `ITEM` name, used and title, and `WNES` geocoordinates of your target area.

* `ITEM=`...  : name of the target/central geographic item, according to Natural Earth spelling.
* `WEST=`...  : Western most longitude value of the frame to map. Accept integer between 90.0⁰ & -90.0⁰.
* `NORTH=`... : Northern most latitude value ————. ————.
* `EAST=`...  : Eastern most longitude value ————. ————.
* `SOUTH=`... : Southern most latitude value ————. ————.

### Changing Dimensions

Dimension of the output can be changed :

    make -f master.makefile WIDTH=1200     # mapping default demo area.

**Parameters:**

* `WIDTH=`... (in px, default: 1200) : width of the final SVG and associated bitmaps (tif, png). The EIGHT is calculated from WNES values and the WIDTH.

### Reproject to Spherical Coordinates

If you want to combine your JSON files with other libraries like [Leaflet](http://leafletjs.com/) or want to use another projection, you need to reproject the files to spherical coordinates first. You can do this by simply running

    make topo/ch-cantons.json REPROJECT=true

It's double important that you run `make clean` or `rm -rf shp` first if you've generated files in cartesian coordinates (the default mode) before. Otherwise TopoJSON will throw an error. The `WIDTH` and `HEIGHT` variables will be ignored.

## Metadata

_Wikimaps Atlas_ jobs is to take the power of GIS to common webdevs, graphists, scientists, journalists and online readers. 
While GIS sources are excessively precises for coordinates and dozens of metadata (population, areas, various names, years, ...), _Wikimaps Atlas_ simplifies geocoordinates to fit the screens and filters metadata to fit common uses. Metadata kept by default are:

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

### Custom Properties

To include other properties, define the `PROPERTIES` variable:

    make topo/ch-cantons.json PROPERTIES=id=+KANTONSNUM,name=NAME,abbr=ABBR

For instructions on how to specify the properties, consult the [TopoJSON Command Line Reference](https://github.com/mbostock/topojson/wiki/Command-Line-Reference#properties).

## Shaded relief
Run as isolated script:

    make -f shadedrelief.makefile ITEM=France WEST=-5.8 NORTH=51.5 EAST=10.0 SOUTH=41.0 
 
**Parameters:**
Derivated from `man gdal` and `man convert`.

* `Z=` (zFactor, integer >0, default 5): vertical exaggeration used to pre-multiply the elevations
* `AZ=` (azimuth, integer [0-359], default: 315): azimuth of the light, in degrees. 0 if it comes from the top of the raster, 90 from the east, ... The default value, 315, should rarely be changed as it is the value generally used to generate shaded maps.
* `ALT=` (altitude of light, in degrees, integer [0-90], default 60): altitude of the light, in degrees. 90 if the light comes from above the DEM, 0 if it is raking light.
* `FUZZ=` (fuzzy selection, integer [0-100], default 7): colors within this distance are considered equal

Note: if the input GIS raster is in feet, then `s` scale should be edited. See `man gdal`.


## Other Modifications

For everything else you can edit the `Makefile` and the relevant commands.
See also:

* Mike Bostock's tutorial [Let's Make a Map](http://bost.ocks.org/mike/map/)
* the [ogr2ogr documentation](http://www.gdal.org/ogr2ogr.html)
* the [TopoJSON wiki](https://github.com/mbostock/topojson/wiki)
* the [ImageMagick/Command-Line Options](http://www.imagemagick.org/script/command-line-options.php)

## Examples

* {HAND OF EXAMPLE HERE}

## Copyright and License

### Authors

* Hugo Lopez —— project design, prototyping, refining. gdal, ogr2ogr, topojson, D3js
* Arun Ganesh —— project improvement, scaling up, automation. gdal, ogr2ogr, topojson, D3js, PostgreSQL.

### Assistances

* Edouard Lopez —— Make, Bash, Git, JS, software ingenering suppervision. 

### Supports

Individuals:

* Wikipedians : our most massive thanks to all our colleagues on wikipedia. 

Organisations:

* Wikimedia Fundation > [Individual Engagement Grant](http://meta.wikimedia.org/wiki/Grants:IEG/Wikimaps_Atlas)
* Wikimedia-CH
* Wikimedia-FR

### Data Source

GIS resources used by default :

* NaturalEarth —— for administrative divisions.
 * Admin L0
 * Admin L1
* SRTM ——  for topography.

Other GIS resources could be processed. For more GIS resources and detailed descriptions, see [Wikipedia:Map Workshop/GIS resources](https://en.wikipedia.org/wiki/Wikipedia:Graphic_Lab/Resources/Gis_sources_and_palettes)

### License

[BSD](license/LICENSE) (where the data source's license does not apply).






Make sure you run `make clean` if you've generated files before because `make` won't overwrite them if they already exist.