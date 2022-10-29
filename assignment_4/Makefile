# Makefile variables
RM = rm -f
MAIN = ass4_20CS10010_20CS10011
CC = gcc

$(MAIN)_output.txt: a.out $(MAIN)_test.c
	./a.out < $(MAIN)_test.c > $(MAIN)_output.txt

a.out: lex.yy.o $(MAIN).tab.o $(MAIN).o
	$(CC) lex.yy.o $(MAIN).tab.o $(MAIN).o

$(MAIN).tab.c: $(MAIN).y
	bison -dty $(MAIN).y --report=solved

lex.yy.c: $(MAIN).l $(MAIN).tab.h 
	flex $(MAIN).l

$(MAIN).tab.h: $(MAIN).y
	bison -d $(MAIN).y --report=solved

$(MAIN).o:
	$(CC) -c $(MAIN).c

lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c

$(MAIN).tab.o: $(MAIN).tab.c
	$(CC) -c $(MAIN).tab.c

clean:
	$(RM) a.out lex.yy.* *.o *.tab.* *.output