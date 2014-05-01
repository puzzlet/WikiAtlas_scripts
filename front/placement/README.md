# Automatic Label Placement

This example is an extension of Mike Bostock’s tutorial [Lets Make a Map](http://bost.ocks.org/mike/map/) that implements automatic label placement using the force layout and multiple foci. The centroid of each feature will define a foci of the force. This foci will attract the label that correspond to that feature (and ignore the others). The labels will repel themselves to avoid overlapping.

## References

* [Lets Make a Map](http://bost.ocks.org/mike/map/)
* [Multi-Foci Force Layout](http://bl.ocks.org/mbostock/1021953)