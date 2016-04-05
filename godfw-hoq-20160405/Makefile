#
#  Synopsis:
#	Build png image files for ast and flow graphs from dot files
#  See:
#	http://www.graphviz.org
#
all: ast.png ast-flow.png opcode-idiom2.png ast-equal.png ast-push.png

clean:
	rm ast.png ast-flow.png opcode-idiom2.png ast-equal.png ast-push.png

ast.png: ast.dot
	dot -Tpng >ast.png <ast.dot
ast-equal.png: ast-equal.dot
	dot -Tpng >ast-equal.png <ast-equal.dot
ast-push.png: ast-push.dot
	dot -Tpng >ast-push.png <ast-push.dot
ast-flow.png: ast-flow.dot
	dot -Tpng >ast-flow.png <ast-flow.dot
opcode-idiom2.png: opcode-idiom2.dot
	dot -Tpng >opcode-idiom2.png <opcode-idiom2.dot
