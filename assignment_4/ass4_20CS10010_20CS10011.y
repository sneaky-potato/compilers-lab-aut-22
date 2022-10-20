%{
    #include<stdio.h>
    #include<stdlib.h>

    extern int yylex();
    void yyerror(char *);
    void yyinfo(char *);
    extern int yylineno;
    extern char* yytext;
%}

//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 4                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

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
%token LESS_THAN GREATER_THAN DOT BITWISEAND BITWISEOR BITWISEXOR STAR PLUS MINUS NOT EXCLAMATION DIVIDE PERCENTAGE COMMA HASH

%token EXTERN STATIC AUTO REGISTER
%token VOID CHAR SHORT INT LONG FLOAT DOUBLE SIGNED UNSIGNED BOOL COMPLEX IMAGINARY
%token CONST ENUM INLINE RESTRICT VOLATILE
%token IF ELSE SWITCH  CASE DEFAULT WHILE CONTINUE DO GOTO FOR RETURN BREAK
%token STRUCT TYPEDEF UNION

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
        { yyinfo("primary-expression --> identifier"); }
    | CHARACTER_CONSTANT
        { yyinfo("primary-expression --> character_constant"); }
    | INTEGER_CONSTANT
        { yyinfo("primary-expression --> integer constant"); }
    | FLOATING_CONSTANT
        { yyinfo("primary-expression --> float_constant"); }
    | STRING_LITERAL
        { yyinfo("primary-expression --> string_literal"); }
    | PARENTHESIS_OPEN expression PARENTHESIS_CLOSE
        { yyinfo("primary-expression --> (expression)"); }
    ;

postfix_expression:
    primary_expression
        { yyinfo("postfix-expression --> primary_expression"); }
    | postfix_expression SQR_BRACE_OPEN expression SQR_BRACE_CLOSE
        { yyinfo("postfix-expression --> postfix_expression[expression]"); }
    | postfix_expression PARENTHESIS_OPEN PARENTHESIS_CLOSE
        { yyinfo("postfix-expression --> postfix_expression()"); }
    | postfix_expression PARENTHESIS_OPEN argument_expression_list PARENTHESIS_CLOSE
        { yyinfo("postfix-expression --> postfix_expression(argument_expression_list)"); }
    | postfix_expression DOT IDENTIFIER
        { yyinfo("postfix-expression --> postfix_expression.identifier"); }
    | postfix_expression PTR_OP IDENTIFIER
        { yyinfo("postfix-expression --> postfix_expression->identifier"); }
    | postfix_expression INC_OP
        { yyinfo("postfix-expression --> postfix_expression++"); }
    | postfix_expression DEC_OP
        { yyinfo("postfix-expression --> postfix_expression--"); }
    | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE
        { yyinfo("postfix-expression --> (type_name){initializer_list}"); }
    | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE
        {yyinfo("postfix expression"); }
    ;

argument_expression_list:
    assignment_expression
        { yyinfo("argument_expression_list --> assignment_expression"); }
    | argument_expression_list COMMA assignment_expression
        {yyinfo("argument_list , expression list");}
    ;

unary_expression:
    postfix_expression
        { yyinfo("unary_expression --> postfix_expression"); }
    | INC_OP unary_expression
        { yyinfo("unary_expression --> ++unary_expression"); }
    | DEC_OP unary_expression
        { yyinfo("unary_expression --> --unary_expression"); }
    | unary_operator cast_expression
        { yyinfo("unary_expression --> unary_operator cast_expression"); }
    | SIZEOF unary_expression
        { yyinfo("unary_expression --> sizeof unary_expression"); }
    | SIZEOF PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE
        {yyinfo("unary expression --> sizeof (type_name)");}
    ;

unary_operator:
    BITWISEAND
        {yyinfo("unary operator -> &");}
    | STAR
        {yyinfo("unary operator -> *");}
    | PLUS  
        {yyinfo("unary operator -> +");}
    | MINUS
        {yyinfo("unary operator -> -");}
    | EXCLAMATION
        {yyinfo("unary operator -> !");}
    | NOT
        {yyinfo("unary operator -> ~");}
    ;

cast_expression:
    unary_expression
        { yyinfo("cast_expression --> unary_expression"); }
    | PARENTHESIS_OPEN type_name PARENTHESIS_CLOSE cast_expression
        { yyinfo("cast_expression --> (type_name) cast_expression"); }
    ;

multiplicative_expression:
    cast_expression
        { yyinfo("multiplicative_expression --> cast_expression"); }
    | multiplicative_expression STAR cast_expression
        {yyinfo("multiplicative expression --> *");}
    | multiplicative_expression DIVIDE cast_expression
        {yyinfo("multiplicative expression --> /");}
    | multiplicative_expression PERCENTAGE cast_expression
        {yyinfo("multiplicative expression --> %");}
    ;

additive_expression:
    multiplicative_expression
        { yyinfo("additive_expression --> multiplicative_expression"); }
    | additive_expression PLUS multiplicative_expression
        {yyinfo("additive expression --> additive expression + multiplicative expression");}
    | additive_expression MINUS multiplicative_expression
        {yyinfo("additive expression --> additive expression - multiplicative expression");}
    ;

shift_expression:
    additive_expression
        { yyinfo("shift_expression --> additive_expression"); }
    | shift_expression LEFT_OP additive_expression
        {yyinfo("shift expression --> shift expression << additive expression");}
    | shift_expression RIGHT_OP additive_expression
        {yyinfo("shift expression --> shift expression >> additive expression");}
    ;

relational_expression:
    shift_expression
        { yyinfo("relational_expression --> shift_expression"); }
    | relational_expression LESS_THAN shift_expression
        {yyinfo("relational expression --> relational expression < shift expression");}
    | relational_expression GREATER_THAN shift_expression
        {yyinfo("relational expression --> relational expression > shift expression");}
    | relational_expression GTE_OP shift_expression
        {yyinfo("relational expression --> relational expression >= shift expression");}
    | relational_expression LTE_OP shift_expression
        {yyinfo("relational expression --> relational expression <= shift expression");}

equality_expression:
    relational_expression
        {yyinfo("equality expression --> relational expression");}
    | equality_expression EQ_OP relational_expression
        {yyinfo("equality expression --> equality expression == relational expression");}
    | equality_expression NE_OP relational_expression
        {yyinfo("equality expression --> equality expression != relational expression");}
    ;

and_expression:
    equality_expression
        {yyinfo("and expression --> equality expression");}
    | and_expression BITWISEAND equality_expression
        {yyinfo("and expression --> and expression & equality expression");}
    ;

exclusive_or_expression:
    and_expression
        {yyinfo("exclusive or expression --> and expression");}
    | exclusive_or_expression BITWISEXOR and_expression
        {yyinfo("exclusive or expression --> exclusive or expression ^ and expression");}
    ;

inclusive_or_expression:
    exclusive_or_expression
        {yyinfo("inclusive or expression --> exclusive or expression");}
    | inclusive_or_expression BITWISEOR exclusive_or_expression
        {yyinfo("inclusive or expression --> inclusive or expression | exclusive or expression");}
    ;

logical_and_expression:
    inclusive_or_expression
        {yyinfo("logical and expression --> inclusive or expression");}
    | logical_and_expression AND_OP inclusive_or_expression
        {yyinfo("logical and expression --> logical and expression && inclusive or expression");}
    ;

logical_or_expression:
    logical_and_expression
        {yyinfo("logical or expression --> logical and expression");}
    | logical_or_expression OR_OP logical_and_expression
        {yyinfo("logical or expression --> logical or expression || logical and expression");}

conditional_expression:
    logical_or_expression
        {yyinfo("conditional expression --> logical or expression");}
    | logical_or_expression QUESTION_MARK expression COLON conditional_expression
        {yyinfo("conditional expression --> logical or expression ? expression : conditional expression");}
    ;

assignment_expression:
    conditional_expression
        {yyinfo("assignment expression --> conditional expression");}
    | unary_expression assignment_operator assignment_expression
        {yyinfo("assignment expression --> unary_expression assign_op assignment_expression");}
    ;

assignment_operator:
    EQ
        {yyinfo("assignment operator --> =");}
    | MUL_ASSIGN
        {yyinfo("assignment operator --> *=");}
    | DIV_ASSIGN
        {yyinfo("assignment operator --> /=");}
    | MOD_ASSIGN
        {yyinfo("assignment operator --> %=");}
    | ADD_ASSIGN
        {yyinfo("assignment operator --> +=");}
    | SUB_ASSIGN
        {yyinfo("assignment operator --> -=");}
    | LEFT_ASSIGN
        {yyinfo("assignment operator --> <<=");}
    | RIGHT_ASSIGN
        {yyinfo("assignment operator --> >>=");}
    | AND_ASSIGN
        {yyinfo("assignment operator --> &=");}
    | XOR_ASSIGN
        {yyinfo("assignment operator --> ^=");}
    | OR_ASSIGN
        {yyinfo("assignment operator --> |=");}
    ;

expression:
    assignment_expression
        {yyinfo("expression --> assignment expression");}
    | expression COMMA assignment_expression
        {yyinfo("expression --> expression , assignment expression");}
    ;

expression_opt:
    expression
        {yyinfo("expression_opt --> expression");}
    | 
        {yyinfo("expression_opt --> epsilon");}
    ;

constant_expression:
    conditional_expression
        {yyinfo("constant expression --> conditional expression");}
    ;

// Declarations

declaration:
    declaration_specifiers init_declarator_list_opt SEMI_COLON
        {yyinfo("declaration --> declaration specifiers init_declarator_list_opt");}
    ;

init_declarator_list_opt:
    init_declarator_list
        {yyinfo("init_declarator_list_opt --> init_declarator_list");}
    |
        {yyinfo("init_declarator_list_opt --> epsilon");}
    ;

declaration_specifiers_opt:
    declaration_specifiers
        {yyinfo("declaration_specifiers_opt --> declaration_specifiers");}
    |
        {yyinfo("declaration_specifiers_opt --> epsilon");}
    ;

declaration_specifiers:
    storage_class_specifier declaration_specifiers_opt
        {yyinfo("declaration_specifiers --> storage_class_specifier declaration_specifiers_opt");}
    | type_specifier declaration_specifiers_opt
        {yyinfo("declaration_specifiers --> type_specifier declaration_specifiers_opt");}
    | type_qualifier declaration_specifiers_opt
        {yyinfo("declaration_specifiers --> type_qualifier declaration_specifiers_opt");}
    | function_specifier declaration_specifiers_opt
        {yyinfo("declaration_specifiers --> function_specifier declaration_specifiers_opt");}
    ;

init_declarator_list:
    init_declarator
        {yyinfo("init_declarator_list --> init_declarator");}
    | init_declarator_list COMMA init_declarator
        {yyinfo("init_declarator_list --> init_declarator_list , init_declarator");}
    ;

init_declarator:
    declarator
        {yyinfo("init_declarator --> declarator");}
    | declarator EQ initializer
        {yyinfo("init_declarator --> declarator = initializer");}
    ;

storage_class_specifier:
    EXTERN
        {yyinfo("storage specifier --> extern");}
    | STATIC
        {yyinfo("storage specifier --> static");}
    | AUTO
        {yyinfo("storage specifier --> auto");}
    | REGISTER
        {yyinfo("storage specifier --> register");}
    ;

type_specifier:
    VOID
        {yyinfo("type specifier --> void");}
    | CHAR
        {yyinfo("type specifier --> char");}
    | SHORT
        {yyinfo("type specifier --> short");}
    | INT
        {yyinfo("type specifier --> int");}
    | LONG
        {yyinfo("type specifier --> long");}
    | FLOAT
        {yyinfo("type specifier --> float");}
    | DOUBLE
        {yyinfo("type specifier --> double");}
    | SIGNED
        {yyinfo("type specifier --> signed");}
    | UNSIGNED
        {yyinfo("type specifier --> unsigned");}
    | BOOL
        {yyinfo("type specifier --> bool");}
    | COMPLEX
        {yyinfo("type specifier --> complex");}
    | IMAGINARY
        {yyinfo("type specifier --> imaginary");}
    | enum_specifier
        {yyinfo("type specifier --> enum specifier");}
    ;    

specifier_qualifier_list_opt:
    specifier_qualifier_list
        {yyinfo("specifier_qualifier_list_opt --> specifier_qualifier_list");}
    |
        {yyinfo("specifier_qualifier_list_opt --> epsilon");}
    ;

specifier_qualifier_list:
    type_specifier specifier_qualifier_list_opt
        {yyinfo("specifier_qualifier_list --> type_specifier specifier_qualifier_list_opt");}
    | type_qualifier specifier_qualifier_list_opt
        {yyinfo("specifier_qualifier_list --> type_qualifier specifier_qualifier_list_opt");}
    ;

identifier_opt:
    IDENTIFIER  
        {yyinfo("identifier_opt --> identifier");}
    |
        {yyinfo("identifier_opt --> epsilon");}
    ;

enum_specifier:
    ENUM identifier_opt CURLY_BRACE_OPEN enumerator_list CURLY_BRACE_CLOSE
        {yyinfo("enum specifier --> enum identifier_opt { enumerator_list }");}
    | ENUM identifier_opt CURLY_BRACE_OPEN enumerator_list COMMA CURLY_BRACE_CLOSE
        {yyinfo("enum specifier --> enum identifier_opt { enumerator_list , }");}
    | ENUM IDENTIFIER
        {yyinfo("enum specifier --> enum identifier");}
    ;

enumerator_list:
    enumerator
        {yyinfo("enumerator_list --> enumerator");}
    | enumerator_list COMMA enumerator
        {yyinfo("enumerator_list --> enumerator_list , enumerator");}
    ;

enumerator:
    IDENTIFIER
        {yyinfo("enumerator --> identifier");}
    | IDENTIFIER EQ constant_expression
        {yyinfo("enumerator --> identifier = constant expression");}
    ;

type_qualifier:
    CONST
        {yyinfo("type qualifier --> const");}
    | RESTRICT
        {yyinfo("type qualifier --> restrict");}
    | VOLATILE
        {yyinfo("type qualifier --> volatile");}
    ;

function_specifier:
    INLINE
        {yyinfo("function specifier --> inline");}
    ;

pointer_opt:
    pointer
        {yyinfo("pointer_opt --> pointer");}
    |
        {yyinfo("pointer_opt --> epsilon");}
    ;

declarator:
    pointer_opt direct_declarator
        {yyinfo("declarator --> pointer_opt direct_declarator");}
    ;

assignment_expression_opt:
    assignment_expression
        {yyinfo("assignment_expression_opt --> assignment_expression");}
    |
        {yyinfo("assignment_expression_opt --> epsilon");}
    ;


identifier_list_opt:
    identifier_list
        {yyinfo("identifier_list_opt --> identifier_list");}
    | 
        {yyinfo("identifier_list_opt --> epsilon");}
    ;

direct_declarator:
    IDENTIFIER
        {yyinfo("direct declarator --> identifier");}
    | PARENTHESIS_OPEN declarator PARENTHESIS_CLOSE
        {yyinfo("direct declarator --> (declarator)");}
    | direct_declarator SQR_BRACE_OPEN type_qualifier_list_opt assignment_expression_opt SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [type qualifier? assignment expression?]");}
    | direct_declarator SQR_BRACE_OPEN STATIC type_qualifier_list_opt assignment_expression SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [static type qualifier? assignment expression?]");}
    | direct_declarator SQR_BRACE_OPEN type_qualifier_list STATIC assignment_expression SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [type qualifier? static assignment expression?]");}
    | direct_declarator SQR_BRACE_OPEN type_qualifier_list_opt STAR SQR_BRACE_CLOSE
        {yyinfo("direct declarator --> direct declarator [type qualifier? *]");}
    | direct_declarator PARENTHESIS_OPEN parameter_type_list PARENTHESIS_CLOSE
        {yyinfo("direct declarator --> direct declarator (parameter type list)");}
    | direct_declarator PARENTHESIS_OPEN identifier_list_opt PARENTHESIS_CLOSE
        {yyinfo("direct declarator --> direct declarator (identifier list)");}
    ;

pointer:
    STAR type_qualifier_list_opt
        {yyinfo("pointer --> * type qualifier list?");}
    | STAR type_qualifier_list_opt pointer
        {yyinfo("pointer --> * type qualifier list? pointer");}
    ;

type_qualifier_list:
    type_qualifier
        {yyinfo("type_qualifier_list --> type_qualifier");}
    | type_qualifier_list type_qualifier
        {yyinfo("type_qualifier_list --> type_qualifier_list type_qualifier");}
    ;

type_qualifier_list_opt:
    type_qualifier_list
        {yyinfo("type_qualifier_list_opt --> type_qualifier_list");}
    | 
        {yyinfo("type_qualifier_list_opt --> epsilon");}
    ;

parameter_type_list:
    parameter_list
        {yyinfo("parameter type list");}
    | parameter_list COMMA ELLIPSIS
        {yyinfo("parameter type list");}
    ;

parameter_list:
    parameter_declaration
        {yyinfo("parameter list -> parameter declaration");}
    | parameter_list COMMA parameter_declaration
        {yyinfo("parameter list");}
    ;

parameter_declaration:
    declaration_specifiers declarator
        {yyinfo("parameter declaration -> declaration specifiers declarator");}
    | declaration_specifiers
        {yyinfo("parameter declaration -> declaration specifiers");}
    ;

identifier_list:
    IDENTIFIER
        {yyinfo("identifier list -> identifier");}
    | identifier_list COMMA IDENTIFIER
        {yyinfo("identifier list");}
    ;

type_name:
    specifier_qualifier_list
        {yyinfo("type name -> specifier qualifier list");}
    ;

initializer:
    assignment_expression
        {yyinfo("initializer --> assignment expression");}
    | CURLY_BRACE_OPEN initializer_list CURLY_BRACE_CLOSE
        {yyinfo("initializer --> {initializer list}");}
    | CURLY_BRACE_OPEN initializer_list COMMA CURLY_BRACE_CLOSE
        {yyinfo("initializer --> {initializer list , }");}
    ;

initializer_list:
    designation_opt initializer
        {yyinfo("initializer list --> designation? initializer");}
    | initializer_list COMMA designation_opt initializer
        {yyinfo("initializer list --> initializer list , designation? initializer");}
    ;

designation_opt:
    designation
        {yyinfo("designation_opt --> designation");}
    | 
        {yyinfo("designation_opt --> epsilon");}
    ;

designation:
    designator_list EQ
        {yyinfo("designation --> designator list =");}
    ;

designator_list:
    designator
        {yyinfo("designator_list --> designator");}
    | designator_list designator
        {yyinfo("designator_list --> designator_list designator");}
    ;

designator:
    SQR_BRACE_OPEN constant_expression SQR_BRACE_CLOSE
        {yyinfo("designator --> [constant expression]");}
    | DOT IDENTIFIER
        {yyinfo("designator --> .identifier");}
    ;

// Statements

statement:
    labeled_statement
        {yyinfo("statement --> labeled statement");}
    | compound_statement
        {yyinfo("statement --> compound statement");}
    | expression_statement
        {yyinfo("statement --> expression statement");}
    | selection_statement
        {yyinfo("statement --> selection statement");}
    | iteration_statement
        {yyinfo("statement --> iteration statement");}
    | jump_statement
        {yyinfo("statement --> jump statement");}
    ;

labeled_statement:
    IDENTIFIER COLON statement
        {yyinfo("labeled statement --> identifier : statement");}
    | CASE constant_expression COLON statement
        {yyinfo("labeled statement --> case constant expression : statement");}
    | DEFAULT COLON statement
        {yyinfo("labeled statement --> default : statement");}
    ;

compound_statement:
    CURLY_BRACE_OPEN block_item_list_opt CURLY_BRACE_CLOSE
        {yyinfo("compound statement --> {block item list?}");}
    ;

block_item_list:
    block_item
        {yyinfo("block item list --> block item");}
    | block_item_list block_item
        {yyinfo("block item list --> block item list block item");}
    ;

block_item_list_opt:
    block_item_list
        {yyinfo("block_item_list_opt --> block_item_list");}
    | 
        {yyinfo("block_item_list_opt --> epsilon");}
    ;

block_item:
    declaration
        {yyinfo("block item --> declaration");}
    | statement
        {yyinfo("block item --> statement");}
    ;

expression_statement:
    expression_opt SEMI_COLON
        {yyinfo("expression statement");}
    ;

selection_statement:
    IF PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
        {yyinfo("selection statement --> if");}
    | IF PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement ELSE statement
        {yyinfo("selection statement --> if else");}
    | SWITCH PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
        {yyinfo("selection statement --> switch");}
    ;

iteration_statement:
    WHILE PARENTHESIS_OPEN expression PARENTHESIS_CLOSE statement
        {yyinfo("iteration statement --> while");}
    | DO statement WHILE PARENTHESIS_OPEN expression PARENTHESIS_CLOSE SEMI_COLON
        {yyinfo("iteration statement --> do while");}
    | FOR PARENTHESIS_OPEN expression_opt SEMI_COLON expression_opt SEMI_COLON expression_opt PARENTHESIS_CLOSE statement
        {yyinfo("iteration statement --> for");}
    | FOR PARENTHESIS_OPEN declaration expression_opt SEMI_COLON expression_opt PARENTHESIS_CLOSE statement
        {yyinfo("iteration statement --> for");}
    ;

jump_statement:
    GOTO IDENTIFIER SEMI_COLON
        {yyinfo("jump statement --> goto identifier");}
    | CONTINUE SEMI_COLON
        {yyinfo("jump statement --> continue");}
    | BREAK SEMI_COLON
        {yyinfo("jump statement --> break");}
    | RETURN expression_opt SEMI_COLON
        {yyinfo("jump statement --> return expression?");}
    ;

// External definitions

translation_unit:
    external_declaration
        {yyinfo("translation unit --> external declaration");}
    | translation_unit external_declaration
        {yyinfo("translation unit --> translation unit external declaration");}
    ;

external_declaration:
    function_definition
        {yyinfo("external declaration --> function definition");}
    | declaration
        {yyinfo("external declaration --> declaration");}
    ;

function_definition:
    declaration_specifiers declarator declaration_list_opt compound_statement
        {yyinfo("function definition --> declaration specifiers declarator declaration list? compound statement");}
    ;

declaration_list_opt:
    declaration_list
        {yyinfo("declaration_list_opt --> declaration_list");}
    | 
        {yyinfo("declaration_list_opt --> epsilon");}
    ;

declaration_list:
    declaration
        {yyinfo("declaration_list --> declaration");}
    | declaration_list declaration
        {yyinfo("declaration_list --> declaration_list declaration");}
    ;

%%

void yyerror(char* s) {
    printf("ERROR [Line %d] : %s, unable to parse : %s\n", yylineno, s, yytext);
}

void yyinfo(char* s) {
    printf("INFO [Line %d] : %s\n", yylineno, s);
}