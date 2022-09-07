%{
    #include"head.h"
%}

%x MULTI_LINE_FLAG
%x SINGLE_LINE_FLAG

KEYWORD                 "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
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
CHARACTER_CONSTANT      \'{C_CHAR_SEQUENCE}\''

S_CHAR                  [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE         {S_CHAR}+
STRING_LITERAL          \"({S_CHAR_SEQUENCE})?\"

PUNCTUATOR              "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|">>"|"<<"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
WHITESPACE              [ \t\n]

%%

{KEYWORD}                   {return KEYWORD;}
{IDENTIFIER}                {return IDENTIFIER;}
{INTEGER_CONSTANT}          {return INTEGER_CONSTANT;}
{FLOATING_CONSTANT}         {return FLOATING_CONSTANT;}
{CHARACTER_CONSTANT}        {return CHARACTER_CONSTANT;}
{STRING_LITERAL}            {return STRING_LITERAL;}
{PUNCTUATOR}                {return PUNCTUATOR;}

"/*"                        {BEGIN(MULTI_LINE_FLAG);}
<MULTI_LINE_FLAG>"*/"       {BEGIN(INITIAL); return MULTI_LINE_COMMENT;}
<MULTI_LINE_FLAG>.          { }
<MULTI_LINE_FLAG>"\n"       { }

"//"                        {BEGIN(SINGLE_LINE_FLAG);}
<SINGLE_LINE_FLAG>"\n"      {BEGIN(INITIAL);return SINGLE_LINE_COMMENT;}
<SINGLE_LINE_FLAG>.         { }

{WHITESPACE}                { }
.                           { return INVALID_TOKEN;}

%%

int yywrap() {
    return 1;
}
