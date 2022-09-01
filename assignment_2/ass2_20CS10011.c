#include "myl.h"

//#########################################
//## Ashwani Kumar Kamal                 ##
//## 20CS10011                           ##
//## Compilers Laboratory Assignment - 2 ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

#define STR_BUFF_SIZE 100
#define BUFF_SIZE 20
#define PRECISION 6
#define INT_MAX_LIMIT 2147483647
#define INT_MIN_LIMIT 2147483648

int printStr(char *str)
{
    int cnt = 0;

    // Traverse till null character 
    while(str[cnt] != '\0')
    {
        cnt++;
    }

    // Pass asm directive for printing string with cnt length and str variable
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(str), "d"(cnt)
    );

    // Return number of character printed
    return cnt;
}

int readInt(int *n) 
{
    char buffer[STR_BUFF_SIZE];

    int is_negative = 0;
    int cnt = 0;
    long int value = 0;
    int length_integer = 0;

    // Pass asm directive for reading string with BUFF_SIZE length and buffer variable
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(length_integer)
        :"S"(buffer), "d"(BUFF_SIZE)
    );

    // If length of characters read is greater than buffer size, return ERR
    if(length_integer > BUFF_SIZE || length_integer <= 0) return ERR;

    // If number is negative
    if (buffer[0] == '-'){
        is_negative = 1;
        cnt++;
    }

    while(cnt < length_integer && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
    {
        // Scan till decimal number
        if(buffer[cnt] == '.') break;

        // If unknown character is read
        if (( ((int)buffer[cnt]-'0' > 9) || ((int)buffer[cnt]-'0' < 0) )) return ERR;
        
        // If read integer exceeds integer limit
        if(!is_negative && (1L * value * 10 + ((int)buffer[cnt] - '0')) > (INT_MAX_LIMIT))
            return ERR;
        else if(is_negative && (1L * value * 10 + ((int)buffer[cnt] - '0')) > (INT_MIN_LIMIT)) 
            return ERR;

        value *= 10;
        value += (buffer[cnt] - '0');
        cnt++;
    }

    // Negate number if negative number
    if(is_negative) value *= -1;

    *n = value;
    return OK;
}

int printInt(int n) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;

    // If number is negative, negate the number
    if(n < 0) {
        is_negative = 1;
        n *= -1;
    }

    // Special case of n == 0
    if(!n) buffer[cnt++] = '0';

    while(n) {
        buffer[cnt++] = (char)((n % 10) + '0');
        n /= 10;
    }

    // If negative number, store minus sign
    if(is_negative) buffer[cnt++] = '-';

    // Reverse buffer array
    for(int i=0; i<cnt/2; i++) {
        char t = buffer[i];
        buffer[i] = buffer[cnt - i - 1];
        buffer[cnt - i - 1] = t;
    }

    // asm directive for printing buffer
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buffer),"d"(cnt)
        );

    // Return number of characters printed
    return cnt;
}

int readFlt(float *f) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;
    double value = 0;
    int length_float = 0;

    // asm directive for reading buffer
    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(length_float)
        :"S"(buffer), "d"(BUFF_SIZE)
    );

    // if read characters are greater than BUFF_SIZE, return ERR
    if(length_float > BUFF_SIZE || length_float <= 0) return ERR;

    // If negative number
    if(buffer[cnt] == '-') {
        is_negative = 1;
        cnt++;
    }

    int decimal_found = 0;
    float deci = 1;

    while(cnt < length_float && buffer[cnt] != '\0' && buffer[cnt] != '\n' && buffer[cnt] != ' ' && buffer[cnt] != '\t')
    {
        if (( ((int)buffer[cnt]-'0' > 9) || ((int)buffer[cnt]-'0' < 0) ) && buffer[cnt] != '.')
            return ERR;
        
        // If decimal point is found, continue
        if(buffer[cnt] == '.') {
            decimal_found = 1;
            cnt++;
            continue;
        }

        // If intgeral part is still being scanned
        if(!decimal_found) {

            // If number exceeds integer limit
            if(!is_negative && (1L * value * 10 + ((int)buffer[cnt] - '0')) > (INT_MAX_LIMIT))
                return ERR;
            else if(is_negative && (1L * value * 10 + ((int)buffer[cnt] - '0')) > (INT_MIN_LIMIT)) 
                return ERR;

            value = 10 * value + (int)(buffer[cnt] - '0');
        } 
        // Decimal point found, update values accordingly
        else {
            deci *=10;
            value += ((float)(buffer[cnt] - '0')) / (float)deci;
        }
        cnt++;
    }
    
    // If negative number, negate the result
    if(is_negative) value *= -1;

    // Store result
	*f = value;
	return OK; 
}

int printFlt(float f) 
{
    char buffer[BUFF_SIZE];
    int is_negative = 0;
    int cnt = 0;

    // If negative number, negate the number
    if(f < 0) {
        is_negative = 1;
        f *= -1;
    }

    // Special case of n == 0
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

    // Multiply number by 10 till we get rid of decimal point
    // Example, 456.89 becomes 45689, deci = 2
    while((long int)p != p && deci < PRECISION)
    {
        f*=10;
        p*=10;
        deci++;
    } 

    // If no decimal point was found
    // Store a default .0 in buffer
    if(!deci) {
        buffer[cnt++] = '0';
        buffer[cnt++]='.';
    }

    long int n = (long int)p;

    // Store result
    while(n)
    {   
        // If decimal index is found, store decimal point
        if(cnt == deci) buffer[cnt++] = '.';
        buffer[cnt++] = n % 10 + '0';
        n /= 10;
    }

    // If decimal point was at the end of float
    if(cnt == deci) {
        buffer[cnt++]='.';
        buffer[cnt++]='0';
    }

    // Store negative sign if negative number
    if(is_negative) buffer[cnt++]='-';
    
    for(int i=0; i<cnt/2; i++) {
        char t = buffer[i];
        buffer[i] = buffer[cnt - i - 1];
        buffer[cnt - i - 1] = t;
    }

    // asm directive for printing buffer with cnt length
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buffer),"d"(cnt)
        );

    // Return number of characters printed
    return cnt;
}