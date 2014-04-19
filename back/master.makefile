#Default values
export WEST=-5.8
export NORTH=51.5
export EAST=10.0
export SOUTH=41.0
export ITEM=France

#TASKS
layers: parameters
	$(MAKE) -C 1_shaded_relief 	-f shadedrelief.makefile	#shadedreliefs
	$(MAKE) -C 9_d3 			-f d3.makefile
	# $(MAKE) -C 1_administrative 	-f administrative.makefile	#administrative
#	$(MAKE) -C 2_topography    	-f topography.makefile		#topography

parameters: downloads

downloads:
#	$(MAKE) -f downloads.makefile