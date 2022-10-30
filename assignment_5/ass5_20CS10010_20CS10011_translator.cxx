#include "ass5_20CS10010_20CS10011_translator.h"

//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 5                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

QuadArray QA;
SymbolTable* ST;
bool debugOn;
SymbolTable* globalST;
Symbol* currSymbol;
long long int STCount;
string loopName;  

Symbol::Symbol(string name, string typeString, SymbolType* _type, int width) 
{
    this->name = name;
    type = new SymbolType(typeString, _type, width);
    size = computeSize(type);
    this->offset = 0;
    this->val = "-";
    this->nested = NULL;
}

Symbol* Symbol::update(SymbolType* _type) 
{
    type = _type;                                                                                        // Update the new type
    this->size = computeSize(_type);                                                                   // new size
    return this;                                                                                   // return the same variable	
}

SymbolType::SymbolType(string typeString, SymbolType* _type, int width)
{
    this->typeString = typeString;
    this->type = _type;
    this->width = width;
}

SymbolTable::SymbolTable(string name) 
{
    this->name = name;
    this->count = 0;
}

Symbol* SymbolTable::lookup(string name) {
    // Start searching for the symbol in the symbol table
    for(list<Symbol>::iterator it = table.begin(); it != table.end(); it++) {
        if(it->name == name) {
            return &(*it);
        }
    }

    // If not found, go up the hierarchy to search in the parent symbol tables
    Symbol* s = NULL;
    if(this->parent != NULL) {
        s = this->parent->lookup(name);
    }

    if(ST == this && s == NULL) {
        // If the symbol is not found, create the symbol, add it to the symbol table and return a pointer to it
        Symbol* sym = new Symbol(name);
        table.push_back(*sym);
        return &(table.back());
    }
    else if(s != NULL) {
        return s;
    }

    return NULL;
}

Symbol* SymbolTable::gentemp(SymbolType* t, string initValue) 
{
    string name = "t" + convertIntToString(ST->count++);
    Symbol* sym = new Symbol(name);
    sym->type = t;
    sym->val = initValue;
    sym->size = computeSize(t);

    ST->table.push_back(*sym);

    return &(ST->table.back());
}

void SymbolTable::update() {
    list<SymbolTable*> tableList;
    int offset;

    // Update the offsets of the symbols based on their sizes
    for(list<Symbol>::iterator it = table.begin(); it != table.end(); it++) {
        if(it == table.begin()) {
            it->offset = 0;
            offset = it->size;
        }
        else {
            it->offset = offset;
            offset = it->offset + it->size;
        }

        if(it->nested != NULL) {
            tableList.push_back(it->nested);
        }
    }

    // Recursively call the update function to update the offsets of symbols of the nested symbol tables
    for(list<SymbolTable*>::iterator iter = tableList.begin(); iter != tableList.end(); iter++) {
        (*iter)->update();
    }
}

Quad::Quad(string res, string arg1_, string operation, string arg2_) {
    this->res = res;
    this->arg1 = arg1_;
    this->arg2 = arg2_;
    this->op = operation;
}

Quad::Quad(string res, int arg1_, string operation, string arg2_) {
    this->res = res;
    this->op = operation;
    this->arg2 = arg2;
    this->arg1 = convertIntToString(arg1_);
}

Quad::Quad(string res, float arg1_, string operation, string arg2_) {
    this->res = res;
    this->op = operation;
    this->arg2 = arg2;
    this->arg1 = convertFloatToString(arg1_);
}

void Quad::print() {
    if(op == "=")       // Simple assignment
        cout << res << " = " << arg1;
    else if(op == "*=")
        cout << "*" << res << " = " << arg1;
    else if(op == "[]=")
        cout << res << "[" << arg1 << "]" << " = " << arg2;
    else if(op == "=[]")
        cout << res << " = " << arg1 << "[" << arg2 << "]";
    else if(op == "goto" || op == "param" || op == "return")
        cout << op << " " << res;
    else if(op == "call")
        cout << res << " = " << "call " << arg1 << ", " << arg2;
    else if(op == "label")
        cout << res << ": ";

    // Binary Operators
    else if(op == "+" || op == "-" || op == "*" || op == "/" || op == "%" || op == "^" || op == "|" || op == "&" || op == "<<" || op == ">>")
        cout << res << " = " << arg1 << " " << op << " " << arg2;

    // Relational Operators
    else if(op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=")
        cout << "if " << arg1 << " " << op << " " << arg2 << " goto " << res;

    // Unary operators
    else if(op == "= &" || op == "= *" || op == "= -" || op == "= ~" || op == "= !")
        cout << res << " " << op << arg1;

    else
        cout << "Unknown Operator";
}

void QuadArray::print() {
    for(int i=0;i<60;i++)  std::cout<<"__";
    std::cout<<std::endl;

    std::cout<<"THREE ADDRESS CODE: "<<std::endl;                                                       // print all the three address codes TAC
    for(int i=0;i<60;i++) std::cout<<"__";
    std::cout<<std::endl;    
    
    int j=0;
    vector<Quad>::iterator it;                                                                         // vector iterator to iterate through all the TAC in the array
    
    it=Array.begin();
    while(it!=Array.end()) 
    {
        if(it->op=="label")                                                                             // print the label if it is the operator 
        {
            std::cout<<std::endl<<j<<": ";
            it->print();
        }
        else {                                                                                          // otherwise give 4 spaces and then print
            std::cout<<j<<": ";
            std::cout << "    ";
            it->print();
        }
        it++;j++;
    }
    for(int i=0;i<65;i++) std::cout<<"__";                                                              // End of printing of the TAC
    std::cout<<std::endl;
}

string convertIntToString(int i) {
    return to_string(i);
}

string convertFloatToString(float f) {
    return to_string(f);
}

int computeSize(SymbolType *t)                                                                          // calculate size function
{
    if(t->typeString.compare("void")==0) return _VOID_SIZE;
    else if(t->typeString.compare("char")==0) return _CHAR_SIZE;
    else if(t->typeString.compare("int")==0) return _INT_SIZE;
    else if(t->typeString.compare("float")==0) return _FLOAT_SIZE;
    else if(t->typeString.compare("ptr")==0) return _POINT_SIZE;
    else if(t->typeString.compare("func")==0) return _FUNC_SIZE;
    else if(t->typeString.compare("arr")==0) return t->width*computeSize(t->type);                         // recursive for arrays (Multidimensional arrays)
    else return -1;
}

int main()
{
    STCount = 0;                            // Initialize STCount to 0
    globalST = new SymbolTable("Global");   // Create global symbol table
    ST = globalST;                   // Make global symbol table the currently active symbol table
    loopName = "";

    yyparse();

    globalST->update();
    QA.print();       // Print Three Address Code
    cout << endl;
    globalST->print();      // Print symbol tables

    return 0;
}