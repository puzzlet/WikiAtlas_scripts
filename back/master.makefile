#---- RUN
# make -f master.makefile ITEM=India WEST=67.0 NORTH=37.5  EAST=99.0 SOUTH=05.0

#---- DEFAULT VALUES (customizable):
# Geo data
export ITEM=France
export WEST=-5.8
export NORTH=51.5
export EAST=10.0
export SOUTH=41.0
# script data
export DATE=2014.08.11
export VERSION=0.5



run:
#raster relief | works
	$(MAKE) -C 01_reliefs 			-f shadedrelief.makefile
#vector relief | works
	$(MAKE) -C 02_topography		-f topography.makefile
#admin | works
	$(MAKE) -C 03_administrative 	-f administrative.makefile
#svg creation | works
	$(MAKE) -C 09_d3 				-f d3.makefile
#files grouping | todo
#	$(MAKE) -C 07_merge 			-f merge.makefile

initialisation:
# install utilities | works(?)
#	$(MAKE) 						-f utilities.makefile	#install required softs
# data download | to do
#	$(MAKE) -C data			-f data.makefile	#data download
