#include<stdio.h>
#include"head.h"

extern int yylex();
extern char* yytext;
extern int yylineno;
extern int yylen;
extern FILE* yyin;
extern FILE* yyout;

int main() {
    int next_token;
    yyin = fopen("ass3_20CS10010_20CS10011_test.c", "r");

    next_token = yylex();
    while(next_token) {
        switch (next_token)
        {
        case KEYWORD:
            printf("<KEYWORD, %s>\n", yytext);
            break;
        
        case IDENTIFIER:
            printf("<IDENTIFIER, %s>\n", yytext);
            break;

        case CONST_INTEGER:
            printf("<INTEGER_CONSTANT, %s>\n", yytext);
            break;

        default:
            printf("<UNEXPECTED TOKEN in line %d, %s>\n", yylineno, yytext);
            break;
        }

        next_token = yylex();
    } 
    return 0;
}