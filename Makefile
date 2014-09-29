CC = g++
CFLAGS = -g -Wall -std=c++0x
INC=-. ./ast
INC_PARAMS=$(foreach d, $(INC), -I$d)

OBJs =   parser.tab.o lex.yy.o  Expression.o SymbolTable.o frontend.o AstRead.o AstNil.o AstList.o AstUnOp.o AstBranch.o AstExpressionList.o AstIdentifierList.o AstBinOp.o  AstIdentifier.o AstInt.o AstLambda.o AstLet.o AstString.o 

default: lexer

lexer: ${OBJs}
	${CC} ${CFLAGS} ${INC_PARAMS} ${OBJs} -o lexer -lfl

lex.yy.c: lexer.l parser-defs.h
	flex -i lexer.l

parser.tab.c: parser.y parser-defs.h
	bison -dv parser.y



frontend.o:	frontend.cpp 
	${CC} ${CFLAGS} ${INC_PARAMS} -c frontend.cpp 
	
SymbolTable.o:	SymbolTable.cpp
	${CC} ${CFLAGS} ${INC_PARAMS} -c SymbolTable.cpp 

Expression.o:	ast/*.h ast/*.cpp  ast/AstString.h
	${CC} ${CFLAGS} ${INC_PARAMS} -c ast/*.cpp


clean:
	rm -f lexer lexer.yy.c *.o parser.tab.[ch] parser.output

depend:
	makedepend -I. *.c# DO NOT DELETE
