// Run me with: 
// $ COLOR=#66AAFF, node jsdom.node.js > out.svg   #passing var COLOR
//
var jsdom = require('jsdom');
jsdom.env(
  "<html><body></body></html>",        // CREATE DOM HOOK:
  [ 'http://d3js.org/d3.v3.min.js',    // JS DEPENDENCIES online ...
  'js/d3.v3.min.js' ],                 // ... & offline
// D3JS CODE * * * * * * * * * * * * * * * * * * * * * * * *
  function (err, window) {

    var WEST  = process.env.WEST,     // <<============== IMPOTANT !!
        NORTH = process.env.NORTH,
        EAST  = process.env.EAST,
        SOUTH = process.env.SOUTH,
        ITEM  = process.env.ITEM;
    var DATE  = process.env.DATE,
        VERSION = process.env.VERSION,/*
         = process.env.,
         = process.env. */
         COMMAND = "nd";
    var svg = window.d3.select("body")
        .append("svg")
        .attr("width", 100).attr("height", 100);

    svg.append("metadata")
        .attr("class", "wikiatlas2014")
        .attr("humans", "Hugo Lopez; Arun Ganesh (WikiAtlas Team).")
        .attr("license", "CC-by-sa")
        .attr("title", ITEM);
    svg.append("scriptdata")
        .attr("name", "WikiAtlas script")
        .attr("date", DATE)
        .attr("script_version", VERSION);
    svg.append("geodata")
        .attr("WEST", WEST)
        .attr("NORTH", NORTH)
        .attr("EAST", EAST)
        .attr("SOUTH", SOUTH);
    svg.append("rect")
        .attr("id", "rectangle1")
        .attr("x", 10)
        .attr("y", 10)
        .attr("width", 80)
        .attr("height", 80)
        .style("fill", "purple");
    // END svg design

  //PRINTING OUT SELECTION
    console.log(window.d3.select("body").html());
 }
// END (D3JS) * * * * * * * * * * * * * * * * * * * * * * * *
);