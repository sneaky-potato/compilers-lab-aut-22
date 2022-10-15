#include <stdio.h>
extern int yyparse();
extern int yylex();

//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 3                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

int main() {
    printf("-------------------- Parsing --------------------\n\n");
    yyparse();
    return 0;
}
