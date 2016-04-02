#
#  Synopsis:
#	Build png image files for ast and flow graphs from dot files
#  See:
#	http://www.graphviz.org
#
all: ast.png

clean:
	rm ast.png

ast.png: ast.dot
	dot -Tpng >ast.png <ast.dot
