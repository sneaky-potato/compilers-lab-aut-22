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

        case INTEGER_CONSTANT:
            printf("<INTEGER_CONSTANT, %s>\n", yytext);
            break;
        
        case FLOATING_CONSTANT:
            printf("<FLOATING_CONSTANT, %s>\n", yytext);
            break;

        case CHARACTER_CONSTANT:
            printf("<CHARACTER_CONSTANT, %s>\n", yytext);
            break;

        case STRING_LITERAL:
            printf("<STRING_LITERAL, %s>\n", yytext);
            break;

        case PUNCTUATOR:
            printf("<PUNCTUATOR, %s>\n", yytext);
            break;

        case SINGLE_LINE_COMMENT:
            printf("<SINGLE_LINE_COMMENT, %s>\n", yytext);
            break;

        case MULTI_LINE_COMMENT:
            printf("<MULTI_LINE_COMMENT, %s>\n", yytext);
            break;

        default:
            printf("<UNEXPECTED TOKEN in line %d, %s>\n", yylineno, yytext);
            break;
        }

        next_token = yylex();
    } 
    return 0;
}