#
#  Synopsis:
#	Build png image files for ast and flow graphs from dot files
#  See:
#	http://www.graphviz.org
#
all: ast.png ast-flow.png

clean:
	rm ast.png ast-flow.png

ast.png: ast.dot
	dot -Tpng >ast.png <ast.dot
ast-flow.png: ast-flow.dot
	dot -Tpng >ast-flow.png <ast-flow.dot
