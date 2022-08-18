#include "myl.h"
#define BUFF_SIZE 100

int printStr(char *str)
{
    int len = 0;
    while(str[len] != '\0')
        len++;

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(len)
    );
    return len;
}

// reads a signed integer in ‘%d’ format. Caller gets the value
// through the pointer parameter. The return value is OK (for success) or ERR (on failure).
int readInt(int *n) 
{
    char buffer[BUFF_SIZE];
    
    int is_negative = 0;
    int cnt = 0;
    int value = 0;
    
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buffer), "d"(sizeof(buffer))
    );

    if (buffer[0] == '-'){
        is_negative = 1;
        cnt++;
    }
 
    while(cnt < 100 && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
    {
        if (( ((int)buffer[cnt]-'0' > 9) || ((int)buffer[cnt]-'0' < 0) )) return ERR;
        
        value *= 10;
        value += (buffer[cnt] - '0');
        cnt++;
    }

    if(is_negative) value *= -1;
    *n = value;

    if(cnt >= 100 && (buffer[99] != '\n' && buffer[99] != ' ' && buffer[99] != '\t')) return ERR;
    return OK;
}

int printInt(int n) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;

    if(n < 0) {
        is_negative = 1;
        n *= -1;
    }

    if(!n) buffer[cnt++] = '0';

    while(n) {
        buffer[cnt++] = (char)((n % 10) + '0');
        n /= 10;
    }

    if(is_negative) buffer[cnt++] = '-';

    for(int i=0; i<cnt/2; i++) {
        char t = buffer[i];
        buffer[i] = buffer[cnt - i - 1];
        buffer[cnt - i - 1] = t;
    }
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buffer),"d"(cnt)
        );

    return cnt; // Return the number of characters printed
}