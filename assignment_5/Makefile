# Makefile variables
RM := rm -f
MAIN := ass5_20CS10010_20CS10011
EXEC := ./a.out
IN_DIR := ./input
OUT_DIR := ./output
TESTFILES := $(wildcard $(IN_DIR)/*.c)
_INPUTS := $(notdir $(TESTFILES))

PRIMARY:=\033[0;35m
LOG:=\033[0;36m
SUCCESS:=\033[0;32m
INFO:=\033[0;33m
NC:=\033[0m

define log
  	@echo -e "${PRIMARY}${BRAND} ${LOG}$1${NC} ${INFO}$2${NC}"
endef

define newline 


endef

define success
  	@echo -e "${PRIMARY}${BRAND} ${SUCCESS}$1${NC}"
endef

a.out: lex.yy.o $(MAIN).tab.o $(MAIN)_translator.o
	g++ lex.yy.o $(MAIN).tab.o $(MAIN)_translator.o -lfl

$(MAIN)_translator.o: $(MAIN)_translator.h $(MAIN)_translator.cxx
	g++ -c $(MAIN)_translator.h
	g++ -c $(MAIN)_translator.cxx

lex.yy.o: lex.yy.c
	g++ -c lex.yy.c

$(MAIN).tab.o: $(MAIN).tab.c
	g++ -c $(MAIN).tab.c

lex.yy.c: $(MAIN).l $(MAIN).tab.h $(MAIN)_translator.h
	flex $(MAIN).l

$(MAIN).tab.c: $(MAIN).y
	bison -dtv $(MAIN).y

$(MAIN).tab.h: $(MAIN).y
	bison -dtv $(MAIN).y

test: 
	$(call log, ::Creating output directory [if it doesn't exists]::)
	mkdir -p $(OUT_DIR)

	$(call log, ::Initiating testing...::)

	$(foreach in_file, $(_INPUTS), $(call log, ::Testing file::, $(in_file)) $(newline) $(EXEC) < $(IN_DIR)/$(in_file) > $(OUT_DIR)/$(in_file:.c=.txt) $(newline))

	$(call success, Test outputs written to $(OUT_DIR))

clean:
	$(RM) a.out lex.yy.* *.o *.tab.* *.output