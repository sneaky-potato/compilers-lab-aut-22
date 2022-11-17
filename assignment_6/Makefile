# Makefile variables
RM := rm -rf
MAIN := ass6_20CS10010_20CS10011
EXEC := ./tinyC
IN_DIR := ./input
OUT_DIR := ./output
TESTFILES := $(wildcard $(IN_DIR)/*.c) # [./input/test1.c, ./input/test2.c, ...]
_INPUTS := $(notdir $(TESTFILES)) # [test1.c, test2.c, ...]
CC := g++

# Colors for printing and logging information on console
PRIMARY:=\033[0;35m
LOG:=\033[0;36m
SUCCESS:=\033[0;32m
INFO:=\033[0;33m
NC:=\033[0m

# Functions for printing and logging information on console
define log
  	@echo -e "${PRIMARY}${BRAND} ${LOG}$1${NC} ${INFO}$2${NC}"
endef

define success
  	@echo -e "${PRIMARY}${BRAND} ${SUCCESS}$1${NC}"
endef

# Explicit newline function
define newline 


endef

# Makefile recipes
$(EXEC): y.tab.o lex.yy.o $(MAIN)_translator.o $(MAIN)_target_translator.o
	$(CC) -g $(MAIN)_translator.o $(MAIN)_target_translator.o lex.yy.o y.tab.o -lfl -o $(EXEC)
	$(call success,::Make process successful::\nThe binary generated is $(EXEC)\nUse command make test for running test files)

lex.yy.c: $(MAIN).l
	flex $(MAIN).l

y.tab.c: $(MAIN).y
	yacc -dtv $(MAIN).y -Wno-empty-rule -Wno-yacc -Wno-conflicts-rr

y.tab.h: $(MAIN).y
	yacc -dtv $(MAIN).y -Wno-empty-rule -Wno-yacc -Wno-conflicts-rr

$(MAIN)_target_translator.o: $(MAIN)_target_translator.cxx
	$(CC) -g -c -no-pie $(MAIN)_target_translator.cxx

$(MAIN)_translator.o: $(MAIN)_translator.cxx
	$(CC) -g -c -no-pie $(MAIN)_translator.cxx

lex.yy.o: lex.yy.c
	$(CC) -g -c -no-pie lex.yy.c

y.tab.o:    y.tab.c
	$(CC) -g -no-pie -DYYDEBUG -c y.tab.c

lib$(MAIN).a: $(MAIN).o
	ar -rcs lib$(MAIN).a $(MAIN).o

$(MAIN).o: $(MAIN).c myl.h
	gcc -g -no-pie -Wall -c $(MAIN).c

test: lib$(MAIN).a

	$(call log, ::Creating output directory [if it doesn't exists]::)
	mkdir -p $(OUT_DIR)

	$(call log, ::Initiating testing...::)

	$(foreach in_file, $(_INPUTS), $(call log, ::Testing file::, $(in_file)) $(newline) $(EXEC) < $(IN_DIR)/$(in_file) > $(OUT_DIR)/$(in_file:.c=quads.out) $(newline) mv $(OUT_DIR).s $(OUT_DIR)/$(in_file:.c=.s) $(newline))

	$(call success, Test outputs written to $(OUT_DIR))

clean:
	$(RM) \
	lex.yy.c y.tab.h y.tab.c y.output \
	*.o *.s *.a *.out *.gch \
	$(EXEC)

# Run the following command to generate executable from output test assembly file
# gcc -g -Wall -c  output/ass6_20CS10010_20CS10011_test1.s -no-pie -o ass6_20CS10010_20CS10011_test1.o
# gcc -g -no-pie ass6_20CS10010_20CS10011_test1.o -o ./output/test1 -L. -lass6_20CS10010_20CS10011
