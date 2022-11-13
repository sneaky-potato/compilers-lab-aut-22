RM := rm -rf
MAIN := ass6_20CS10010_20CS10011
EXEC := ./a.out
IN_DIR := ./input
OUT_DIR := ./output

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
	g++ -g $(MAIN)_translator.o $(MAIN)_target_translator.o lex.yy.o y.tab.o -lfl -o $(EXEC)
	$(call success,::Make process successful::\nThe binary generated is $(EXEC)\nUse command make test for running test files)

lex.yy.c: $(MAIN).l
	flex $(MAIN).l

y.tab.c: $(MAIN).y
	yacc -dtv $(MAIN).y -Wno-empty-rule -Wno-yacc -Wno-conflicts-rr

y.tab.h: $(MAIN).y
	yacc -dtv $(MAIN).y -Wno-empty-rule -Wno-yacc -Wno-conflicts-rr

$(MAIN)_target_translator.o: $(MAIN)_target_translator.cxx
	g++ -g -c -no-pie $(MAIN)_target_translator.cxx

$(MAIN)_translator.o: $(MAIN)_translator.cxx
	g++ -g -c -no-pie $(MAIN)_translator.cxx

lex.yy.o: lex.yy.c
	g++ -g -c -no-pie lex.yy.c

y.tab.o:    y.tab.c
	g++ -g -no-pie -DYYDEBUG -c y.tab.c

lib$(MAIN).a: $(MAIN).o
	ar -rcs lib$(MAIN).a $(MAIN).o

$(MAIN).o: $(MAIN).c myl.h
	gcc -g -no-pie -Wall -c $(MAIN).c

clean:
	$(RM) \
	test* \
	lex.yy.c y.tab.h y.$(OUT_DIR) y.tab.c \
	*.o *.s *.a *.out *.gch \
	$(OUT_DIR)/* \
	$(OUT_DIR)-bin/* \
	$(EXEC)

test: lib$(MAIN).a

	$(call log, ::Creating $(OUT_DIR) directories [if don't exists]::)
	@mkdir -p $(OUT_DIR)

	$(call log, ::Running Test Case 1::)
	$(EXEC) < $(IN_DIR)/$(MAIN)_test1.c > $(OUT_DIR)/$(MAIN)_quad1.out
	mv $(OUT_DIR).s $(OUT_DIR)/$(MAIN)_test1.s

	$(call log, ::Running Test Case 2::)
	$(EXEC) < $(IN_DIR)/$(MAIN)_test2.c > $(OUT_DIR)/$(MAIN)_quad2.out
	mv $(OUT_DIR).s $(OUT_DIR)/$(MAIN)_test2.s

	$(call log, ::Running Test Case 3::)
	$(EXEC) < $(IN_DIR)/$(MAIN)_test3.c > $(OUT_DIR)/$(MAIN)_quad3.out
	mv $(OUT_DIR).s $(OUT_DIR)/$(MAIN)_test3.s

	$(call log, ::Running Test Case 4::)
	$(EXEC) < $(IN_DIR)/$(MAIN)_test4.c > $(OUT_DIR)/$(MAIN)_quad4.out
	mv $(OUT_DIR).s $(OUT_DIR)/$(MAIN)_test4.s

	$(call log, ::Running Test Case 5::)
	$(EXEC) < $(IN_DIR)/$(MAIN)_test5.c > $(OUT_DIR)/$(MAIN)_quad5.out
	mv $(OUT_DIR).s $(OUT_DIR)/$(MAIN)_test5.s
	
	$(call success,::Tests successful::\nGenerated .s files are in $(OUT_DIR))


# Run the following command to generate executable from output test assembly file
# gcc -g -Wall -c  output/ass6_20CS10010_20CS10011_test1.s -no-pie -o ass6_20CS10010_20CS10011_test1.o
# gcc -g -no-pie ass6_20CS10010_20CS10011_test1.o -o ./output/test1 -L. -lass6_20CS10010_20CS10011
