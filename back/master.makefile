#Default values
export ITEM=France
export WEST=-5.8
export NORTH=51.5
export EAST=10.0
export SOUTH=41.0

#TASKS
layers: parameters
#works	$(MAKE) -C 01_shaded_relief 	-f shadedrelief.makefile	#shadedreliefs
#TO_TEST	$(MAKE) -C 02_topography		-f topography.makefile		#topography
#works	$(MAKE) -C 03_administrative 	-f administrative.makefile	#administrative
#works	$(MAKE) -C 09_d3 				-f d3.makefile

parameters: downloads

downloads:
#	$(MAKE) -f downloads.makefile