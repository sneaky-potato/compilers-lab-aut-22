#include "myl.h"

//#########################################
//## Ashwani Kumar Kamal                 ##
//## 20CS10011                           ##
//## Compilers Laboratory Assignment - 2 ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

int main()
{
    printStr("Running test file\n\n");

    printStr("\n:::Running mixed test cases:::\n");

    printStr("::String Test::\n");

    char* listS[] = {"Simple String", "Newline\n", "\ttab", " ", "The End", "..."};
    int n = sizeof(listS) / sizeof(char*);
    for(int i=0; i<n; i++) {
        printStr(listS[i]);
        printStr("\n");
    }

    printStr("::Integer Test::\n");

    int listI[] = {1, 0, -0, 58656758898, 999, -1, -4545};
    n = sizeof(listI) / sizeof(int);
    for(int i=0; i<n; i++) {
        printInt(listI[i]);
        printStr("\n");
    }

    printStr("::Float Test::\n");

    float listF[] = {1, 0, -0, -9.67676878878, 1.00000004, -4545.234375};
    n = sizeof(listF) / sizeof(float);
    for(int i=0; i<n; i++) {
        printFlt(listF[i]);
        printStr("\n");
    }

    printStr(":::Running input test cases:::\n");
    char *s = "Hello There!";
    int r = printStr(s);
    printStr("\n");

    printStr("Characters printed: ");
    printInt(r);
    printStr("\n");

    int i;
    printStr("Enter an integer: ");
    r = readInt(&i);
    if(r == OK) {
        printStr(">Successfully read integer input: \n>");
        int cnt = printInt(i);
        printStr("\n>Characters printed: ");
        printInt(cnt);
        printStr("\n");

    } else {
        printStr(">Error in reading integer input\n");
    }

    float j;
    printStr("Enter a float: ");
    r = readFlt(&j);
    if(r == OK) {
        printStr(">Successfully read float input: \n>");
        int cnt = printFlt(j);
        printStr("\n>Characters printed: ");
        printInt(cnt);
        printStr("\n");

    } else {
        printStr(">Error in reading integer input\n");
    }
}