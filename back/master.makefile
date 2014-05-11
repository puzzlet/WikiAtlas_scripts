#Default values
export ITEM=France
export WEST=-5.8
export NORTH=51.5
export EAST=10.0
export SOUTH=41.0

#TASKS
layers: parameters
#works
	$(MAKE) -C 01_reliefs 			-f shadedrelief.makefile	#shadedreliefs
#TO_TEST
	$(MAKE) -C 02_topography		-f topography.makefile		#topography
#works
	$(MAKE) -C 03_administrative 	-f administrative.makefile	#administrative
#works
	$(MAKE) -C 09_d3 				-f d3.makefile
#	$(MAKE) -C 07_merge 			-f merge.makefile
parameters: downloads

downloads: setting
#not needed anymore
#	$(MAKE) -f downloads.makefile
setting:
#works
#	$(MAKE) -f utilities.makefile

