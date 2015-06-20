all: mini_l.lex
	lex mini_l.lex
	gcc -o lexer lex.yy.c -lfl

