//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 5                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

%{
    #include "ass5_20CS10010_20CS10011_translator.h"
    #include <bits/stdc++.h>
    #include <sstream>

    using namespace std;
    
    extern "C" int yylex();
    
    //var_type for last encountered type
    extern string var_type;
    extern vector<Label> label_table;

    void yyerror(string s);
%}

// datatypes
%union {
    // types for terminals
    char unaryOp;
    char* char_value;
    int intval;
    int instr_number;
    int num_params;

    // types for nonterminals
    Expression* expr;
    Statement* stat;
    SymbolType* sym_type;
    Symbol* symp;
    Array* A;
}

%token RESTRICT BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY 
            
%token <symp> IDENTIFIER                              
%token <char_value> STRING_LITERAL         

%token SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE
%token ROUND_BRACKET_OPEN ROUND_BRACKET_CLOSE
%token CURLY_BRACKET_OPEN CURLY_BRACKET_CLOSE            
%token DOT IMPLIES INC DEC BITWISE_AND MUL ADD SUB BITWISE_NOT EXCLAIM DIV MOD SHIFT_LEFT SHIFT_RIGHT BIT_SL BIT_SR
%token LTE GTE EQ NEQ BITWISE_XOR BITWISE_OR AND OR
%token QUESTION COLON SEMICOLON DOTS ASSIGN 
%token STAR_EQ DIV_EQ MOD_EQ ADD_EQ SUB_EQ SL_EQ SR_EQ BITWISE_AND_EQ BITWISE_XOR_EQ BITWISE_OR_EQ 
%token COMMA HASH THEN

%token <intval> INTEGER_CONSTANT            
%token <char_value> FLOATING_CONSTANT            
%token <char_value> CHARACTER_CONSTANT    

%start translation_unit
%right THEN ELSE

%type <unaryOp> unary_operator
%type <num_params> argument_expression_list argument_expression_list_opt

// Expressions
%type <expr>
    expression
    primary_expression 
    multiplicative_expression
    additive_expression
    shift_expression
    relational_expression
    equality_expression
    and_expression
    exclusive_or_expression
    inclusive_or_expression
    logical_and_expression
    logical_or_expression
    conditional_expression
    assignment_expression
    expression_statement

// Statements
%type <stat>  statement
    compound_statement
    loop_statement
    selection_statement
    iteration_statement
    labeled_statement 
    jump_statement
    block_item
    block_item_list
    block_item_list_opt

%type <sym_type> pointer
%type <symp> initializer
%type <symp> direct_declarator init_declarator declarator
%type <A> postfix_expression
    unary_expression
    cast_expression

//non-terminals M and N that help in backpatching and exitlists
%type <instr_number> M
%type <stat> N

%%

M: %empty 
    {
        //mainly used in backpatching, stores the next quad 
        $$ = nextinstr();
    }   
    ;

W: %empty 
    {
        // identifying the start of a while loop
        loop_name = "WHILE";
    }   
    ;

D: %empty 
    { 
        // identifyiong the start of the do while statement
        loop_name = "DO_WHILE";
    }   
    ;

F: %empty 
    {   
        //start of the for statement 
        loop_name = "FOR";
    }   
    ;


X: %empty 
    {
        //update the current symbol pointer used for nested blocks
        string name = ST->name+"."+loop_name+"#"+to_string(table_count);
        table_count++;
        Symbol* s = ST->lookup(name);

        s->nested = new SymbolTable(name);
        s->nested->parent = ST;
        s->name = name;
        s->type = new SymbolType("block");

        currSymbolPtr = s;
    }   
    ;

N: %empty
    {
        //For backpatching, guard fall through
        $$ = new Statement();
        $$->nextlist=makelist(nextinstr());
        emit("goto","");
    }
    ;

changetable: %empty 
    {    
        parST = ST;
        if(currSymbolPtr->nested==NULL) 
        {
            changeTable(new SymbolTable(""));    
        }
        else 
        {
            changeTable(currSymbolPtr ->nested);                        
            emit("Label", ST->name);
        }
    }
    ;

primary_expression: IDENTIFIER
    {
        // create new expression and store pointer to ST entry in the location
        $$=new Expression();
        $$->loc=$1;
        $$->type="not-boolean";
    }
    // create new expression and store the value of the constant in a temporary
    | INTEGER_CONSTANT
    { 
        $$=new Expression();    
        string p=convertIntToString($1);
        $$->loc=gentemp(new SymbolType("int"),p);
        emit("=",$$->loc->name,p);
    }
    | FLOATING_CONSTANT                                     
    {
        $$=new Expression();
        $$->loc=gentemp(new SymbolType("float"),$1);
        emit("=",$$->loc->name,string($1));
    }
    | CHARACTER_CONSTANT                         
    {
        $$=new Expression();
        $$->loc=gentemp(new SymbolType("char"),$1);
        emit("=",$$->loc->name,string($1));
    }
    | STRING_LITERAL                                
    {
        $$=new Expression();
        $$->loc=gentemp(new SymbolType("ptr"),$1);
        $$->loc->type->arrtype=new SymbolType("char");
    }
    | ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE
    {
        // simply equal to expression
        $$=$2;
    }
    ;


postfix_expression: primary_expression                      
    {
        //create new Array and store the location of primary expression in it
        $$=new Array();    
        $$->Array=$1->loc;    
        $$->type=$1->loc->type;    
        $$->loc=$$->Array;
    }
    | postfix_expression SQUARE_BRACKET_OPEN expression SQUARE_BRACKET_CLOSE 
    {     
        
        $$=new Array();
        $$->type=$1->type->arrtype;
        $$->Array=$1->Array;
        $$->loc=gentemp(new SymbolType("int"));
        $$->atype="arr";
        // if already arr, multiply the size of the sub-type of Array with the expression value and add
        if($1->atype=="arr") 
        {            
            Symbol* t=gentemp(new SymbolType("int"));
            int p=computeSize($$->type);
            string str=convertIntToString(p);
            emit("*",t->name,$3->loc->name,str);
            emit("+",$$->loc->name,$1->loc->name,t->name);
        }
        //if a 1D Array, calculate size
        else 
        {
            int p=computeSize($$->type);    
            string str=convertIntToString(p);
            emit("*",$$->loc->name,$3->loc->name,str);
        }
    }
    | postfix_expression ROUND_BRACKET_OPEN argument_expression_list_opt ROUND_BRACKET_CLOSE       
    {
        
        $$=new Array();    
        $$->Array=gentemp($1->type);
        string str=convertIntToString($3);
        emit("call",$$->Array->name,$1->Array->name,str);
    }
    | postfix_expression DOT IDENTIFIER {  }
    | postfix_expression IMPLIES IDENTIFIER  {  }
    //generate new temporary, equate it to old one and then add 1
    | postfix_expression INC
    { 
        $$=new Array();    
        $$->Array=gentemp($1->Array->type);
        emit("=",$$->Array->name,$1->Array->name);
        emit("+",$1->Array->name,$1->Array->name,"1");
    }
    //generate new temporary, equate it to old one and then subtract 1
    | postfix_expression DEC
    {
        $$=new Array();    
        $$->Array=gentemp($1->Array->type);
        emit("=",$$->Array->name,$1->Array->name);
        emit("-",$1->Array->name,$1->Array->name,"1");    
    }
    | ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE {  }
    | ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE {  }
    ;

argument_expression_list_opt: argument_expression_list 
    { 
        $$=$1;
    }
    | %empty 
    { 
        $$=0;
    } 
    ;

argument_expression_list: assignment_expression    
    {
        //one argument and emit param
        $$=1;
        emit("param",$1->loc->name);    
    }
    | argument_expression_list COMMA assignment_expression     
    {
        $$=$1+1;
        emit("param",$3->loc->name);
    }
    ;

unary_expression: postfix_expression { $$=$1;}                       
    | INC unary_expression                           
    {      
        
        emit("+",$2->Array->name,$2->Array->name,"1");        
        $$=$2;
    }
    | DEC unary_expression                           
    {
        
        emit("-",$2->Array->name,$2->Array->name,"1");
        $$=$2;
    }
    | unary_operator cast_expression                       
    {
        $$=new Array();
        switch($1)
        {      
            //address, generate a pointer temporary and emit the quad
            case '&':
                $$->Array=gentemp(new SymbolType("ptr"));
                $$->Array->type->arrtype=$2->Array->type; 
                emit("=&",$$->Array->name,$2->Array->name);
                break;
            // value, generate a temporary of the corresponding type
            case '*':
                $$->atype="ptr";
                $$->loc=gentemp($2->Array->type->arrtype);
                $$->Array=$2->Array;
                emit("=*",$$->loc->name,$2->Array->name);
                break;
            // Similar case with + - ~ !
            case '+':  
                $$=$2;
                break;
            case '-':                
                $$->Array=gentemp(new SymbolType($2->Array->type->type));
                emit("uminus",$$->Array->name,$2->Array->name);
                break;
            case '~':
                $$->Array=gentemp(new SymbolType($2->Array->type->type));
                emit("~",$$->Array->name,$2->Array->name);
                break;
            case '!':                
                $$->Array=gentemp(new SymbolType($2->Array->type->type));
                emit("!",$$->Array->name,$2->Array->name);
                break;
        }
    }
    | SIZEOF unary_expression  {  }
    | SIZEOF ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE   {  }
    ;

unary_operator: BITWISE_AND     
    { $$='&'; }       
    | MUL          
    {$$='*'; }
    | ADD          
    { $$='+'; }
    | SUB          
    { $$='-'; }
    | BITWISE_NOT  
    { $$='~'; } 
    | EXCLAIM  
    {$$='!'; }
    ;

cast_expression: unary_expression  { $$=$1; }
    | ROUND_BRACKET_OPEN type_name ROUND_BRACKET_CLOSE cast_expression
    { 
        //generate a new symbol of the same type	
        $$=new Array();    
        $$->Array=convertType($4->Array,var_type);
    }
    ;

multiplicative_expression: cast_expression  
    {
        $$ = new Expression();
        if($1->atype=="arr")             
        {
            $$->loc = gentemp($1->loc->type);    
            emit("=[]", $$->loc->name, $1->Array->name, $1->loc->name);
        }
        else if($1->atype=="ptr")
        { 
            $$->loc = $1->loc;
        }
        else
        {
            $$->loc = $1->Array;
        }
    }
    | multiplicative_expression MUL cast_expression           
    { 
        // error in program, type conflict
        if(!compareSymbolType($1->loc, $3->Array))         
            cout<<"Type Error in Program"<< endl;    
        else                                 
        {
            $$ = new Expression();    
            $$->loc = gentemp(new SymbolType($1->loc->type->type));
            emit("*", $$->loc->name, $1->loc->name, $3->Array->name);
        }
    }
    | multiplicative_expression DIV cast_expression      
    {
        if(!compareSymbolType($1->loc, $3->Array)){ 
            cout << "Type Error in Program"<< endl;
        }
        else   
        {
            
            $$ = new Expression();
            $$->loc = gentemp(new SymbolType($1->loc->type->type));
            emit("/", $$->loc->name, $1->loc->name, $3->Array->name);
        }
    }
    | multiplicative_expression MOD cast_expression
    {
        if(!compareSymbolType($1->loc, $3->Array)) cout << "Type Error in Program"<< endl;        
        else          
        {
            $$ = new Expression();
            $$->loc = gentemp(new SymbolType($1->loc->type->type));
            emit("%", $$->loc->name, $1->loc->name, $3->Array->name);    
        }
    }
    ;

additive_expression: multiplicative_expression   { $$=$1; }
    | additive_expression ADD multiplicative_expression
    {
        
        if(!compareSymbolType($1->loc, $3->loc))
            cout << "Type Error in Program"<< endl;
        else        
        {
            $$ = new Expression();    
            $$->loc = gentemp(new SymbolType($1->loc->type->type));
            emit("+", $$->loc->name, $1->loc->name, $3->loc->name);
        }
    }
    | additive_expression SUB multiplicative_expression
    {
        
        if(!compareSymbolType($1->loc, $3->loc))
            cout << "Type Error in Program"<< endl;        
        else
        {    
            $$ = new Expression();    
            $$->loc = gentemp(new SymbolType($1->loc->type->type));
            emit("-", $$->loc->name, $1->loc->name, $3->loc->name);
        }
    }
    ;

shift_expression: additive_expression   { $$=$1; }
    | shift_expression SHIFT_LEFT additive_expression   
    { 
        if(!($3->loc->type->type == "int"))
            cout << "Type Error in Program"<< endl;         
        else
        {        
            $$ = new Expression();        
            $$->loc = gentemp(new SymbolType("int"));
            emit("<<", $$->loc->name, $1->loc->name, $3->loc->name);        
        }
    }
    | shift_expression SHIFT_RIGHT additive_expression
    {     
        if(!($3->loc->type->type == "int"))
        {
            cout << "Type Error in Program"<< endl;         
        }
        else          
        {            
            $$ = new Expression();    
            $$->loc = gentemp(new SymbolType("int"));
            emit(">>", $$->loc->name, $1->loc->name, $3->loc->name);            
        }
    }
    ;

relational_expression: shift_expression   { $$=$1; }
    | relational_expression BIT_SL shift_expression
    {
        if(!compareSymbolType($1->loc, $3->loc)) 
        {
            yyerror("Type Error in Program");
        }
        else 
        {
            $$ = new Expression();
            $$->type = "bool";
            $$->truelist = makelist(nextinstr());
            $$->falselist = makelist(nextinstr()+1);
            emit("<", "", $1->loc->name, $3->loc->name);
            emit("goto", "");    
        }
    }
    | relational_expression BIT_SR shift_expression          
    {
        if(!compareSymbolType($1->loc, $3->loc)) 
        {
            yyerror("Type Error in Program");
        }
        else 
        {    
            $$ = new Expression();        
            $$->type = "bool";
            $$->truelist = makelist(nextinstr());
            $$->falselist = makelist(nextinstr()+1);
            emit(">", "", $1->loc->name, $3->loc->name);
            emit("goto", "");
        }    
    }
    | relational_expression LTE shift_expression            
    {
        if(!compareSymbolType($1->loc, $3->loc)) 
        {
            cout << "Type Error in Program"<< endl;
        }
        else 
        {            
            $$ = new Expression();        
            $$->type = "bool";
            $$->truelist = makelist(nextinstr());
            $$->falselist = makelist(nextinstr()+1);
            emit("<=", "", $1->loc->name, $3->loc->name);
            emit("goto", "");
        }        
    }
    | relational_expression GTE shift_expression             
    {
        if(!compareSymbolType($1->loc, $3->loc))
        {
            cout << "Type Error in Program"<< endl;
        }
        else 
        {    
            $$ = new Expression();    
            $$->type = "bool";
            $$->truelist = makelist(nextinstr());
            $$->falselist = makelist(nextinstr()+1);
            emit(">=", "", $1->loc->name, $3->loc->name);
            emit("goto", "");
        }
    }
    ;

equality_expression: relational_expression  { $$=$1; }                        
    | equality_expression EQ relational_expression 
    {
        //Similar to above, check compatibility, convert bool to int, make list and emit
        if(!compareSymbolType($1->loc, $3->loc))
        {
            cout << "Type Error in Program"<< endl;
        }
        else 
        {
            convertBoolToInt($1);
            convertBoolToInt($3);
            $$ = new Expression();
            $$->type = "bool";
            $$->truelist = makelist(nextinstr());
            $$->falselist = makelist(nextinstr()+1); 
            emit("==", "", $1->loc->name, $3->loc->name);
            emit("goto", "");                
        }
    }
    | equality_expression NEQ relational_expression
    {
        if(!compareSymbolType($1->loc, $3->loc)) 
        {
            
            cout << "Type Error in Program"<< endl;
        }
        else 
        {            
            convertBoolToInt($1);
            convertBoolToInt($3);
            $$ = new Expression();
            $$->type = "bool";
            $$->truelist = makelist(nextinstr());
            $$->falselist = makelist(nextinstr()+1);
            emit("!=", "", $1->loc->name, $3->loc->name);
            emit("goto", "");
        }
    }
    ;

and_expression: equality_expression  { $$=$1; }                        
    | and_expression BITWISE_AND equality_expression 
    {
        if(!compareSymbolType($1->loc, $3->loc))
        {        
            cout << "Type Error in Program"<< endl;
        }
        else 
        {              
            convertBoolToInt($1);
            convertBoolToInt($3);            
            $$ = new Expression();
            $$->type = "not-boolean";
            $$->loc = gentemp(new SymbolType("int"));
            emit("&", $$->loc->name, $1->loc->name, $3->loc->name);
        }
    }
    ;

exclusive_or_expression: and_expression  { $$=$1; }                
    | exclusive_or_expression BITWISE_XOR and_expression    
    {
        if(!compareSymbolType($1->loc, $3->loc))
        {
            cout << "Type Error in Program"<< endl;
        }
        else 
        {
            convertBoolToInt($1);
            convertBoolToInt($3);
            $$ = new Expression();
            $$->type = "not-boolean";
            $$->loc = gentemp(new SymbolType("int"));
            emit("^", $$->loc->name, $1->loc->name, $3->loc->name);
        }
    }
    ;

inclusive_or_expression: exclusive_or_expression { $$=$1; }            
    | inclusive_or_expression BITWISE_OR exclusive_or_expression          
    { 
        if(!compareSymbolType($1->loc, $3->loc))
        { yyerror("Type Error in Program"); }
        else 
        {
            convertBoolToInt($1);        
            convertBoolToInt($3);
            $$ = new Expression();
            $$->type = "not-boolean";
            $$->loc = gentemp(new SymbolType("int"));
            emit("|", $$->loc->name, $1->loc->name, $3->loc->name);
        } 
    }
    ;

logical_and_expression: inclusive_or_expression  { $$=$1; }    
    // backpatching involved B1 & M B2 type expression        
    | logical_and_expression AND M inclusive_or_expression
    { 
        convertIntToBool($4);
        convertIntToBool($1);
        $$ = new Expression();
        $$->type = "bool";
        backpatch($1->truelist, $3);
        $$->truelist = $4->truelist;
        $$->falselist = merge($1->falselist, $4->falselist);
    }
    ;

logical_or_expression: logical_and_expression   { $$=$1; }   
    // backpatching involved B1 || M B2 type expression             
    | logical_or_expression OR M logical_and_expression
    { 
        convertIntToBool($4);            
        convertIntToBool($1);            
        $$ = new Expression();            
        $$->type = "bool";
        backpatch($1->falselist, $3);        
        $$->truelist = merge($1->truelist, $4->truelist);        
        $$->falselist = $4->falselist;             
    }
    ;

conditional_expression: logical_or_expression {$$=$1;}
    // backpatching involved B1 || B2 N ? M expre N : M cond_expr type expression
    | logical_or_expression N QUESTION M expression N COLON M conditional_expression 
    {
        // Generate temporary variable and then emit accordingly
        $$->loc = gentemp($5->loc->type);
        $$->loc->update($5->loc->type);
        emit("=", $$->loc->name, $9->loc->name);
        list<int> l = makelist(nextinstr());
        emit("goto", "");
        backpatch($6->nextlist, nextinstr());
        emit("=", $$->loc->name, $5->loc->name);
        list<int> m = makelist(nextinstr());
        l = merge(l, m);                        
        emit("goto", "");                        
        backpatch($2->nextlist, nextinstr());
        convertIntToBool($1);
        backpatch($1->truelist, $4);
        backpatch($1->falselist, $8);
        backpatch(l, nextinstr());
    }
    ;

assignment_expression: conditional_expression {$$=$1;}
    | unary_expression assignment_operator assignment_expression 
     {
        // array assignment expression
        if($1->atype=="arr")
        {
            $3->loc = convertType($3->loc, $1->type->type);
            emit("[]=", $1->Array->name, $1->loc->name, $3->loc->name);        
        }
        // pointer assignment expression
        else if($1->atype=="ptr")
        {
            emit("*=", $1->Array->name, $3->loc->name);    
        }
        // direct assignment expression
        else
        {
            $3->loc = convertType($3->loc, $1->Array->type->type);
            emit("=", $1->Array->name, $3->loc->name);
        }
        $$ = $3;
    }
    ;

assignment_operator: ASSIGN   {  }
    | STAR_EQ    {  }
    | DIV_EQ    {  }
    | MOD_EQ    {  }
    | ADD_EQ    {  }
    | SUB_EQ    {  }
    | SL_EQ    {  }
    | SR_EQ    {  }
    | BITWISE_AND_EQ    {  }
    | BITWISE_XOR_EQ    {  }
    | BITWISE_OR_EQ    { }
    ;

expression: assignment_expression {  $$=$1;  }
    | expression COMMA assignment_expression {   }
    ;

constant_expression: conditional_expression {   }
    ;

declaration: declaration_specifiers init_declarator_list SEMICOLON {    }
    | declaration_specifiers SEMICOLON {      }
    ;

declaration_specifiers: storage_class_specifier declaration_specifiers {    }
    | storage_class_specifier {    }
    | type_specifier declaration_specifiers {    }
    | type_specifier {    }
    | type_qualifier declaration_specifiers {    }
    | type_qualifier {    }
    | function_specifier declaration_specifiers {    }
    | function_specifier {    }
    ;

init_declarator_list: init_declarator {    }
    | init_declarator_list COMMA init_declarator {    }
    ;

init_declarator: declarator {$$=$1;}
    | declarator ASSIGN initializer 
    {
        if($3->val!="") $1->val=$3->val;
        emit("=", $1->name, $3->name);    
    }
    ;

storage_class_specifier: EXTERN  { }
    | STATIC  { }
    ;

type_specifier: VOID   { var_type="void"; }
    | CHAR   { var_type="char"; }
    | SHORT  { }
    | INT   { var_type="int"; }
    | LONG   {  }
    | FLOAT   { var_type="float"; }
    | DOUBLE   { }
    | SIGNED   {  }
    | UNSIGNED   { }
    | _BOOL   {  }
    | _COMPLEX   {  }
    | _IMAGINARY   {  }
    | enum_specifier   {  }
    ;

specifier_qualifier_list: type_specifier specifier_qualifier_list_opt   {  }
    | type_qualifier specifier_qualifier_list_opt  {  }
    ;

specifier_qualifier_list_opt: %empty {  }
    | specifier_qualifier_list  {  }
    ;

enum_specifier: ENUM identifier_opt CURLY_BRACKET_OPEN enumerator_list CURLY_BRACKET_CLOSE   {  }
    | ENUM identifier_opt CURLY_BRACKET_OPEN enumerator_list COMMA CURLY_BRACKET_CLOSE   {  }
    | ENUM IDENTIFIER {  }
    ;

identifier_opt: %empty  {  }
    | IDENTIFIER   {  }
    ;

enumerator_list: enumerator   {  }
    | enumerator_list COMMA enumerator   {  }
    ;    

enumerator: IDENTIFIER   {  }
    | IDENTIFIER ASSIGN constant_expression   {  }
    ;

type_qualifier: CONST   {  }
    | RESTRICT   {  }
    | VOLATILE   {  }
    ;

function_specifier: INLINE   {  }
    ;

declarator: pointer direct_declarator 
    {
        // Pointer declarator
        SymbolType *t = $1;
        while(t->arrtype!=NULL) t = t->arrtype;
        t->arrtype = $2->type;
        $$ = $2->update($1);
    }
    | direct_declarator {   }
    ;

direct_declarator: IDENTIFIER
    {
        // assignment to different identifier
        $$ = $1->update(new SymbolType(var_type));
        currSymbolPtr = $$;    
    }
    | ROUND_BRACKET_OPEN declarator ROUND_BRACKET_CLOSE {$$=$2;}
    | direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {    }
    | direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list SQUARE_BRACKET_CLOSE {    }
    | direct_declarator SQUARE_BRACKET_OPEN assignment_expression SQUARE_BRACKET_CLOSE 
    {
        SymbolType *t = $1 -> type;
        SymbolType *prev = NULL;
        while(t->type == "arr") 
        {
            prev = t;  
            //move recursively to get basetype  
            t = t->arrtype;
        }
        if(prev==NULL) 
        {
            int temp = atoi($3->loc->val.c_str());
            SymbolType* s = new SymbolType("arr", $1->type, temp);
            $$ = $1->update(s);
        }
        else 
        {
            prev->arrtype =  new SymbolType("arr", t, atoi($3->loc->val.c_str()));
            $$ = $1->update($1->type);
        }
    }
    | direct_declarator SQUARE_BRACKET_OPEN SQUARE_BRACKET_CLOSE 
    {
        SymbolType *t = $1 -> type;
        SymbolType *prev = NULL;
        while(t->type == "arr") 
        {
            prev = t;   
            // move recursively to base type 
            t = t->arrtype;
        }
        if(prev==NULL) 
        {
            SymbolType* s = new SymbolType("arr", $1->type, 0);
            $$ = $1->update(s);
        }
        else 
        {
            prev->arrtype =  new SymbolType("arr", t, 0);
            $$ = $1->update($1->type);
        }
    }
    | direct_declarator SQUARE_BRACKET_OPEN STATIC type_qualifier_list assignment_expression SQUARE_BRACKET_CLOSE {    }
    | direct_declarator SQUARE_BRACKET_OPEN STATIC assignment_expression SQUARE_BRACKET_CLOSE {    }
    | direct_declarator SQUARE_BRACKET_OPEN type_qualifier_list MUL SQUARE_BRACKET_CLOSE {    }
    | direct_declarator SQUARE_BRACKET_OPEN MUL SQUARE_BRACKET_CLOSE {    }
    | direct_declarator ROUND_BRACKET_OPEN changetable parameter_type_list ROUND_BRACKET_CLOSE 
    {
        ST->name = $1->name;    
        if($1->type->type !="void") 
        {
            Symbol *s = ST->lookup("return");
            s->update($1->type);        
        }
        $1->nested=ST;       
        ST->parent = globalST;
        changeTable(globalST);                
        currSymbolPtr = $$;
    }
    | direct_declarator ROUND_BRACKET_OPEN identifier_list ROUND_BRACKET_CLOSE {    }
    | direct_declarator ROUND_BRACKET_OPEN changetable ROUND_BRACKET_CLOSE 
    {
        ST->name = $1->name;
        if($1->type->type !="void") 
        {
            Symbol *s = ST->lookup("return");
            s->update($1->type);
        }
        $1->nested=ST;
        ST->parent = globalST;
        changeTable(globalST);                
        currSymbolPtr = $$;
    }
    ;

type_qualifier_list_opt: %empty   {  }
    | type_qualifier_list      {  }
    ;

pointer: MUL type_qualifier_list_opt   
    { 
        $$ = new SymbolType("ptr");
    }         
    | MUL type_qualifier_list_opt pointer 
    { 
        $$ = new SymbolType("ptr",$3);
    }
    ;

type_qualifier_list: type_qualifier   {  }
    | type_qualifier_list type_qualifier   {  }
    ;

parameter_type_list: parameter_list   {  }
    | parameter_list COMMA DOTS   {  }
    ;

parameter_list: parameter_declaration   {  }
    | parameter_list COMMA parameter_declaration    {  }
    ;

parameter_declaration: declaration_specifiers declarator   {  }
    | declaration_specifiers    {  }
    ;

identifier_list: IDENTIFIER    {  }          
    | identifier_list COMMA IDENTIFIER   {  }
    ;

type_name: specifier_qualifier_list   {  }
    ;

initializer: assignment_expression   { $$=$1->loc; }
    | CURLY_BRACKET_OPEN initializer_list CURLY_BRACKET_CLOSE  {  }
    | CURLY_BRACKET_OPEN initializer_list COMMA CURLY_BRACKET_CLOSE  {  }
    ;

initializer_list: designation_opt initializer  {  }
    | initializer_list COMMA designation_opt initializer   {  }
    ;

designation_opt: %empty   {  }
    | designation   {  }
    ;

designation: designator_list ASSIGN   {  }
    ;

designator_list: designator    {  }
    | designator_list designator   {  }
    ;

designator: SQUARE_BRACKET_OPEN constant_expression SQUARE_BRACKET_CLOSE   {  }
    | DOT IDENTIFIER {  }
    ;



statement: labeled_statement   {  }
    | compound_statement   { $$=$1; }
    | expression_statement   
    { 
        $$=new Statement();
        $$->nextlist=$1->nextlist; 
    }
    | selection_statement   { $$=$1; }
    | iteration_statement   { $$=$1; }
    | jump_statement   { $$=$1; }
    ;

loop_statement: labeled_statement   {  }
    | expression_statement   
    { 
        $$=new Statement();
        $$->nextlist=$1->nextlist; 
    }
    | selection_statement   { $$=$1; }
    | iteration_statement   { $$=$1; }
    | jump_statement   { $$=$1; }
    ;

labeled_statement: IDENTIFIER COLON M statement   
    {  
        $$ = $4;
        Label *s = find_label($1->name);
        if(s!=nullptr){
            s->addr = $3;
            backpatch(s->nextlist,s->addr);
        }else{
            s = new Label($1->name);
            s->addr = nextinstr();
            s->nextlist = makelist($3);
            label_table.push_back(*s);
        }
    }
    | CASE constant_expression COLON statement   {  }
    | DEFAULT COLON statement   {  }
    ;

compound_statement: CURLY_BRACKET_OPEN X changetable block_item_list_opt CURLY_BRACKET_CLOSE   
    { 
        $$=$4;
        changeTable(ST->parent); 
    }
    ;

block_item_list_opt: %empty  { $$=new Statement(); }
    | block_item_list   { $$=$1; }
    ;

block_item_list: block_item   { $$=$1; }            
    | block_item_list M block_item    
    { 
        $$=$3;
        backpatch($1->nextlist,$2);
    }
    ;

block_item: declaration   { $$=new Statement(); }
    | statement   { $$=$1; }                
    ;

expression_statement: expression SEMICOLON {$$=$1;}            
    | SEMICOLON {$$ = new Expression();}
    ;

selection_statement: IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N %prec THEN
    {
        backpatch($4->nextlist, nextinstr());
        convertIntToBool($3);
        $$ = new Statement();
        backpatch($3->truelist, $6);
        list<int> temp = merge($3->falselist, $7->nextlist);
        $$->nextlist = merge($8->nextlist, temp);
    }
    | IF ROUND_BRACKET_OPEN expression N ROUND_BRACKET_CLOSE M statement N ELSE M statement
    {
        backpatch($4->nextlist, nextinstr());        
        convertIntToBool($3);
        $$ = new Statement();
        backpatch($3->truelist, $6);
        backpatch($3->falselist, $10);
        list<int> temp = merge($7->nextlist, $8->nextlist);
        $$->nextlist = merge($11->nextlist,temp);    
    }
    | SWITCH ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE statement {    }
    ;

iteration_statement: WHILE W ROUND_BRACKET_OPEN X changetable M expression ROUND_BRACKET_CLOSE M loop_statement
    {    
        $$ = new Statement();
        convertIntToBool($7);
        backpatch($10->nextlist, $6);    
        backpatch($7->truelist, $9);    
        $$->nextlist = $7->falselist;
        
        string str=convertIntToString($6);        
        emit("goto",str);    
        loop_name = "";
        changeTable(ST->parent);
    }
    |
    WHILE W ROUND_BRACKET_OPEN X changetable M expression ROUND_BRACKET_CLOSE CURLY_BRACKET_OPEN M block_item_list_opt CURLY_BRACKET_CLOSE
    {    
        $$ = new Statement();
        convertIntToBool($7);
        backpatch($11->nextlist, $6);    
        backpatch($7->truelist, $10);    
        $$->nextlist = $7->falselist;
        
        string str=convertIntToString($6);        
        emit("goto",str);    
        loop_name = "";
        changeTable(ST->parent);
    }
    | DO D M loop_statement M WHILE ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE SEMICOLON
    {
        $$ = new Statement();
        convertIntToBool($8);
        backpatch($8->truelist, $3);                        
        backpatch($4->nextlist, $5);                        
        $$->nextlist = $8->falselist;
        loop_name = "";
    }
    | DO D CURLY_BRACKET_OPEN M block_item_list_opt CURLY_BRACKET_CLOSE M WHILE ROUND_BRACKET_OPEN expression ROUND_BRACKET_CLOSE SEMICOLON
    {
        $$ = new Statement();
        convertIntToBool($10);
        backpatch($10->truelist, $4);                        
        backpatch($5->nextlist, $7);                        
        $$->nextlist = $10->falselist;
        loop_name = "";
    }
    | FOR F ROUND_BRACKET_OPEN X changetable declaration M expression_statement M expression N ROUND_BRACKET_CLOSE M loop_statement
    {
        $$ = new Statement();        
        convertIntToBool($8);
        backpatch($8->truelist, $13);    
        backpatch($11->nextlist, $7);    
        backpatch($14->nextlist, $9);    
        string str=convertIntToString($9);
        emit("goto", str);                
        $$->nextlist = $8->falselist;    
        loop_name = "";
        changeTable(ST->parent);
    }
    | FOR F ROUND_BRACKET_OPEN X changetable expression_statement M expression_statement M expression N ROUND_BRACKET_CLOSE M loop_statement
    {
        $$ = new Statement();        
        convertIntToBool($8);
        backpatch($8->truelist, $13);    
        backpatch($11->nextlist, $7);    
        backpatch($14->nextlist, $9);    
        string str=convertIntToString($9);
        emit("goto", str);                
        $$->nextlist = $8->falselist;    
        loop_name = "";
        changeTable(ST->parent);
    }
    | FOR F ROUND_BRACKET_OPEN X changetable declaration M expression_statement M expression N ROUND_BRACKET_CLOSE M CURLY_BRACKET_OPEN block_item_list_opt CURLY_BRACKET_CLOSE
    {
        $$ = new Statement();        
        convertIntToBool($8);
        backpatch($8->truelist, $13);    
        backpatch($11->nextlist, $7);    
        backpatch($15->nextlist, $9);    
        string str=convertIntToString($9);
        emit("goto", str);                
        $$->nextlist = $8->falselist;    
        loop_name = "";
        changeTable(ST->parent);
    }
    | FOR F ROUND_BRACKET_OPEN X changetable expression_statement M expression_statement M expression N ROUND_BRACKET_CLOSE M CURLY_BRACKET_OPEN block_item_list_opt CURLY_BRACKET_CLOSE
    {    
        $$ = new Statement();        
        convertIntToBool($8);
        backpatch($8->truelist, $13);    
        backpatch($11->nextlist, $7);    
        backpatch($15->nextlist, $9);    
        string str=convertIntToString($9);
        emit("goto", str);                
        $$->nextlist = $8->falselist;    
        loop_name = "";
        changeTable(ST->parent);
    }
    ;

jump_statement: GOTO IDENTIFIER SEMICOLON { 
        $$ = new Statement();
        Label *l = find_label($2->name);
        if(l){
            emit("goto","");
            list<int>lst = makelist(nextinstr());
            l->nextlist = merge(l->nextlist,lst);
            if(l->addr!=-1)
                backpatch(l->nextlist,l->addr);
        } else {
            l = new Label($2->name);
            l->nextlist = makelist(nextinstr());
            emit("goto","");
            label_table.push_back(*l);
        }
    }           
    | CONTINUE SEMICOLON { $$ = new Statement(); }              
    | BREAK SEMICOLON { $$ = new Statement(); }
    | RETURN expression SEMICOLON               
    {
        $$ = new Statement();    
        emit("return",$2->loc->name);
    }
    | RETURN SEMICOLON 
    {
        $$ = new Statement();    
        emit("return","");                         
    }
    ;



translation_unit: external_declaration { }
    | translation_unit external_declaration { } 
    ;

external_declaration: function_definition {  }
    | declaration   {  }
    ;
                          
function_definition:declaration_specifiers declarator declaration_list_opt changetable CURLY_BRACKET_OPEN block_item_list_opt CURLY_BRACKET_CLOSE  
    {
        int next_instr=0;         
        ST->parent=globalST;
        table_count = 0;
        label_table.clear();
        changeTable(globalST);
    }
    ;

declaration_list: declaration   {  }
    | declaration_list declaration    {  }
    ;                                                                                

declaration_list_opt: %empty {  }
    | declaration_list   {  }
    ;

%%

void yyerror(string s) {
    cout<<s<<endl;
}