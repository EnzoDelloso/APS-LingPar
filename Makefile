all: rocalang

rocalang: rocalang.tab.c lex.yy.c main.c
	bison -d rocalang.y
	flex rocalang.l
	gcc -Wall -g rocalang.tab.c lex.yy.c main.c -o rocalang -lfl

rocalang.tab.c rocalang.tab.h: rocalang.y
	bison -d rocalang.y

lex.yy.c: rocalang.l
	flex rocalang.l

clean:
	rm -f rocalang lex.yy.c rocalang.tab.c rocalang.tab.h output.asm
