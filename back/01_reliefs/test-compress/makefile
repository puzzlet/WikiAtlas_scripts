#Color tiff depending on color_relief.txt file. Format: elevation R G B.
all: clean
	# $man gdaldem : color-relief
	# 	The elevation value can be any floating point value, or the nv keyword 
	# 	for nodata value.. The elevation can also be expressed as a percentage : 
	# 	0% being the minimum value found in the raster, 100% the maximum value.
	gdaldem color-relief crop.tiff color_relief-wikimaps.txt color_relief-wp.tiff #GIS file
	#resizing
	convert color_relief-wp.tiff -resize $(WIDTH) color_relief-wp-sized.tiff #5MB
	convert color_relief-wp.tiff -resize $(WIDTH) color_relief-wp-sized.png  #1.6MB
	convert color_relief-wp.tiff -resize $(WIDTH) color_relief-wp-sized.jpg  #239KB
	 #tiff:5.0MB, png:1.6MB, jpg:239KB 