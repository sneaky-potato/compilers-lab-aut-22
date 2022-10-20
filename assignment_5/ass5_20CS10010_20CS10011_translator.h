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
#define _CHAR_SIZE 1
#define _INT_SIZE 4
#define _POINT_SIZE 4
#define _FLOAT_SIZE 8

class Symbol;
class Quad;
class SymbolTable;
class QuadArray;
class SymbolType;
class Expression;

extern SymbolTable* ST;
extern SymbolTable* globalST;
extern Symbol* currSymbol;
extern QuadArray QA;
extern long long int STCount;
extern bool debugOn;
extern string loopName;

extern char* yytext;
extern int yyparse();

class Symbol
{
	public:
        string name;
        SymbolType* type;
        string val;
        int size;
        int offset;
        SymbolTable* nested;
          
        Symbol(string , string t = "int", SymbolType* ptr = NULL, int width = 0);
        Symbol* update(SymbolType*);
};

class SymbolType 
{
public:
    string type;
    int width;
    SymbolType* arrtype;
    
    SymbolType(string, SymbolType* ptr = NULL, int width = 1);
};

class SymbolTable 
{
public:
    string name;
    int count;
    list<Symbol> table;
    SymbolTable* parent;
    
    SymbolTable(string name="NULL");

    Symbol* lookup (string);
    static Symbol* gentemp (SymbolType*, string init = "");

    void print();
    void update();
};

class Quad 
{
public:
    string res;
    string op;
    string arg1;
    string arg2;
    
    Quad(string, string, string op = "=", string arg2 = "");			
    Quad(string, int, string op = "=", string arg2 = "");				
    Quad(string, float, string op = "=", string arg2 = "");			
    
    void print();	
};

class QuadArray 
{
public:
    vector<Quad> Array;
    void print();
};

struct Expression {
    Symbol* loc;
    string type;
    list<int> truelist;
    list<int> falselist;
    list<int> nextlist;
};

struct Array {
    string atype;
    Symbol* loc;
    Symbol* Array;
    SymbolType* type;
};

struct Statement {
    list<int> nextlist;
};

void emit(string, string, string arg1="", string arg2 = "");  
void emit(string, string, int, string arg2 = "");		  
void emit(string, string, float , string arg2 = "");   

list<int> makelist (int);
list<int> merge (list<int> &l1, list<int> &l2);
void backpatch (list<int>, int);

bool typecheck(Symbol* &s1, Symbol* &s2);
bool typecheck(SymbolType* t1, SymbolType* t2);

string convertIntToString(int);
string convertFloatToString(float);
Expression* convertIntToBool(Expression*);
Expression* convertBoolToInt(Expression*);

Symbol* convertType(Symbol*, string);
int computeSize(SymbolType*);
void changeTable(SymbolTable*);

int nextinstr();

string checkType(SymbolType*);

#endif
