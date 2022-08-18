#include "myl.h"
#include <stdio.h>

int main()
{
    printStr("Running test file\n\n");

    printStr(":::Running standard test cases:::\n");
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