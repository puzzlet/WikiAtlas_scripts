output: clean
	node jsdom.node.js > item.svg
clean:
	rm -f `ls | grep -v '.makefile'| grep -v 'js'| grep -v 'modules'`