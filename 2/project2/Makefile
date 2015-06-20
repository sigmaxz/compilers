#Make file
OBJS = bison.o lex.o main.o

CC = g++
CFLAGS = -g -Wall -ansi -pedantic

all: $(OBJS)
	make mini_l

mini_l: $(OBJS)
	$(CC)  $(CFLAGS) $(OBJS) -o parser -lfl

lex.o: lex.c
	$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c: mini_l.lex
	flex mini_l.lex
	cp lex.yy.c lex.c

bison.o: bison.c
	$(CC) $(CFLAGS) -c bison.c -o bison.o 

bison.c:  mini_l.y
	bison -d -v mini_l.y
	cp mini_l.tab.c bison.c
	cmp -s mini_l.tab.h tok.h || cp mini_l.tab.h tok.h

main.o: main.cc
	$(CC) $(FLAGS) -c main.cc -o main.o


clean:
	rm -f *.o *~ lex.c lex.yy.c bison.c tok.h mini_l.tab.c mini_l.tab.h mini_l.output mini_l y.* parser 
