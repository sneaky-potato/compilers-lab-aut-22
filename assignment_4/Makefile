# Makefile variables
CC = g++
LEX = lex
RM = rm -f
MAIN = asgn4_20CS10011
LEX_C = lex.yy.c

EXEC = a.out

ass4_20CS10011_output.txt: a.out $(MAIN)_test.c
	./a.out < $(MAIN)_test.c > $(MAIN)_output.txt

a.out: lex.yy.o $(MAIN).tab.o $(MAIN).o
	g++ lex.yy.o $(MAIN).tab.o $(MAIN).o

$(MAIN).tab.c: $(MAIN).y
	bison -dty $(MAIN).y --report=solved

lex.yy.c: $(MAIN).l $(MAIN).tab.h 
	flex $(MAIN).l

$(MAIN).tab.h: $(MAIN).y
	bison -d $(MAIN).y --report=solved

$(MAIN).o:
	g++ -c $(MAIN).c

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

$(MAIN).tab.o: $(MAIN).tab.c
	g++ -c $(MAIN).tab.c

clean:
	$(RM) a.out lex.yy.* *.o