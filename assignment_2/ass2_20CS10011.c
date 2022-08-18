#include "myl.h"
#define STR_BUFF_SIZE 100
#define BUFF_SIZE 20
#define PRECISION 6
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
    int value = 0;
    int length_integer = 0;
    
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(length_integer)
        :"S"(buffer), "d"(sizeof(buffer))
    );

    if (buffer[0] == '-'){
        is_negative = 1;
        cnt++;
    }
 
    while(cnt < length_integer && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
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

int readFlt(float *f) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;
    float value = 0;
    int float_len = 0;

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(float_len)
        :"S"(buffer), "d"(BUFF_SIZE)
    );

    if(buffer[cnt] == '-') {
        is_negative = 1;
        cnt++;
    }

    int decimal_found = 0;
    float deci = 1;

    while(cnt < float_len && buffer[cnt] != '\0' && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
    {
        // If not float, return error
        if (( ((int)buffer[cnt]-'0' > 9) || ((int)buffer[cnt]-'0' < 0) ) && buffer[cnt] != '.')
            return ERR;
        
        if(buffer[cnt] == '.') {
            decimal_found = 1;
            cnt++;
            continue;
        }

        if(!decimal_found) {
            value = 10*value + (int)(buffer[cnt] - '0');
        } else {
            deci *=10;
            value += (float)(buffer[cnt] - '0') / deci;
        }
        cnt++;
    }
    
    if(is_negative) value *= -1;

	*f = value;

    // printf("value read => %f\n", value);
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
    while((int)f != f && deci < PRECISION)
    {
        f*=10;
        deci++;
    } 

    // deci = deci > PRECISION ? PRECISION : deci;

    // printf("\ndecimal point is at = %d\n f = %f\n", deci, f);

    if(!deci) {
        buffer[cnt++] = '0';
        buffer[cnt++]='.';
    }

    int n = f;

    while(n)
    {
        if(cnt == deci) buffer[cnt++] = '.'; // Place the decimal point in the correct position
        buffer[cnt++] = n%10 + '0'; // Create an array with the digits of the number
        n/=10;
    }

    if(cnt == deci) {
        buffer[cnt++]='.', buffer[cnt++]='0';
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

    return cnt; // Return the number of characters printed

}