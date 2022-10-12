%{
    #include<stdio.h>
    #include<stdlib.h>

    extern int yylex();
    void yyerror(char *);
    void yyinfo(char *);
    extern int yylineno;
    extern char* yytext;
%}


%union{
    int iVal;
    float fVal;
    char *cVal;
    char *sVal;
    char *idVal;
}

%token INC_OP DEC_OP PTR_OP EQ
%token CURLY_BRACE_OPEN CURLY_BRACE_CLOSE PARENTHESIS_OPEN PARENTHESIS_CLOSE SQR_BRACE_OPEN SQR_BRACE_CLOSE
%token COLON SEMI_COLON ELLIPSIS QUESTION_MARK
%token SIZEOF
%token LEFT_OP RIGHT_OP EQ_OP NE_OP LTE_OP GTE_OP
%token AND_OP OR_OP 
%token ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN RIGHT_ASSIGN LEFT_ASSIGN OR_ASSIGN AND_ASSIGN XOR_ASSIGN
%token EXTERN STATIC AUTO REGISTER
%token VOID CHAR SHORT INT LONG FLOAT DOUBLE SIGNED UNSIGNED BOOL COMPLEX IMAGINARY
%token CONST ENUM INLINE RESTRICT VOLATILE
%token IF ELSE SWITCH  CASE DEFAULT WHILE CONTINUE DO GOTO FOR RETURN BREAK
%token STRUCT TYPEDEF UNION
%token LESS_THAN GREATER_THAN DOT BITWISEAND BITWISEOR BITWISEXOR STAR PLUS MINUS NOT EXCLAMATION DIVIDE PERCENTAGE COMMA HASH

%token <sVal> IDENTIFIER
%token <iVal> INTEGER_CONSTANT
%token <fVal> FLOATING_CONSTANT
%token <cVal> CHARACTER_CONSTANT
%token <sVal> STRING_LITERAL

%token INVALID_TOKEN 

%nonassoc PARENTHESIS_CLOSE
%nonassoc ELSE

%start translation_unit

%%

// Expressions 

primary_expression: 
    IDENTIFIER
        { yyinfo("primary-expression --> identifier\n"); }
    | CHARACTER_CONSTANT
        { yyinfo("primary-expression --> character_constant\n"); }
    | INTEGER_CONSTANT
        { yyinfo("primary-expression --> integer constant\n"); }
    | FLOATING_CONSTANT
        { yyinfo("primary-expression --> float_constant\n"); }
    | STRING_LITERAL
        { yyinfo("primary-expression --> string_literal\n"); }
    | PARENTHESIS_OPEN expression PARENTHESIS_CLOSE
        { yyinfo("primary-expression --> (expression)\n"); }
    ;

postfix_expression:
    primary_expression
    | postfix_expression SQR_BRACE_OPEN expression SQR_BRACE_CLOSE
    | postfix_expression PARENTHESIS_OPEN PARENTHESIS_CLOSE
    | postfix_expression PARENTHESIS_OPEN argument_expression_list PARENTHESIS_CLOSE
    | postfix_expression DOT IDENTIFIER
    | postfix_expression PTR_OP IDENTIFIER
    | postfix_expression INC_OP
    | postfix_expression DEC_OP
    | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE
    | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE
        {yyinfo("postfix expression\n"); }
    ;

argument_expression_list:
    assignment_expression
    | argument_expression_list COMMA assignment_expression
        {yyinfo("argument expression list\n");}
    ;

unary_expression:
    postfix_expression
    | INC_OP unary_expression
    | DEC_OP unary_expression
    | unary_operator cast_expression
    | SIZEOF unary_expression
    | SIZEOF PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE
        {yyinfo("unary expression\n");}
    ;

unary_operator:
    BITWISEAND
    | STAR
    | PLUS  
    | MINUS
    | EXCLAMATION
    | NOT
        {yyinfo("unary operator\n");}
    ;

cast_expression:
    unary_expression
    | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE cast_expression
        {yyinfo("cast expression\n");}
    ;

multiplicative_expression:
    cast_expression
    | multiplicative_expression STAR cast_expression
    | multiplicative_expression DIVIDE cast_expression
    | multiplicative_expression PERCENTAGE cast_expression
        {yyinfo("multiplicative expression\n");}
    ;

additive_expression:
    multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
        {yyinfo("additive expression\n");}
    ;

shift_expression:
    additive_expression
    | shift_expression LEFT_OP additive_expression
    | shift_expression RIGHT_OP additive_expression
        {yyinfo("shift expression\n");}
    ;

relational_expression:
    shift_expression
    | relational_expression LESS_THAN shift_expression
    | relational_expression GREATER_THAN shift_expression
    | relational_expression GTE_OP shift_expression
    | relational_expression LTE_OP shift_expression
        {yyinfo("relational expression\n");}

equality_expression:
    relational_expression
        {yyinfo("equality expression --> relational expression\n");}
    | equality_expression EQ_OP relational_expression
        {yyinfo("equality expression --> ==\n");}
    | equality_expression NE_OP relational_expression
        {yyinfo("equality expression --> !=\n");}
    ;

and_expression:
    equality_expression
    | and_expression BITWISEAND equality_expression
        {yyinfo("and expression\n");}
    ;

exclusive_or_expression:
    and_expression
    | exclusive_or_expression BITWISEXOR and_expression
        {yyinfo("xor expression\n");}
    ;

inclusive_or_expression:
    exclusive_or_expression
    | inclusive_or_expression BITWISEOR exclusive_or_expression
        {yyinfo("or expression\n");}
    ;

logical_and_expression:
    inclusive_or_expression
    | logical_and_expression AND_OP inclusive_or_expression
    ;

logical_or_expression:
    logical_and_expression
    | logical_or_expression OR_OP logical_and_expression

conditional_expression:
    logical_or_expression
    | logical_or_expression QUESTION_MARK expression COLON conditional_expression
    ;

assignment_expression:
    conditional_expression
        {yyinfo("assignment expression --> conditional expression\n");}
    | unary_expression assignment_operator assignment_expression
        {yyinfo("assignment expression --> unary_expression assign_op expression\n");}
    ;

assignment_operator:
    EQ
        {yyinfo("assignment operator --> =\n");}
    | MUL_ASSIGN
        {yyinfo("assignment operator --> *=\n");}
    | DIV_ASSIGN
        {yyinfo("assignment operator --> /=\n");}
    | MOD_ASSIGN
        {yyinfo("assignment operator --> %=\n");}
    | ADD_ASSIGN
        {yyinfo("assignment operator --> +=\n");}
    | SUB_ASSIGN
        {yyinfo("assignment operator --> -=\n");}
    | LEFT_ASSIGN
        {yyinfo("assignment operator --> <<=\n");}
    | RIGHT_ASSIGN
        {yyinfo("assignment operator --> >>=\n");}
    | AND_ASSIGN
        {yyinfo("assignment operator --> &=\n");}
    | XOR_ASSIGN
        {yyinfo("assignment operator --> ^=\n");}
    | OR_ASSIGN
        {yyinfo("assignment operator --> |=\n");}
    ;

expression:
    assignment_expression
        {yyinfo("expression --> assignment expression\n");}
    | expression COMMA assignment_expression
        {yyinfo("expression --> expression , assignment expression\n");}
    ;

expression_opt:
    expression
    | 
    ;

constant_expression:
    conditional_expression

// Declarations

declaration:
    declaration_specifiers init_declarator_list_opt
    ;

init_declarator_list_opt:
    init_declarator_list
    |
    ;

declaration_specifiers_opt:
    declaration_specifiers
    |
    ;

declaration_specifiers:
    storage_class_specifier declaration_specifiers_opt
    | type_specifier declaration_specifiers_opt
    | type_qualifier declaration_specifiers_opt
    | function_specifier declaration_specifiers_opt
    ;

init_declarator_list:
    init_declarator
    | init_declarator_list COMMA init_declarator
    ;

init_declarator:
    declarator
    | declarator EQ initializer
    ;

storage_class_specifier:
    EXTERN
    | STATIC
    | AUTO
    | REGISTER
    ;

type_specifier:
    VOID
        {yyinfo("type specifier --> void\n");}
    | CHAR
        {yyinfo("type specifier --> char\n");}
    | SHORT
        {yyinfo("type specifier --> short\n");}
    | INT
        {yyinfo("type specifier --> int\n");}
    | LONG
        {yyinfo("type specifier --> long\n");}
    | FLOAT
        {yyinfo("type specifier --> float\n");}
    | DOUBLE
        {yyinfo("type specifier --> double\n");}
    | SIGNED
        {yyinfo("type specifier --> signed\n");}
    | UNSIGNED
        {yyinfo("type specifier --> unsigned\n");}
    | BOOL
        {yyinfo("type specifier --> bool\n");}
    | COMPLEX
        {yyinfo("type specifier --> complex\n");}
    | IMAGINARY
        {yyinfo("type specifier --> imaginary\n");}
    | enum_specifier
        {yyinfo("type specifier --> enum specifier\n");}
    ;    

specifier_qualifier_list_opt:
    specifier_qualifier_list
    |
    ;

specifier_qualifier_list:
    type_specifier specifier_qualifier_list_opt
    | type_qualifier specifier_qualifier_list_opt
    ;

identifier_opt:
    IDENTIFIER
    |
    ;

enum_specifier:
    ENUM identifier_opt CURLY_BRACE_OPEN enumerator_list CURLY_BRACE_CLOSE
    | ENUM identifier_opt CURLY_BRACE_OPEN enumerator_list COMMA CURLY_BRACE_CLOSE
    | ENUM IDENTIFIER
    ;

enumerator_list:
    enumerator
    | enumerator_list COMMA enumerator
    ;

enumerator:
    IDENTIFIER
    | IDENTIFIER EQ constant_expression
    ;

type_qualifier:
    CONST
        {yyinfo("type qualifier --> const\n");}
    | RESTRICT
        {yyinfo("type qualifier --> restrict\n");}
    | VOLATILE
        {yyinfo("type qualifier --> volatile\n");}
    ;

function_specifier:
    INLINE
        {yyinfo("function specifier --> inline\n");}
    ;

pointer_opt:
    pointer
    |
    ;

declarator:
    pointer_opt direct_declarator
    ;

assignment_expression_opt:
    assignment_expression
    | 
    ;


identifier_list_opt:
    identifier_list
    | 
    ;

direct_declarator:
    IDENTIFIER
        {yyinfo("direct declarator --> identifier\n");}
    | PARENTHESIS_OPEN declarator PARENTHESIS_CLOSE
        {yyinfo("direct declarator --> (declarator)\n");}
    | direct_declarator SQR_BRACE_OPEN type_qualifier_list_opt assignment_expression_opt SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [type qualifier? assignment expression?]\n");}
    | direct_declarator SQR_BRACE_OPEN STATIC type_qualifier_list_opt assignment_expression SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [static type qualifier? assignment expression?]\n");}
    | direct_declarator SQR_BRACE_OPEN type_qualifier_list STATIC assignment_expression SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [type qualifier? static assignment expression?]\n");}
    | direct_declarator SQR_BRACE_OPEN type_qualifier_list_opt STAR SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [type qualifier? *]\n");}
    | direct_declarator PARENTHESIS_OPEN parameter_type_list PARENTHESIS_CLOSE
        {yyinfo("direct declarator --> direct declarator (parameter type list)\n");}
    | direct_declarator PARENTHESIS_OPEN identifier_list_opt PARENTHESIS_CLOSE
        {yyinfo("direct declarator --> direct declarator (identifier list)\n");}
    ;

pointer:
    STAR type_qualifier_list_opt
    | STAR type_qualifier_list_opt pointer
    ;

type_qualifier_list:
    type_qualifier
    | type_qualifier_list type_qualifier
    ;

type_qualifier_list_opt:
    type_qualifier_list
    | 
    ;

parameter_type_list:
    parameter_list
        {yyinfo("parameter type list\n");}
    | parameter_list COMMA ELLIPSIS
        {yyinfo("parameter type list\n");}
    ;

parameter_list:
    parameter_declaration
        {yyinfo("parameter list -> parameter declaration\n");}
    | parameter_list COMMA parameter_declaration
        {yyinfo("parameter list\n");}
    ;

parameter_declaration:
    declaration_specifiers declarator
    | declaration_specifiers
    ;

identifier_list:
    IDENTIFIER
        {yyinfo("identifier list -> identifier\n");}
    | identifier_list COMMA IDENTIFIER
        {yyinfo("identifier list\n");}
    ;

type_name:
    specifier_qualifier_list
    ;

initializer:
    assignment_expression
    | CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE
    | CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE
    ;

initializer_list:
    designation_opt initializer
    | initializer_list COMMA designation_opt initializer

designation:
    designator_list EQ
    ;

designation_opt:
    designation
    | 
    ;

designator_list:
    designator
    | designator_list designator
    ;

designator:
    SQR_BRACE_OPEN constant_expression SQR_BRACE_CLOSE
    | DOT IDENTIFIER
    ;

// Statements

statement:
    labeled_statement
        {yyinfo("statement --> labeled statement\n");}
    | compound_statement
        {yyinfo("statement --> compound statement\n");}
    | expression_statement
        {yyinfo("statement --> expression statement\n");}
    | selection_statement
        {yyinfo("statement --> selection statement\n");}
    | iteration_statement
        {yyinfo("statement --> iteration statement\n");}
    | jump_statement
        {yyinfo("statement --> jump statement\n");}
    ;

labeled_statement:
    IDENTIFIER COLON statement
    | CASE constant_expression COLON statement
    | DEFAULT COLON statement
    ;

compound_statement:
    CURLY_BRACE_OPEN block_item_list_opt CURLY_BRACE_CLOSE
    ;

block_item_list:
    block_item
    | block_item_list block_item
    ;

block_item_list_opt:
    block_item_list
    | 
    ;

block_item:
    declaration
    | statement
    ;

expression_statement:
    expression_opt SEMI_COLON
        {yyinfo("expression statement\n");}
    ;

selection_statement:
    IF PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
        {yyinfo("selection statement --> if\n");}
    | IF PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement ELSE statement
        {yyinfo("selection statement --> if else\n");}
    | SWITCH PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
        {yyinfo("selection statement --> switch\n");}
    ;

iteration_statement:
    WHILE PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
    | DO statement WHILE PARENTHESIS_OPEN expression PARENTHESIS_CLOSE SEMI_COLON
    | FOR PARENTHESIS_OPEN expression_opt SEMI_COLON expression_opt SEMI_COLON expression_opt PARENTHESIS_CLOSE statement
    | FOR PARENTHESIS_OPEN declaration expression_opt SEMI_COLON expression_opt PARENTHESIS_CLOSE statement
    ;

jump_statement:
    GOTO IDENTIFIER SEMI_COLON
    | CONTINUE SEMI_COLON
    | BREAK SEMI_COLON
    | RETURN expression_opt SEMI_COLON
    ;

// External definitions

translation_unit:
    external_declaration
    | translation_unit external_declaration
    ;

external_declaration:
    function_definition
    | declaration
    ;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement
    ;

declaration_list_opt:
    declaration_list
    | 
    ;

declaration_list:
    declaration
    | declaration_list declaration
    ;

%%

void yyerror(char* s) {
    printf("ERROR [Line %d] : %s, unable to parse : %s\n", yylineno, s, yytext);
}

void yyinfo(char* s) {
    printf("INFO [Line %d] : %s\n", yylineno, s);
}