# Makefile variables
CC = gcc
LEX = lex
RM = rm -f
TARGET_LEX = ass3_20CS10010_20CS10011.l
LEX_C = lex.yy.c
MAIN = ass3_20CS10010_20CS10011.c

EXEC = a.out

# Make rule for a.out (depends on lex.yy.c and main c file)
$(EXEC): $(LEX_C) $(MAIN)
	$(CC) $(LEX_C) $(MAIN)

# Make rule for lex.yy.c (depends on target lex specification file)
$(LEX_C) : $(TARGET_LEX)
	$(LEX) $(TARGET_LEX)

# Make rule for cleaning and removing files after compiling
clean:
	$(RM) $(EXEC) $(LEX_C)