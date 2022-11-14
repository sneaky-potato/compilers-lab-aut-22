#include "ass5_20CS10010_20CS10011_translator.h"

//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 5                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

#include <bits/stdc++.h>
using namespace std;                                                     

// Condtructor for SymbolTable
SymbolType::SymbolType(string type,SymbolType* arrtype,int width)                                 
{
    this->type = type;
    this->width = width;
    this->arrtype= arrtype;
}

// Condtructor for Symbol
Symbol::Symbol(string name, string t, SymbolType* arrtype, int width) 
{
    this->name = name;
    // Generate type of symbol
    type = new SymbolType(t,arrtype,width);         
    // find the size from the type                                               
    size = computeSize(type);                                                                      
    offset = 0;                                                                                    
    val = "-";                                                                                     
    nested = NULL;                                                                                 
}

// Condtructor for quad
quad::quad(string res,string arg1,string op,string arg2)
{
    this->op=op;
    this->arg1=arg1;
    this->arg2=arg2;
    this->res=res;
}

// Condtructor for quad overloaded
quad::quad(string res,int arg1,string op,string arg2)
{   
    this->op=op;
    //first convert to int then copy
    this->arg1=convertIntToString(arg1);
    this->arg2=arg2;
    this->res=res;    
}

// Condtructor for quad overloaded
quad::quad(string res,float arg1,string op,string arg2)
{
    this->op=op;
    // first convert to float then copy
    this->arg1=convertFloatToString(arg1);
    this->arg2=arg2;
    this->res=res;
}

// print function for quads
void quad::print() 
{
    int next_instr=0;   
    if(op=="+") this->print_generic_tac();
    else if(op=="-") this->print_generic_tac();
    else if(op=="*") this->print_generic_tac();
    else if(op=="/") this->print_generic_tac();
    else if(op=="%") this->print_generic_tac();
    else if(op=="|") this->print_generic_tac();
    else if(op=="^") this->print_generic_tac();
    else if(op=="&") this->print_generic_tac();

    else if(op=="==") this->print_if_jump_tac();
    else if(op=="!=") this->print_if_jump_tac();
    else if(op=="<=") this->print_if_jump_tac();
    else if(op=="<") this->print_if_jump_tac();
    else if(op==">") this->print_if_jump_tac();
    else if(op==">=") this->print_if_jump_tac();
    else if(op=="goto") std::cout<<"goto "<<res;

    else if(op==">>") this->print_generic_tac();
    else if(op=="<<") this->print_generic_tac();

    else if(op=="=") std::cout<<res<<" = "<<arg1 ;  

    else if(op=="=&") std::cout<<res<<" = &"<<arg1;
    else if(op=="=*") std::cout<<res<<" = *"<<arg1;
    else if(op=="*=") std::cout<<"*"<<res<<" = "<<arg1;
    else if(op=="uminus") std::cout<<res<<" = -"<<arg1;
    else if(op=="~") std::cout<<res<<" = ~"<<arg1;
    else if(op=="!") std::cout<<res<<" = !"<<arg1;

    else if(op=="=[]") std::cout<<res<<" = "<<arg1<<"["<<arg2<<"]";
    else if(op=="[]=") std::cout<<res<<"["<<arg1<<"]"<<" = "<< arg2;
    else if(op=="return") std::cout<<"return "<<res;
    else if(op=="param") std::cout<<"param "<<res;
    else if(op=="call") std::cout<<res<<" = "<<"call "<<arg1<<", "<<arg2;
    else if(op=="Label") std::cout<<res<<": ";
    else std::cout<<"Can't find the operator"<<op;      
    std::cout<<std::endl;
}

// auxilliary functions for printing quad
void quad::print_generic_tac()                                                                           
{
    std::cout<<res<<" = "<<arg1<<" "<<op<<" "<<arg2;    
}

// auxilliary functions for printing quad
void quad::print_if_jump_tac()                                                                               
{
    std::cout<<"if "<<arg1<< " "<<op<<" "<<arg2<<" goto "<<res; 
}

// Quad Array
quadArray Q;   

// Points to current symbol table                                                                                 
SymbolTable* ST;  

bool debug_on;                                                                                     
string var_type;                                                                                   
SymbolTable* globalST;                                                                                
SymbolTable* parST;                                                                                   
Symbol* currSymbolPtr;                                                                                
long long int table_count;                                                                         
string loop_name;                                                                                  
vector<Label>label_table; 

// update function to Symbol
Symbol* Symbol::update(SymbolType* t) 
{
    type=t; 
    // recompute size of new symbol                                                                                       
    this->size=computeSize(t);                                                                   
    return this;                                                                                   
}

// Constructor for Label
Label::Label(string _name, int _addr):name(_name),addr(_addr){}

// Constructor for SymbolTable
SymbolTable::SymbolTable(string name)                                                                   
{
    this->name=name;                                                                             
    count=0;                                                                                      
}

// lookup function for SymbolTable
Symbol* SymbolTable::lookup(string name)                                                
{
    Symbol* symbol;
    list<Symbol>::iterator it;                                                                        
    it=table.begin();  
    // iterate through whole table                                                                            
    while(it!=table.end()) 
    {
        if(it->name==name) 
            return &(*it);                                                                         
        it++;                                                                                      
    }

    Symbol *ptr = nullptr;
    if(this->parent)ptr = this->parent->lookup(name);
    if(ST == this and !ptr){
        symbol = new Symbol(name);
        table.push_back(*symbol);                                                                  
        return &table.back();                                                                     
    } else if(ptr) return ptr;
    return nullptr;
}

// update function for SymbolTable
void SymbolTable::update()                                                                           
{
    list<SymbolTable*> tb;                                                                           
    int off;
    list<Symbol>::iterator it;                                                                        
    it=table.begin();
    // iterate through whole table
    while(it!=table.end()) 
    {
        if(it==table.begin()) 
        {
            // set first offset to 0
            it->offset=0;                                                                           
            off=it->size;
        }
        else 
        {
            // increment accordingly
            it->offset=off;
            off=it->offset+it->size;                                                                
        }
        if(it->nested!=NULL) 
            tb.push_back(it->nested);
        it++;
    }

    list<SymbolTable*>::iterator it1;                                                                  
    it1=tb.begin();
    while(it1 !=tb.end())                                                                            
    {
        (*it1)->update();
        it1++;
    }
}

// print function to quadArray
void quadArray::print()                                                                               
{
    std::cout<<"THREE ADDRESS CODE : "<<std::endl;                                                       
    for(int i=0;i<60;i++) std::cout<<"**";
    std::cout<<std::endl;    
    
    int j=0;
    vector<quad>::iterator it;                                                                        
    it=Array.begin();
    // iterate through whole array
    while(it!=Array.end()) 
    {
        if(it->op=="Label")                                                                     
        {
            std::cout<<std::endl<<j<<": ";
            it->print();
        }
        else {                                                                                          
            std::cout<<j<<": ";
            generateSpaces(4);
            it->print();
        }
        it++;j++;
    }
    for(int i=0;i<65;i++) std::cout<<"**";                                                             
    std::cout<<std::endl;
}

// overloaded emit functions to quad
void emit(string op, string res, string arg1, string arg2) 
{
	quad *q1= new quad(res,arg1,op,arg2);
	Q.Array.push_back(*q1);
}

void emit(string op, string res, int arg1, string arg2) 
{
    quad *q2= new quad(res,arg1,op,arg2);
    Q.Array.push_back(*q2);
}

void emit(string op, string res, float arg1, string arg2) 
{
    quad *q3= new quad(res,arg1,op,arg2);
    Q.Array.push_back(*q3);
}

// generate new temporary variable
Symbol* gentemp(SymbolType* t, string str_new) 
{                                                                                                      
    string tmp_name = "t"+convertIntToString(ST->count++);                                              
    Symbol* s = new Symbol(tmp_name);
    s->type = t;
    s->size=computeSize(t);                                                                          
    s->val = str_new;
    ST->table.push_back(*s);                                                                            
    return &ST->table.back();
}

// find_label function for Label table
Label* find_label(string _name){
    for(vector<Label>::iterator it=label_table.begin(); it!=label_table.end(); it++){
        if(it->name==_name)return &(*it);
    }
    return nullptr;
}

// backpatch function
void backpatch(list<int> list1,int addr)                                                               
{
    string str=convertIntToString(addr);                                                                
    list<int>::iterator it;
    it=list1.begin();
    
    while( it!=list1.end()) 
    {
        Q.Array[*it].res=str;                                                                          
        it++;
    }
}

list<int> makelist(int init) 
{
    list<int> newlist(1,init);                                                                          
    return newlist;                                                                                     
}

list<int> merge(list<int> &a,list<int> &b)
{
    a.merge(b);                                                                                        
    return a;                                                                                           
}

// Conversion functions

string convertIntToString(int a)     
{
    return to_string(a);
}

string convertFloatToString(float x)                                                                    
{
    std::ostringstream buff;
    buff<<x;
    return buff.str();
}

Expression* convertBoolToInt(Expression* e)                                                           
{	
	if(e->type=="bool") 
    {
        e->loc=gentemp(new SymbolType("int"));                                                        
        backpatch(e->truelist,nextinstr());
        emit("=",e->loc->name,"true");
        int p=nextinstr()+1;
        string str=convertIntToString(p);
        emit("goto",str);
        backpatch(e->falselist,nextinstr());
        emit("=",e->loc->name,"false");
    }
    return e;
}

Expression* convertIntToBool(Expression* e)                                                          
{
    if(e->type!="bool")                
    {
        e->falselist=makelist(nextinstr());                                                             
        emit("==","",e->loc->name,"0");                                                                 
        e->truelist=makelist(nextinstr());                                                              
        emit("goto","");
    }
    return e;
}

Symbol* convertType(Symbol* s, string rettype)                                                                
{
	Symbol* temp=gentemp(new SymbolType(rettype));	
    if(s->type->type=="float")                                                                        
    {
        if(rettype=="int")                                                                              
        {
            emit("=",temp->name,"float2int("+s->name+")");
            return temp;
        }
        else if(rettype=="char")                                                                       
        {
            emit("=",temp->name,"float2char("+s->name+")");
            return temp;
        }
        return s;
    }
    else if(s->type->type=="int")                                                                    
    {
        if(rettype=="float")                                                                          
        {
            emit("=",temp->name,"int2float("+s->name+")");
            return temp;
        }
        else if(rettype=="char")                                                                        
        {
            emit("=",temp->name,"int2char("+s->name+")");
            return temp;
        }
        return s;
    }
    else if(s->type->type=="char")                                                                   
    {
        if(rettype=="int")                                                                             
        {
            emit("=",temp->name,"char2int("+s->name+")");
            return temp;
        }
        if(rettype=="double")                                                                           
        {
            emit("=",temp->name,"char2double("+s->name+")");
            return temp;
        }
        return s;
    }
    return s;
}

// Update to new table function
void changeTable(SymbolTable* newtable)                                                                   
{
    ST = newtable;
} 

bool compareSymbolType(Symbol*& s1,Symbol*& s2)                                                              
{
    SymbolType* type1=s1->type;                                                                        
    SymbolType* type2=s2->type;                                                                         
    int flag=0;
    
    if(compareSymbolType(type1,type2)) flag=1;                                                          
    else if(s1=convertType(s1,type2->type)) flag=1;                                                     
    else if(s2=convertType(s2,type1->type)) flag=1;                                                     
    
    if(flag)return true;                                                                               
    else return false;                                                                                  
}

bool compareSymbolType(SymbolType* t1,SymbolType* t2)                                                   
{
    int flag=0;
    if(t1==NULL && t2==NULL) flag=1;                                                                  
    else if(t1==NULL || t2==NULL || t1->type!=t2->type) flag=2;                                        
    
    if(flag==1) return true;
    else if(flag==2) return false;
    else return compareSymbolType(t1->arrtype,t2->arrtype);                                            
}



void generateSpaces(int n)                                                                              
{
    while(n--) std::cout<<" ";
}

int nextinstr() 
{
    return Q.Array.size();                                                                              
}

int computeSize(SymbolType* t)                                                                          
{
    if(t->type.compare("void")==0) return _VOID_SIZE;
    else if(t->type.compare("char")==0) return _CHAR_SIZE;
    else if(t->type.compare("int")==0) return _INT_SIZE;
    else if(t->type.compare("float")==0) return _FLOAT_SIZE;
    else if(t->type.compare("ptr")==0) return _POINT_SIZE;
    else if(t->type.compare("func")==0) return _FUNC_SIZE;
    else if(t->type.compare("arr")==0) return t->width*computeSize(t->arrtype);                         
    else return -1;
}

string printType(SymbolType* t)                                                                         
{
    if(t==NULL) return "null";
    if(t->type.compare("void")==0)	return "void";
    else if(t->type.compare("char")==0) return "char";
    else if(t->type.compare("int")==0) return "int";
    else if(t->type.compare("float")==0) return "float";
    else if(t->type.compare("ptr")==0) return "ptr("+printType(t->arrtype)+")";                
    else if(t->type.compare("arr")==0) 
    {
        string str=convertIntToString(t->width);                                                        
        return "arr("+str+","+printType(t->arrtype)+")";
    }
    else if(t->type.compare("func")==0) return "func";
    else if(t->type.compare("block")==0) return "block";
    else return "NA";
}

void SymbolTable::print()                                                                               
{
    int next_instr=0;
    list<SymbolTable*> tb;                                                                               
    for(int t1=0;t1<60;t1++) std::cout<<"**";                                                        
    std::cout<<std::endl;

    std::cout << "Name: " << this->name ;
    generateSpaces(53-this->name.length());
    std::cout << " Parent Table: ";                                                                    
    if((this->parent==NULL)) std::cout<<"NULL"<<std::endl;                                           
    else std::cout<<this->parent->name<<std::endl;                                                  
    for(int x=0; x<60; x++) std::cout<<"__";                                                          
    std::cout<<std::endl;
    
    //Print the filed names for the table
    std::cout<<"Name";                                                                               
    generateSpaces(36);

    std::cout<<"Type";                                                                                
    generateSpaces(16);

    std::cout<<"Init Value";                                                                     
    generateSpaces(7);

    std::cout<<"Size";                                                                                
    generateSpaces(11);

    std::cout<<"Offset";                                                                              
    generateSpaces(9);

    std::cout<<"Nested"<<std::endl;                                                                   
    generateSpaces(100);
    std::cout<<std::endl;

    for(list<Symbol>::iterator it=table.begin(); it!=table.end(); it++) {                               
    
        std::cout << it->name;                                                                      
        generateSpaces(40-it->name.length());

        string rec_type=printType(it->type);                                                          
        std::cout << rec_type;
        generateSpaces(20-rec_type.length());

        std::cout << it->val;                                                                         
        generateSpaces(20-it->val.length());

        std::cout<<it->size;                                                                         
        generateSpaces(15-to_string(it->size).length());

        std::cout<<it->offset;                                                                       
        generateSpaces(15-to_string(it->offset).length());

        if(it->nested==NULL) {                                                                       
            std::cout<<"NULL"<<std::endl;
        }
        else {
            std::cout<<it->nested->name<<std::endl; 
            tb.push_back(it->nested);                                                                 
        }
    }
 
    for(int i=0;i<60;i++) std::cout<<"--";
    std::cout<<"\n\n";
    for(list<SymbolTable*>::iterator it=tb.begin(); it !=tb.end();++it) 
    {
        (*it)->print();
    }
}

// driver code
int main()
{
    // initial assignments
    label_table.clear();

    table_count = 0;                                                                                    
    debug_on= 0;      

    // global table declaration                                                                                  
    globalST=new SymbolTable("Global");                                                                    
    ST=globalST;
    parST=nullptr;
    // start the block with ""
    loop_name = "";

    // parsing the file
    yyparse();                                                                                         
    globalST->update();                                                                                
    std::cout<<"\n";

    // print quadArray and SymbolTable
    Q.print();                                                                                         
    globalST->print();                                                                                 
};
