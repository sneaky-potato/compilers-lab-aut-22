#include <stdio.h>
extern int yyparse();
extern int yylex();

int main() {
    printf("-------------------- Parsing --------------------\n\n");
    yyparse();
    return 0;
}
