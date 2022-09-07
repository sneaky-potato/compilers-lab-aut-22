#include<stdio.h>
#include"head.h"

//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 3                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

// extern lex variables and functions
extern int yylex();
extern char* yytext;
extern int yylineno;
extern int yylen;
extern FILE* yyin;
extern FILE* yyout;

int main() {
    int next_token;
    // redirect input from the test file
    yyin = fopen("ass3_20CS10010_20CS10011_test.c", "r");

    // get next token usign yylex() function
    next_token = yylex();

    // while next_token != <<EOF>>
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
            printf("<SINGLE_LINE_COMMENT in line %d>\n", yylineno-1);
            break;

        case MULTI_LINE_COMMENT:
            printf("<MULTI_LINE_COMMENT in line %d>\n", yylineno-1);
            break;

        // if token matches no valid lex specification 
        default:
            printf("<UNEXPECTED TOKEN in line %d, %s>\n", yylineno-1, yytext);
            break;
        }

        // get next token from character stream
        next_token = yylex();
    } 
    return 0;
}