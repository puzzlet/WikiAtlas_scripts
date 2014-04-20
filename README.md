NOTE : THIS DOCUMENTATION IS UNDER INTENSIVE WRITING.

# WikimapsAtlas

This repository provides a mechanism to generate [TopoJSON](https://github.com/mbostock/topojson) and [SVG](http://en.wikipedia.org/wiki/SVG) maps for data visualization. It helps to dowload and process publicly available GIS resources into elegant, web and data friendly maps.

## Getting Started

### Dependencies

To generate the TopoJSON and GeoJSON files you need to install Node.js, either with the [official Node.js installer](http://nodejs.org/) or via [Homebrew](http://mxcl.github.io/homebrew/):

    brew install node
    
You also need GDAL and the corresponding python-gdal library installed. Links to the binaries are in the [GDAL Wiki](http://trac.osgeo.org/gdal/wiki/DownloadingGdalBinaries). On OS X you can also use Homebrew:

    brew install gdal

To get started, clone this repository and run `make`.

    git clone https://github.com/interactivethings/swiss-maps.git
    cd swiss-maps
    make

`make` or `make all` generates the following TopoJSON and GeoJSON files:

* List of file here

Final TopoJSON, SVG, and Bitmaps files are placed in the `output/topo/`, `output/svg/`, `output/png/` directories respectively.

## Projections and Dimensions

The coordinates of the output files is the ... reference system （LINK） with already [non projected coordinates]().

Per default, `make` will generate output files with the following characteristics:

* Projected, *cartesian* coordinates
* *Scaled* and *simplified* to a width of **1200** pixels

Setting is optimized for screen use. There is a good balance between file size (as small as possible) and quality for sc so we don't waste client performance with projecting spherical coordinates and have a good balance of geometry details and file size.

This means that if you use D3.js, you must disable the projection (see this [example of New York Block Groups](http://bl.ocks.org/mbostock/5996232))

```javascript
var path = d3.geo.path()
  .projection(null);
```

However, there are a few cases where you want something different.

### Changing Dimensions

If you're targeting another output dimensions, you can easily change them by setting the `WIDTH` and `HEIGHT` variables:

    make topo/ch-cantons.json WIDTH=2000 HEIGHT=1000

Per default, a 10px margin is included which can be changed by setting the `MARGIN` variable.

Make sure you run `make clean` if you've generated files before because `make` won't overwrite them if they already exist.

### Reproject to Spherical Coordinates

If you want to combine your JSON files with other libraries like [Leaflet](http://leafletjs.com/) or want to use another projection, you need to reproject the files to spherical coordinates first. You can do this by simply running

    make topo/ch-cantons.json REPROJECT=true

It's double important that you run `make clean` or `rm -rf shp` first if you've generated files in cartesian coordinates (the default mode) before. Otherwise TopoJSON will throw an error. The `WIDTH` and `HEIGHT` variables will be ignored.

## Metadata

Although the source files contain a slew of metadata such as population and area, data source, year of change etc., only the most basic properties are retained by default:

**Country**

* *id* ('CH')
* *name* ('Schweiz')

**Canton**

* *id* (the official canton number)
* *name*
* *abbr* (e.g. 'BE')

**District**

* *id* (the official district number)
* *name*

**Municipality**

* *id* (the official municipality or 'BFS' number)
* *name*

**Lake**

* *id* (the official lake or 'SEENR' number)
* *name*

**Contours**

* *id* (elevation)

This keeps files to a reasonable size and in most cases you will join other data to your map anyway. If you want to generate your files with more (or less) properties, you should modify the `Makefile`.

### Custom Properties

To include other properties, define the `PROPERTIES` variable:

    make topo/ch-cantons.json PROPERTIES=id=+KANTONSNUM,name=NAME,abbr=ABBR

For instructions on how to specify the properties, consult the [TopoJSON Command Line Reference](https://github.com/mbostock/topojson/wiki/Command-Line-Reference#properties).

## Historical Municipality Boundaries

Municipality boundaries from 2010 – 2013 are also available (thanks [Michael](https://github.com/l00mi)!). If you want boundaries from another year than 2013, define the `YEAR` variable:

    make topo/ch-municipalities.json YEAR=2010

## Other Modifications

For everything else you can modify the `Makefile` or run `ogr2ogr` and `topojson` directly. Mike Bostock's tutorial [Let's Make a Map](http://bost.ocks.org/mike/map/), the [TopoJSON wiki](https://github.com/mbostock/topojson/wiki), and [ogr2ogr documentation](http://www.gdal.org/ogr2ogr.html) should cover most of your needs.

## Examples

* [TopoJSON Cantons and Municipalities](http://bl.ocks.org/herrstucki/4327678) (stored in a single file!)
* [TopoJSON Cantons](http://bl.ocks.org/mbostock/4207744)
* [Swiss Topography](http://bl.ocks.org/herrstucki/6312708)

## Copyright and License

### Author

Jeremy Stucki, [Interactive Things](http://interactivethings.com)

### Data Source

GIS resources used andby default below.

It is licensed under the following terms:

> This agreement under public law in accordance with Article 12, paragraph 1b of the Swiss Federal Act of 5 October 2007 on Geoinformation (hereinafter referred to as Geoinformation Act) regulates access to, and use of, the federal geodata database.
>
> By accepting this agreement, the licensee acknowledges all contractual provisions – in particular the scope of the licence and the contractual obligations – as well the applicability of Swiss federal legislation governing geoinformation.
>
> By accepting this agreement, the licensee also acknowledges the sole right of the licensor to regulate access to, and use of, the federal geodata database. The attention of the licensee is herewith drawn to the fact that geodata may be protected under copyright law. The licensee thus acknowledges the exclusive right of the licensor to determine the use of the data.

[Full license agreement](http://www.toposhop.admin.ch/en/shop/terms/use/finished_products)

### License

[BSD](license/LICENSE) (where the data source's license does not apply).