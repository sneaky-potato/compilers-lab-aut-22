%{
	#include <stdio.h>
    #include <stdlib.h>
	#include <string.h>
	#include "ass5_20CS10010_20CS10011_translator.h"
	#include "ass5_20CS10010_20CS10011.tab.h"
	extern "C" int yylex();
    extern YYSTYPE yylval;
    extern int line;
    int line = 1;   
%}

%option noyywrap

/* Regular Expressions*/
DIGIT           [0-9]
NON_ZERO        [1-9]
LETTER          [a-zA-Z]


DIGIT_SEQ       {DIGIT}{DIGIT}*

ESCAPE_SEQ      "\\b"|"\\v"|"\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\f"|"\\n"|"\\r"|"\\t"
C_CHAR          [^\'\\\n]|{ESCAPE_SEQ}
S_CHAR          [^\"\\\n]|{ESCAPE_SEQ}

CHAR_SEQ        {C_CHAR}{C_CHAR}*
STRING_SEQ      {S_CHAR}{S_CHAR}*

IDENTIFIER      ({LETTER}|"_")({LETTER}|{DIGIT}|"_")*

FRAC            {DIGIT_SEQ}\.|\.{DIGIT_SEQ}|{DIGIT_SEQ}\.{DIGIT_SEQ}
FLOAT_CONST     ({FRAC}|{DIGIT_SEQ})([Ee]([-+]{DIGIT_SEQ}|{DIGIT_SEQ}))|{FRAC}|"0"*\."0"*

INT_CONST       {NON_ZERO}{DIGIT}*|"0"+
CHAR_CONST      \'{CHAR_SEQ}\'

STRING          \"{STRING_SEQ}\"|\"\"
COMMENT_LINE    "//".*
COMMENT_MULTI   "/*"([^*]|\*+[^/*])*\**(\*"/")? 

WS              [ \t]
NEWLINE         [\n]

%%

{COMMENT_LINE}          { /*printf("single line comment(ignored)\n");*/ }
{COMMENT_MULTI}         { /*printf("multi line comment(ignored)\n");*/  }

"int"                   { return INT;      }
"short"                 { return SHORT;    }
"long"                  { return LONG;     }
"char"                  { return CHAR;     }
"void"                  { return VOID;     }
"float"                 { return FLOAT;    }


"if"                    { return IF;       }
"else"                  { return ELSE;     }
"do"                    { return DO;       }
"while"                 { return WHILE;    }
"for"                   { return FOR;      }


"case"                  { return CASE;     }
"goto"                  { return GOTO;     }


"break"                 { return BREAK;    }
"const"                 { return CONST;    }
"union"                 { return UNION;    }

"switch"                { return SWITCH;   }
"static"                { return STATIC;   }
"struct"                { return STRUCT;   }
"extern"                { return EXTERN;   }
"sizeof"                { return SIZEOF;   }
"inline"                { return INLINE;   }
"double"                { return DOUBLE;   }
"return"                { return RETURN;   }
"typedef"               { return TYPEDEF;  }
"default"               { return DEFAULT;  }
"volatile"              { return VOLATILE; }
"restrict"              { return RESTRICT; }
"continue"              { return CONTINUE; }

"*="                    { return STAR_EQ;              }
"/="                    { return DIV_EQ;               }
"%="                    { return MOD_EQ;               }
"+="                    { return ADD_EQ;               }
"-="                    { return SUB_EQ;               }
"&="                    { return BITWISE_AND_EQ;       }
"^="                    { return BITWISE_XOR_EQ;       }
"|="                    { return BITWISE_OR_EQ;        }

"..."                   { return DOTS;                 }
"<<="                   { return SL_EQ;                }
">>="                   { return SR_EQ;                }
"++"                    { return INC;                  }
"--"                    { return DEC;                  }
"->"                    { return IMPLIES;              }
"<<"                    { return SHIFT_LEFT;           }
">>"                    { return SHIFT_RIGHT;          }
"<="                    { return LTE;                  }
">="                    { return GTE;                  }
"=="                    { return EQ;                   }
"!="                    { return NEQ;                  }
"&&"                    { return AND;                  }
"||"                    { return OR;                   }


";"                     { return SEMICOLON;  }

"["                     { return SQUARE_BRACKET_OPEN;  }
"]"                     { return SQUARE_BRACKET_CLOSE; }
"("                     { return ROUND_BRACKET_OPEN;   }
")"                     { return ROUND_BRACKET_CLOSE;  }
"{"                     { return CURLY_BRACKET_OPEN;   }
"}"                     { return CURLY_BRACKET_CLOSE;  }

"*"                     { return MUL;        }
"+"                     { return ADD;        }
"-"                     { return SUB;        }
"/"                     { return DIV;        }
"%"                     { return MOD;        }

"#"                     { return HASH;       }
"."                     { return DOT;        }
"&"                     { return BITWISE_AND;}
"~"                     { return BITWISE_NOT;}
"!"                     { return EXCLAIM;    }
"<"                     { return BIT_SL;     }
">"                     { return BIT_SR;     }
","                     { return COMMA;      }
"="                     { return ASSIGN;     }
"?"                     { return QUESTION;   }
"^"                     { return BITWISE_XOR;}
"|"                     { return BITWISE_OR; }
":"                     { return COLON;      }

{INT_CONST}             { 
	                        yylval.intval = atoi(yytext);
							return INTEGER_CONSTANT; 
                        }
{CHAR_CONST}            { 
	                        yylval.char_value = yytext;
							return CHARACTER_CONSTANT; 
						}
{FLOAT_CONST}           { 
	                        yylval.char_value = yytext;
	                        return FLOATING_CONSTANT; 
						}

{IDENTIFIER}            { 
	                        yylval.symp = ST->lookup(yytext);
							return IDENTIFIER; 
						}

{STRING}                { 
	                        yylval.char_value = yytext;
							return STRING_LITERAL; 
						}

{WS}                    { /*White-space Rule*/ }

{NEWLINE}               { /* ++line; */ }

%%