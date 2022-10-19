%{
    #include <stdio.h>
    #include <stdlib.h>
    #include"ass4_20CS10010_20CS10011.tab.h"
    extern void yyerror(const char *);

%}

%x MULTI_LINE_FLAG
%x SINGLE_LINE_FLAG

IDENTIFIER              [A-Za-z_][A-Za-z0-9_]*
ESCAPE_SEQUENCE         "\\\'"|"\\\""|"\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"  

DIGIT                   [0-9]
DIGIT_SEQUENCE          [0-9]+
NON_ZERO_DIGIT          [1-9]
INTEGER_CONSTANT        {NON_ZERO_DIGIT}{DIGIT}*|"0"

FRACTIONAL_CONSTANT     ({DIGIT_SEQUENCE})?"."{DIGIT_SEQUENCE}|{DIGIT_SEQUENCE}"."
EXPONENT_PART           [eE]([+-])?{DIGIT_SEQUENCE}
FLOATING_CONSTANT       {FRACTIONAL_CONSTANT}({EXPONENT_PART})?|{DIGIT_SEQUENCE}{EXPONENT_PART}
ENUMERATION_CONSTANT    {IDENTIFIER}

C_CHAR                  [^\'\n\\']|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE         {C_CHAR}+
CHARACTER_CONSTANT      \'{C_CHAR_SEQUENCE}\'

S_CHAR                  [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE         {S_CHAR}+
STRING_LITERAL          \"({S_CHAR_SEQUENCE}?)\"
WHITESPACE              [ \t\r]

%%

"auto"                      {return AUTO;}
"break"                     {return BREAK;}
"case"                      {return CASE;}
"char"                      {return CHAR;}
"const"                     {return CONST;}
"continue"                  {return CONTINUE;}
"default"                   {return DEFAULT;}
"do"                        {return DO;}
"double"                    {return DOUBLE;}
"else"                      {return ELSE;}
"enum"                      {return ENUM;}
"extern"                    {return EXTERN;}
"float"                     {return FLOAT;}
"for"                       {return FOR;}
"goto"                      {return GOTO;}
"if"                        {return IF;}
"inline"                    {return INLINE;}
"int"                       {return INT;}
"long"                      {return LONG;}
"register"                  {return REGISTER;}
"restrict"                  {return RESTRICT;}
"return"                    {return RETURN;}
"short"                     {return SHORT;}
"signed"                    {return SIGNED;}
"sizeof"                    {return SIZEOF;}
"static"                    {return STATIC;}
"struct"                    {return STRUCT;}
"switch"                    {return SWITCH;}
"typedef"                   {return TYPEDEF;}
"union"                     {return UNION;}
"unsigned"                  {return UNSIGNED;}
"void"                      {return VOID;}
"volatile"                  {return VOLATILE;}
"while"                     {return WHILE;}
"_Bool"                     {return BOOL;}
"_Complex"                  {return COMPLEX;}
"_Imaginary"                {return IMAGINARY;}


{IDENTIFIER}                {return IDENTIFIER;}
{INTEGER_CONSTANT}          {return INTEGER_CONSTANT;}
{FLOATING_CONSTANT}         {return FLOATING_CONSTANT;}
{CHARACTER_CONSTANT}        {return CHARACTER_CONSTANT;}
{STRING_LITERAL}            {return STRING_LITERAL;}

"="                         {return EQ;}
":"                         {return COLON;}
";"                         {return SEMI_COLON;}
"?"                         {return QUESTION_MARK;}
"++"                        {return INC_OP;}
"->"                        {return PTR_OP;}
"<<"                        {return LEFT_OP;}
">>"                        {return RIGHT_OP;}
"<"                         {return LESS_THAN;}
">"                         {return GREATER_THAN;}
"<="                        {return LTE_OP;}
">="                        {return GTE_OP;}
"..."                       {return ELLIPSIS;}
"*="                        {return MUL_ASSIGN;}
"/="                        {return DIV_ASSIGN;}
"%="                        {return MOD_ASSIGN;}
"+="                        {return ADD_ASSIGN;}
"-="                        {return SUB_ASSIGN;}
"<<="                       {return LEFT_ASSIGN;}
"--"                        {return DEC_OP;}
"=="                        {return EQ_OP;}
"&&"                        {return AND_OP;}
"||"                        {return OR_OP;}
">>="                       {return RIGHT_ASSIGN;}
"!="                        {return NE_OP;}
"&="                        {return AND_ASSIGN;}
"|="                        {return OR_ASSIGN;}
"^="                        {return XOR_ASSIGN;}
"("                         {return PARENTHESIS_OPEN;}
")"                         {return PARENTHESIS_CLOSE;}
"{"                         {return CURLY_BRACE_OPEN;}
"}"                         {return CURLY_BRACE_CLOSE;}
"["                         {return SQR_BRACE_OPEN;}
"]"                         {return SQR_BRACE_CLOSE;}
"."                         {return DOT;}
"&"                         {return BITWISEAND;}
"|"                         {return BITWISEOR;}
"^"                         {return BITWISEXOR;}
"*"                         {return STAR;}
"+"                         {return PLUS;}
"-"                         {return MINUS;}
"~"                         {return NOT;}
"!"                         {return EXCLAMATION;}
"/"                         {return DIVIDE;}
"%"                         {return PERCENTAGE;}
","                         {return COMMA;}
"#"                         {return HASH;}

"/*"                        {BEGIN(MULTI_LINE_FLAG);}
<MULTI_LINE_FLAG>"*/"       {BEGIN(INITIAL);}
<MULTI_LINE_FLAG>.          { }
<MULTI_LINE_FLAG>"\n"       { yylineno++; printf("\n-------- Parsing Line No. %d --------\n", yylineno); }

"//"                        {BEGIN(SINGLE_LINE_FLAG);}
<SINGLE_LINE_FLAG>"\n"      {BEGIN(INITIAL); yylineno++;printf("\n-------- Parsing Line No. %d --------\n", yylineno); }
<SINGLE_LINE_FLAG>.         { }
\n                          { yylineno++; printf("\n-------- Parsing Line No. %d --------\n", yylineno); }
{WHITESPACE}                { }
.                           { printf("ERROR [Line %d] : Invalid Token %s\n",yylineno,yytext); return INVALID_TOKEN;}

%%

int yywrap() {
    return 1;
}
