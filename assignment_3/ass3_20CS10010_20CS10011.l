%{
#include<stdio.h>
#include"head.h"
%}

keyword                     "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
whitespace                  [ \t\n]
letter                      [_a-zA-Z]
digit                       [0-9]
nonzerodigit                [1-9]

%%
{keyword}                   { return KEYWORD; }
{letter}({letter}|{digit})* { return IDENTIFIER; }
{nonzerodigit}{digit}*|[0]  { return CONST_INTEGER; }
{whitespace}                {}
%%

int yywrap() 
{
    return 1;
}