//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 6                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

#include "ass6_20CS10010_20CS10011_translator.h"
#include "y.tab.h"

extern quadArray globalQuadArray;
extern int nextInstruction;
map<int, int> mp_set;
stack<string> _parameter_stack;
stack<int> _type_stack;
stack<int> _offset_stack;
stack<int> _pointer_stack;
extern std::vector<string> vs;
extern std::vector<string> cs;
int add_off;

void symbolTable::mark_labels() {
    
    int count = 1;
    int i = 0;

    while (i < nextInstruction) {
        switch (globalQuadArray.quads[i].op)
        {
        case Q_GOTO:
        case Q_IF_EQUAL:
        case Q_IF_NOT_EQUAL:
        case Q_IF_EXPRESSION:
        case Q_IF_NOT_EXPRESSION:
        case Q_IF_LESS:
        case Q_IF_GREATER:
        case Q_IF_LESS_OR_EQUAL:
        case Q_IF_GREATER_OR_EQUAL:

            if (globalQuadArray.quads[i].result != "-1" && mp_set.find(stoi(globalQuadArray.quads[i].result)) == mp_set.end()) {
                mp_set[stoi(globalQuadArray.quads[i].result)] = count;
                count++;
            }
        }
        i++;
    }
}

void symbolTable::function_prologue(std::ofstream &sfile, int count) {
    sfile << "\n\t.globl\t" << name;
    sfile << "\n\t.type\t" << name << ", @function";
    sfile << "\n"
          << name << ":";
    sfile << "\n.LFB" << count << ":";
    sfile << "\n\tpushq\t%rbp";
    sfile << "\n\tmovq\t%rsp, %rbp";
    sfile << "\n\tsubq\t$" << -offset << ", %rsp";
}

void symbolTable::globalVar(std::ofstream &sfile) {
    int i = 0;
    while (i < symbolTabList.size())
    {
        if (symbolTabList[i]->name[0] != 't' && symbolTabList[i]->type != NULL && symbolTabList[i]->var_type != "func") {
            if (symbolTabList[i]->type->type == tp_int) {
                vs.push_back(symbolTabList[i]->name);
                if (symbolTabList[i]->isInitialized == false)
                    sfile << "\n\t.comm\t" << symbolTabList[i]->name << ",4,4";

                else {
                    sfile << "\n\t.globl\t" << symbolTabList[i]->name;
                    sfile << "\n\t.data";
                    sfile << "\n\t.align 4";
                    sfile << "\n\t.type\t" << symbolTabList[i]->name << ", @object";
                    sfile << "\n\t.size\t" << symbolTabList[i]->name << " ,4";
                    sfile << "\n"
                          << symbolTabList[i]->name << ":";
                    sfile << "\n\t.long " << symbolTabList[i]->_init_val._INT_INITVAL;
                }
            }
            if (symbolTabList[i]->type->type == tp_char) {
                cs.push_back(symbolTabList[i]->name);
                if (symbolTabList[i]->isInitialized == false)
                    sfile << "\n\t.comm\t" << symbolTabList[i]->name << ",1,1";
                else {
                    sfile << "\n\t.globl\t" << symbolTabList[i]->name;
                    sfile << "\n\t.data";
                    sfile << "\n\t.type\t" << symbolTabList[i]->name << ", @object";
                    sfile << "\n\t.size\t" << symbolTabList[i]->name << " ,1";
                    sfile << "\n"
                          << symbolTabList[i]->name << ":";
                    sfile << "\n\t.byte %c", symbolTabList[i]->_init_val._CHAR_INITVAL;
                }
            }
        }
        i++;
    }
    sfile << "\n\t.text";
}

void symbolTable::calcOffset() {
    int curr_offset = 0;
    int param_offset = 16;
    emptyArgList = 0;

    for (int i = (symbolTabList).size() - 1; i >= 0; i--) {
        if (symbolTabList[i]->isValid == false)
            continue;
        if (symbolTabList[i]->var_type == "param" && symbolTabList[i]->isMarked == false) {
            emptyArgList++;

            if (symbolTabList[i]->type && symbolTabList[i]->type->type == tp_arr) {
                if (symbolTabList[i]->type->width == -1)
                    symbolTabList[i]->isPointerArray = true;
                symbolTabList[i]->width = 8;
            }
            symbolTabList[i]->offset = curr_offset - symbolTabList[i]->width;
            curr_offset = curr_offset - symbolTabList[i]->width;
            symbolTabList[i]->isMarked = true;
        }
        if (emptyArgList == 6)
            break;
    }
    for (int i = 0; i < (symbolTabList).size(); i++) {
        if (symbolTabList[i]->isValid == false)
            continue;
        if (symbolTabList[i]->var_type != "return" && symbolTabList[i]->var_type != "param" && symbolTabList[i]->isMarked == false) {
            symbolTabList[i]->offset = curr_offset - symbolTabList[i]->width;
            curr_offset = curr_offset - symbolTabList[i]->width;
            symbolTabList[i]->isMarked = true;
        }
        else if (symbolTabList[i]->var_type == "param" && symbolTabList[i]->isMarked == false) {
            if (symbolTabList[i]->type && symbolTabList[i]->type->type == tp_arr) {
                if (symbolTabList[i]->type->width == -1)
                    symbolTabList[i]->isPointerArray = true;
                symbolTabList[i]->width = 8;
            }
            symbolTabList[i]->isMarked = true;
            emptyArgList++;
            symbolTabList[i]->offset = param_offset;
            param_offset = param_offset + symbolTabList[i]->width;
        }
    }
    offset = curr_offset;
}

string symbolTable::assignRegister(int type_of, int no) {
    string s = "NULL";
    if (type_of == tp_char) {
        switch (no)
        {
        case 0:
            s = "dil";
            break;
        case 1:
            s = "sil";
            break;
        case 2:
            s = "dl";
            break;
        case 3:
            s = "cl";
            break;
        case 4:
            s = "r8b";
            break;
        case 5:
            s = "r9b";
            break;
        }
    }
    else if (type_of == tp_int) {
        switch (no) {
        case 0:
            s = "edi";
            break;
        case 1:
            s = "esi";
            break;
        case 2:
            s = "edx";
            break;
        case 3:
            s = "ecx";
            break;
        case 4:
            s = "r8d";
            break;
        case 5:
            s = "r9d";
            break;
        }
    }
    else {
        switch (no) {
        case 0:
            s = "rdi";
            break;
        case 1:
            s = "rsi";
            break;
        case 2:
            s = "rdx";
            break;
        case 3:
            s = "rcx";
            break;
        case 4:
            s = "r8";
            break;
        case 5:
            s = "r9";
            break;
        }
    }
    return s;
}

int symbolTable::callFunction(std::ofstream &sfile) {
    int c = 0;
    sfile << "\n\tpushq %rbp";
    int count = 0;
    while (count < 6 && _parameter_stack.size()) {
        string p = _parameter_stack.top();
        int btp = _type_stack.top();
        int off = _offset_stack.top();
        int parr = _pointer_stack.top();
        _parameter_stack.pop();
        _type_stack.pop();
        _offset_stack.pop();
        _pointer_stack.pop();

        string temp_str = assignRegister(btp, count);
        if (temp_str != "NULL") {
            if (btp == tp_int)
                sfile << "\n\tmovl\t" << off << "(%rbp) , %" << temp_str;
            else if (btp == tp_char)
                sfile << "\n\tmovb\t" << off << "(%rbp), %" << temp_str;
            else if (btp == tp_arr && parr == 1)
                sfile << "\n\tmovq\t" << off << "(%rbp), %" << temp_str;
            else if (btp == tp_arr)
                sfile << "\n\tleaq\t" << off << "(%rbp), %" << temp_str;
            else
                sfile << "\n\tmovq\t" << off << "(%rbp), %" << temp_str;
            count++;
        }
    }
    while (_parameter_stack.size()) {
        string p = _parameter_stack.top();
        int btp = _type_stack.top();
        int off = _offset_stack.top();
        int parr = _pointer_stack.top();
        _parameter_stack.pop();
        _type_stack.pop();
        _offset_stack.pop();
        _pointer_stack.pop();

        if (btp == tp_int) {
            sfile << "\n\tsubq $4, %rsp";
            sfile << "\n\tmovl\t" << off << "(%rbp), %eax";
            sfile << "\n\tmovl\t%eax, (%rsp)";
            c += 4;
        }
        else if (btp == tp_arr && parr == 1) {
            sfile << "\n\tsubq $8, %rsp";
            sfile << "\n\tmovq\t" << off << "(%rbp), %rax";
            sfile << "\n\tmovq\t%rax, (%rsp)";
            c += 8;
        }
        else if (btp == tp_arr) {
            sfile << "\n\tsubq $8, %rsp";
            sfile << "\n\tleaq\t" << off << "(%rbp), %rax";
            sfile << "\n\tmovq\t%rax, (%rsp)";
            c += 8;
        }
        else if (btp == tp_char) {
            sfile << "\n\tsubq $4, %rsp";
            sfile << "\n\tmovsbl\t" << off << "(%rbp), %eax";
            sfile << "\n\tmovl\t%eax, (%rsp)";
            c += 4;
        }
        else {
            sfile << "\n\tsubq $8, %rsp";
            sfile << "\n\tmovq\t" << off << "(%rbp), %rax";
            sfile << "\n\tmovq\t%rax, (%rsp)";
            c += 8;
        }
    }
    return c;
}

void symbolTable::destroyFunction(std::ofstream &sfile) {
    int count = 0;
    string regname;
    for (int i = symbolTabList.size() - 1; i >= 0; i--) {
        if (symbolTabList[i]->isValid == false)
            continue;
        if (symbolTabList[i]->var_type == "param" && symbolTabList[i]->offset < 0) {
            if (symbolTabList[i]->type->type == tp_char) {
                regname = assignRegister(tp_char, count);
                sfile << "\n\tmovb\t%" << regname << ", " << symbolTabList[i]->offset << "(%rbp)";
            }
            else if (symbolTabList[i]->type->type == tp_int) {
                regname = assignRegister(tp_int, count);
                sfile << "\n\tmovl\t%" << regname << ", " << symbolTabList[i]->offset << "(%rbp)";
            }
            else {
                regname = assignRegister(10, count);
                sfile << "\n\tmovq\t%" << regname << ", " << symbolTabList[i]->offset << "(%rbp)";
            }
            count++;
        }
        if (count >= 6) break;
    }
}

void symbolTable::generateTargetCode(std::ofstream &sfile, int ret_count) {
    int i;
    for (i = initQuad; i <= lastQuad; i++) {
        opcode &opx = globalQuadArray.quads[i].op;
        string &arg1x = globalQuadArray.quads[i].arg1;
        string &arg2x = globalQuadArray.quads[i].arg2;
        string &resx = globalQuadArray.quads[i].result;

        int offr, off1, off2;
        int flag1 = 1;
        int flag2 = 1;
        int flag3 = 1;
        int j;

        if (search(resx)) offr = search(resx)->offset;
        else if (globalQuadArray.quads[i].result != "" && findGlobal(globalQuadArray.quads[i].result))
            flag3 = 0;
        if (search(arg1x))
            off1 = search(arg1x)->offset;
        else if (globalQuadArray.quads[i].arg1 != "" && findGlobal(globalQuadArray.quads[i].arg1))
            flag1 = 0;
        if (search(arg2x))
            off2 = search(arg2x)->offset;
        else if (globalQuadArray.quads[i].arg2 != "" && findGlobal(globalQuadArray.quads[i].arg2))
            flag2 = 0;
        if (flag1 == 0) {
            if (findGlobal(arg1x) == 2)
                sfile << "\n\tmovzbl\t" << arg1x << "(%rip), %eax";
            else
                sfile << "\n\tmovl\t" << arg1x << "(%rip), %eax";
        }
        if (flag2 == 0) {
            if (findGlobal(arg1x) == 2)
                sfile << "\n\tmovzbl\t" << arg2x << "(%rip), %edx";
            else
                sfile << "\n\tmovl\t" << arg2x << "(%rip), %edx";
        }
        if (mp_set.find(i) != mp_set.end()) {
            // Generate Label here
            sfile << "\n.L" << mp_set[i] << ":";
        }
        switch (opx)
        {
        case Q_PLUS:
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                if (flag1 != 0)
                    sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                if (flag2 != 0)
                    sfile << "\n\tmovzbl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\taddl\t%edx, %eax";

                if (flag3 != 0)
                    sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovb\t%al, " << resx << "(%rip)";
            }
            else
            {
                if (flag1 != 0)
                    sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";

                if (flag2 != 0)
                {
                    if (arg2x[0] >= '0' && arg2x[0] <= '9')
                        sfile << "\n\tmovl\t$" << arg2x << ", %edx";
                    else
                        sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                }
                sfile << "\n\taddl\t%edx, %eax";
                if (flag3 != 0)
                    sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovl\t%eax, " << resx << "(%rip)";
            }
            break;
        case Q_MINUS:
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                if (flag1 != 0)
                    sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                if (flag2 != 0)
                    sfile << "\n\tmovzbl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tsubl\t%edx, %eax";
                if (flag3 != 0)
                    sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovb\t%al, " << resx << "(%rip)";
            }
            else
            {
                if (flag1 != 0)
                    sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";

                // Direct Number access
                if (flag2 != 0)
                {
                    if (arg2x[0] >= '0' && arg2x[0] <= '9')
                        sfile << "\n\tmovl\t$" << arg2x << ", %edx";
                    else
                        sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                }
                sfile << "\n\tsubl\t%edx, %eax";
                if (flag3 != 0)
                    sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovl\t%eax, " << resx << "(%rip)";
            }
            break;
        case Q_MULT:
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                if (flag1 != 0)
                    sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                if (flag2 != 0)
                    sfile << "\n\tmovzbl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\timull\t%edx, %eax";
                if (flag3 != 0)
                    sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovb\t%al, " << resx << "(%rip)";
            }
            else
            {
                if (flag1 != 0)
                    sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                if (flag2 != 0)
                {
                    if (arg2x[0] >= '0' && arg2x[0] <= '9')
                    {
                        sfile << "\n\tmovl\t$" << arg2x << ", %ecx";
                        sfile << "\n\timull\t%ecx, %eax";
                    }
                    else
                        sfile << "\n\timull\t" << off2 << "(%rbp), %eax";
                }
                if (flag3 != 0)
                    sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovl\t%eax, " << resx << "(%rip)";
            }
            break;
        case Q_DIVIDE:
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                if (flag1 != 0)
                    sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcltd";
                if (flag2 != 0)
                    sfile << "\n\tidivl\t" << off2 << "(%rbp), %eax";
                else
                    sfile << "\n\tidivl\t%edx, %eax";
                if (flag3 != 0)
                    sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovb\t%al, " << resx << "(%rip)";
            }
            else
            {
                if (flag1 != 0)
                    sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcltd";
                if (flag2 != 0)
                    sfile << "\n\tidivl\t" << off2 << "(%rbp), %eax";
                else
                    sfile << "\n\tidivl\t%edx, %eax";
                if (flag3 != 0)
                    sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
                else
                    sfile << "\n\tmovl\t%eax, " << resx << "(%rip)";
            }
            break;
        case Q_MODULO:
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcltd";
                sfile << "\n\tidivl\t" << off2 << "(%rbp), %eax";
                sfile << "\n\tmovl\t%edx, %eax";
                sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcltd";
                sfile << "\n\tidivl\t" << off2 << "(%rbp), %eax";
                sfile << "\n\tmovl\t%edx, " << offr << "(%rbp)";
            }
            break;
        case Q_UNARY_MINUS:
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tnegl\t%eax";
                sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tnegl\t%eax";
                sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
            }
            break;
        case Q_ASSIGN:
            // Check if the second argument is a constant
            if (arg1x[0] >= '0' && arg1x[0] <= '9') // first character is number
                sfile << "\n\tmovl\t$" << arg1x << ", " << offr << "(%rbp)";
            else if (arg1x[0] == '\'')
                sfile << "\n\tmovb\t$" << (int)arg1x[1] << ", " << offr << "(%rbp)";
            else if (flag1 && search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
            }
            else if (flag1 && search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_int)
            {

                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
            }
            else if (search(resx) != NULL && search(resx)->type != NULL)
            {
                sfile << "\n\tmovq\t" << off1 << "(%rbp), %rax";
                sfile << "\n\tmovq\t%rax, " << offr << "(%rbp)";
            }
            else
            {
                if (flag3 != 0)
                {
                    sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                    sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
                }
                else
                    sfile << "\n\tmovl\t%eax, " << resx << "(%rip)";
            }
            break;
        case Q_PARAM:
            if (resx[0] == '_')
            {
                // string
                char *temp = (char *)resx.c_str();
                sfile << "\n\tmovq\t$.STR" << atoi(temp + 1) << ",\t%rdi";
            }
            else
            {
                _parameter_stack.push(resx);
                _type_stack.push(search(resx)->type->type);
                _offset_stack.push(offr);
                if (search(resx)->isPointerArray == true)
                    _pointer_stack.push(1);
                else
                    _pointer_stack.push(0);
            }
            break;
        case Q_GOTO:
            if (resx != "-1" && stoi(resx) <= lastQuad)
                sfile << "\n\tjmp .L" << mp_set[stoi(resx)];
            else
                sfile << "\n\tjmp\t.LRT" << ret_count;
            break;
        case Q_CALL:
            add_off = callFunction(sfile);
            sfile << "\n\tcall\t" << arg1x;
            if (resx == "")
            {
            }
            else if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_int)
                sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
            else if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
                sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
            else if (search(resx) != NULL && search(resx)->type != NULL)
                sfile << "\n\tmovq\t%rax, " << offr << "(%rbp)";
            else
                sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
            if (arg1x == "printStr")
                sfile << "\n\taddq $8 , %rsp";
            else
                sfile << "\n\taddq $" << add_off << " , %rsp";

            break;

        case Q_IF_LESS:
            if (search(arg1x) != NULL && search(arg1x)->type != NULL && search(arg1x)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcmpb\t" << off2 << "(%rbp), %al";
                sfile << "\n\tjl .L" << mp_set[stoi(resx)];
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tcmpl\t%edx, %eax";
                sfile << "\n\tjl .L" << mp_set[stoi(resx)];
            }
            break;
        case Q_IF_LESS_OR_EQUAL:
            if (search(arg1x) != NULL && search(arg1x)->type != NULL && search(arg1x)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcmpb\t" << off2 << "(%rbp), %al";
                sfile << "\n\tjle .L%d", mp_set[stoi(resx)];
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tcmpl\t%edx, %eax";
                sfile << "\n\tjle .L" << mp_set[stoi(resx)];
            }
            break;
        case Q_IF_GREATER:
            if (search(arg1x) != NULL && search(arg1x)->type != NULL && search(arg1x)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcmpb\t" << off2 << "(%rbp), %al";
                sfile << "\n\tjg .L" << mp_set[stoi(resx)];
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tcmpl\t%edx, %eax";
                sfile << "\n\tjg .L" << mp_set[stoi(resx)];
            }
            break;
        case Q_IF_GREATER_OR_EQUAL:
            if (search(arg1x) != NULL && search(arg1x)->type != NULL && search(arg1x)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcmpb\t" << off2 << "(%rbp), %al";
                sfile << "\n\tjge .L" << mp_set[stoi(resx)];
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tcmpl\t%edx, %eax";
                sfile << "\n\tjge .L" << mp_set[stoi(resx)];
            }
            break;
        case Q_IF_EQUAL:
            if (search(arg1x) != NULL && search(arg1x)->type != NULL && search(arg1x)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcmpb\t" << off2 << "(%rbp), %al";
                sfile << "\n\tje .L" << mp_set[stoi(resx)];
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tcmpl\t%edx, %eax";
                sfile << "\n\tje .L" << mp_set[stoi(resx)];
            }
            break;
        case Q_IF_NOT_EQUAL:
            if (search(arg1x) != NULL && search(arg1x)->type != NULL && search(arg1x)->type->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tcmpb\t" << off2 << "(%rbp), %al";
                sfile << "\n\tjne .L" << mp_set[stoi(resx)];
            }
            else
            {
                sfile << "\n\tmovl\t" << off1 << "(%rbp), %eax";
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %edx";
                sfile << "\n\tcmpl\t%edx, %eax";
                sfile << "\n\tjne .L" << mp_set[stoi(resx)];
            }
            break;
        case Q_ADDR:
            sfile << "\n\tleaq\t" << off1 << "(%rbp), %rax";
            sfile << "\n\tmovq\t%rax, " << offr << "(%rbp)";
            break;
        case Q_LDEREF:
            sfile << "\n\tmovq\t" << offr << "(%rbp), %rax";
            sfile << "\n\tmovl\t" << off1 << "(%rbp), %edx";
            sfile << "\n\tmovl\t%edx, (%rax)";
            break;
        case Q_RDEREF:
            sfile << "\n\tmovq\t" << off1 << "(%rbp), %rax";
            sfile << "\n\tmovl\t(%rax), %eax";
            sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
            break;
        case Q_RINDEX:
            // Get Address, subtract offset, get memory
            if (search(arg1x) && search(arg1x)->isPointerArray == true)
            {
                sfile << "\n\tmovq\t" << off1 << "(%rbp), %rdx";
                sfile << "\n\tmovslq\t" << off2 << "(%rbp), %rax";
                sfile << "\n\taddq\t%rax, %rdx";
            }
            else
            {
                sfile << "\n\tleaq\t" << off1 << "(%rbp), %rdx";

                sfile << "\n\tmovslq\t" << off2 << "(%rbp), %rax";
                sfile << "\n\taddq\t%rax, %rdx";
            }
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->next && search(resx)->type->next->type == tp_char)
            {
                sfile << "\n\tmovzbl\t(%rdx), %eax";
                sfile << "\n\tmovb\t%al, " << offr << "(%rbp)";
            }
            else
            {
                sfile << "\n\tmovl\t(%rdx), %eax";
                sfile << "\n\tmovl\t%eax, " << offr << "(%rbp)";
            }
            break;
        case Q_LINDEX:
            // Get Address, subtract offset, get memory
            if (search(resx) && search(resx)->isPointerArray == true)
            {
                sfile << "\n\tmovq\t" << offr << "(%rbp), %rdx";

                sfile << "\n\tmovslq\t" << off1 << "(%rbp), %rax";
                sfile << "\n\taddq\t%rax, %rdx";
            }
            else
            {
                sfile << "\n\tleaq\t" << offr << "(%rbp), %rdx";
                sfile << "\n\tmovslq\t" << off1 << "(%rbp), %rax";
                sfile << "\n\taddq\t%rax, %rdx";
            }
            if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->next && search(resx)->type->next->type == tp_char)
            {
                sfile << "\n\tmovzbl\t" << off2 << "(%rbp), %eax";
                sfile << "\n\tmovb\t%al, (%rdx)";
            }
            else
            {
                sfile << "\n\tmovl\t" << off2 << "(%rbp), %eax";
                sfile << "\n\tmovl\t%eax, (%rdx)";
            }
            break;
        case Q_RETURN:
            if (resx != "")
            {
                if (search(resx) != NULL && search(resx)->type != NULL && search(resx)->type->type == tp_char)
                    sfile << "\n\tmovzbl\t" << offr << "(%rbp), %eax";
                else
                    sfile << "\n\tmovl\t" << offr << "(%rbp), %eax";
            }
            else
                sfile << "\n\tmovl\t$0, %eax";
            sfile << "\n\tjmp\t.LRT" << ret_count;
            break;
        default:
            break;
        }
    }
}

void symbolTable::function_epilogue(std::ofstream &sfile, int count, int ret_count) {
    sfile << "\n.LRT" << ret_count << ":";
    sfile << "\n\taddq\t$" << offset << ", %rsp";
    sfile << "\n\tmovq\t%rbp, %rsp";
    sfile << "\n\tpopq\t%rbp";
    sfile << "\n\tret";
    sfile << "\n.LFE" << count << ":";
    sfile << "\n\t.size\t" << name << ", .-" << name;
}