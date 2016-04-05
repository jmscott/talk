#
#  Synopsis:
#	Build png image files for ast and flow graphs from dot files
#  See:
#	http://www.graphviz.org
#
all: ast.png ast-flow.png opcode-idiom2.png

clean:
	rm ast.png ast-flow.png opcode-idiom2.dot

ast.png: ast.dot
	dot -Tpng >ast.png <ast.dot
ast-flow.png: ast-flow.dot
	dot -Tpng >ast-flow.png <ast-flow.dot
opcode-idiom2.png: opcode-idiom2.dot
	dot -Tpng >opcode-idiom2.png <opcode-idiom2.dot
