//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 5                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

#ifndef __PARSER_H
#define __PARSER_H

#include <iostream>
#include <vector>
#include <list>

using namespace std;

#define _VOID_SIZE 0
#define _FUNC_SIZE 0
#define _CHAR_SIZE 1
#define _INT_SIZE 4
#define _POINT_SIZE 4
#define _FLOAT_SIZE 8

extern char* yytext;
extern int yyparse();
//Class Declarations

class Symbol;
class Label; 
class SymbolTable;                                                                                                                                        
     
class quad;                                                                       
class quadArray;

class SymbolType;                                                                          
class Expression;                                                                         

typedef Symbol s;
typedef SymbolType symtyp;
typedef Expression* Exps;

// external global variables
// current Symbol Table
extern SymbolTable* ST;                
// Global Symbol Table                                                       
extern SymbolTable* globalST;      
// Parent of the current Symbol Table                                                           
extern SymbolTable* parST;                  
// latest encountered symbol                                                  
extern s* currSymbolPtr;                                                                  
extern quadArray Q;                                                                        
// count of nested tables                                                             
extern long long int table_count;                                                          
extern bool debug_on;                                                                      
extern string loop_name;             
// table to store the labels                                                      
extern vector<Label>label_table;          

// Label symbol 
class Label                                                                                
{
public:
    int addr;                                                                          
    list<int> nextlist; 
    string name;   

    Label(string _name, int _addr = -1);                                               
};


// Structure of any element of the symbol table
class Symbol 
{                                                                                          
public:
    int size;                                                                          
    int offset; 
    string name;                                                                       
    SymbolType *type;                                                                                                                                         
    SymbolTable* nested;        
    // initial value if given                                                          
    string val;         
    Symbol* update(SymbolType*);                                                               
      
    Symbol (string , string t="int", SymbolType* ptr = NULL, int width = 0);                                                             
};

//symbol type class
class SymbolType 
{                                                                                           
public:
    string type;              
    // size of Array if found else 1 by default                                                          
    int width;                                                                          
    SymbolType* arrtype;                                                               
    
    SymbolType(string , SymbolType* ptr = NULL, int width = 1);                         
};


// The actual Symbol Table

class SymbolTable 
{                                                                                           
public:
    string name;           
    //count of temps                                                            
    int count;                                                                          
    list<Symbol> table;                                                                    
    SymbolTable* parent;                                                                   
    
    SymbolTable (string name="NULL");                                                      
    s* lookup (string);                                                                
    void print();                                                                      
    void update();                                                                      
};

//  structure of quad element

class quad 
{                                                                                            
public:
    string res;                                                                         
    string op;                                                                           
    string arg1;                                                                         
    string arg2;                                                                           
    //constructors                  
    quad (string , string , string op = "=", string arg2 = "");         
    quad (string , int , string op = "=", string arg2 = "");                
    quad (string , float , string op = "=", string arg2 = "");  
    //for printing
    void print();	
    void print_generic_tac();                                                                       
    void print_if_jump_tac();                                                                        
};

// Defination of the quad array type
class quadArray 
{                                                                                            
public:
    vector<quad> Array;                                                                 
    void print();                                                                        
};

//  expression type
struct Expression {
    // pointer to the symbol table entry
    s* loc;                                                                                  
    string type;                                                                             
    list<int> truelist;                                                                     
    list<int> falselist;                                                                   
    list<int> nextlist;                                                                      
};

//  array type
struct Array {
    //either ptr or array
    string atype;        
    // Location used to compute address of Array                                                                    
    s* loc;      
    // pointer to the symbol table entry                                                                            
    s* Array;                                                                               
    SymbolType* type;                                                                        
};

struct Statement {
    list<int> nextlist;                                                                     
};

//Type checking and conversion
string convertIntToString(int);                                                              
string convertFloatToString(float);                                                          
Exps convertIntToBool(Exps);                                                                 
Exps convertBoolToInt(Exps);  

//Overloaded emit functions
void emit(string , string , string arg1="", string arg2 = "");  
void emit(string , string , int, string arg2 = "");		  
void emit(string , string , float , string arg2 = "");   

//generates a temporary variable in a sybol table and return a ponter to it
s* gentemp (SymbolType* , string init = "");

//  Backpatching
void backpatch (list <int> , int );                                                           
list<int> makelist (int );                                                                   
list<int> merge (list<int> &l1, list <int> &l2);                                             

//  Other helper functions required for TAC generation
string printType(SymbolType *);                                                              
void generateSpaces(int);

Label* find_label(string name);                                

// type conversion
s* convertType(Symbol*, string);            
//calculate size of symbol type                                                    
int computeSize (SymbolType *);                                                             
// change current table
void changeTable (SymbolTable* );      

bool compareSymbolType(Symbol* &s1, Symbol* &s2);                                                 
bool compareSymbolType(SymbolType*, SymbolType*);                                          

int nextinstr();                                                                             

#endif