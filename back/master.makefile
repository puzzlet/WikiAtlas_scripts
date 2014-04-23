#Default values
export ITEM=France
export WEST=-5.8
export NORTH=51.5
export EAST=10.0
export SOUTH=41.0

#TASKS
layers: parameters
	$(MAKE) -C 01_shaded_relief 	-f shadedrelief.makefile	#shadedreliefs
	$(MAKE) -C 09_d3 			-f d3.makefile
	# $(MAKE) -C 03_administrative 	-f administrative.makefile	#administrative
#	$(MAKE) -C 02_topography    	-f topography.makefile		#topography

parameters: downloads

downloads:
#	$(MAKE) -f downloads.makefile