#include "myl.h"

#define STR_BUFF_SIZE 100
#define BUFF_SIZE 20
#define PRECISION 6
#define INT_MAX_LIMIT 2147483647
#define INT_MIN_LIMIT 2147483648
#include<stdio.h>

int printStr(char *str)
{
    int cnt = 0;
    while(str[cnt] != '\0')
    {
        cnt++;
    }

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(cnt)
    );

    return cnt;
}

int readInt(int *n) 
{
    char buffer[STR_BUFF_SIZE];

    int is_negative = 0;
    int cnt = 0;
    long int value = 0;
    int length_integer = 0;
    
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(length_integer)
        :"S"(buffer), "d"(sizeof(buffer))
    );

    if(length_integer > BUFF_SIZE || length_integer <= 0) return ERR;

    if (buffer[0] == '-'){
        is_negative = 1;
        cnt++;
    }
 
    while(cnt < length_integer && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
    {
        if(buffer[cnt] == '.') break;

        if (( ((int)buffer[cnt]-'0' > 9) || ((int)buffer[cnt]-'0' < 0) )) return ERR;
        
        if(!is_negative && (1L * value * 10 + ((int)buffer[cnt] - '0')) > (INT_MAX_LIMIT))
            return ERR;
        else if(is_negative && (1L * value * 10 + ((int)buffer[cnt] - '0')) > (INT_MIN_LIMIT)) 
            return ERR;

        value *= 10;
        value += (buffer[cnt] - '0');
        cnt++;
    }

    if(is_negative) value *= -1;
    *n = value;

    if(cnt >= BUFF_SIZE && (buffer[BUFF_SIZE - 1] != '\n' && buffer[BUFF_SIZE - 1] != ' ' && buffer[BUFF_SIZE - 1] != '\t')) {
        return ERR;
    }
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

    return cnt;
}

int readFlt(float *f) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;
    double value = 0;
    int length_float = 0;

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(length_float)
        :"S"(buffer), "d"(BUFF_SIZE)
    );

    if(length_float > BUFF_SIZE || length_float <= 0) return ERR;

    if(buffer[cnt] == '-') {
        is_negative = 1;
        cnt++;
    }

    int decimal_found = 0;
    float deci = 1;

    while(cnt <= length_float && buffer[cnt] != '\0' && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
    {
        if (( ((int)buffer[cnt]-'0' > 9) || ((int)buffer[cnt]-'0' < 0) ) && buffer[cnt] != '.')
            return ERR;
        
        if(buffer[cnt] == '.') {
            decimal_found = 1;
            cnt++;
            continue;
        }

        if(!decimal_found) {
            value = 10 * value + (int)(buffer[cnt] - '0');
        } else {
            deci *=10;
            value += ((float)(buffer[cnt] - '0')) / (float)deci;
        }
        cnt++;
    }
    
    if(is_negative) value *= -1;
	*f = value;

    if(cnt >= BUFF_SIZE && (buffer[BUFF_SIZE - 1] != '\n' && buffer[BUFF_SIZE - 1] != ' ' && buffer[BUFF_SIZE - 1] != '\t')) {
        return ERR;
    }

	return OK; 
}

int printFlt(float f) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;

    if(f < 0) {
        is_negative = 1;
        f *= -1;
    }

    if(!f) {
        buffer[cnt++] = '0';
        buffer[cnt++] = '.';
        buffer[cnt++] = '0';

        __asm__ __volatile__ (
            "movl $1, %%eax \n\t"
            "movq $1, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(buffer),"d"(cnt)
        );
        return cnt;
    }

    int deci = 0;

    double p = f;

    while((long int)p != p && deci < PRECISION)
    {
        f*=10;
        p*=10;
        deci++;
    } 

    if(!deci) {
        buffer[cnt++] = '0';
        buffer[cnt++]='.';
    }

    long int n = (long int)p;

    while(n)
    {
        if(cnt == deci) buffer[cnt++] = '.';
        buffer[cnt++] = n % 10 + '0';
        n /= 10;
    }

    if(cnt == deci) {
        buffer[cnt++]='.';
        buffer[cnt++]='0';
    }

    if(is_negative) buffer[cnt++]='-';
    
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

    return cnt; 

}