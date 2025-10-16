all: rocalang

rocalang: rocalang.tab.c lex.yy.c
	$(CC) -o rocalang rocalang.tab.c lex.yy.c -lfl

rocalang.tab.c rocalang.tab.h: rocalang.y
	bison -d rocalang.y

lex.yy.c: rocalang.l rocalang.tab.h
	flex rocalang.l

clean:
	rm -f rocalang lex.yy.c rocalang.tab.c rocalang.tab.h output.asm
