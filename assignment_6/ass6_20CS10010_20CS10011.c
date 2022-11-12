//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 6                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

#include "myl.h"
#define BUFF 100

int printStr(char *s)
{
	int i = 0;

	// i holds length of string
	while (s[i] != '\0')
		i++;

	__asm__ __volatile__(
		"movl $1, %%eax \n\t"
		"movq $1, %%rdi \n\t"
		"syscall \n\t"
		:
		: "S"(s), "d"(i));

	// returning length of string
	return i;
}
int readInt(int *n)
{
	*n = ERR; // intialising with zero so *n does not have garbage value if readInt returns ERR

	char buff[BUFF];
	int read_i = 0;
	__asm__ __volatile__(
		"movl $0, %%eax \n\t"
		"movq $0, %%rdi \n\t"
		"syscall \n\t"
		: "=a"(read_i)
		: "S"(buff), "d"(BUFF));

	buff[--read_i] = '\0';

	int i = read_i - 1;

	// whitespaces
	while (1)
	{
		if (i < 0 || i >= BUFF) return ERR;
		if (buff[i] == ' ') i--;
		else break;
	}

	buff[i + 1] = '\0';
	read_i = i + 1;

	i = 0;
	while (1)
	{
		if (i < 0 || i >= BUFF) return ERR;
		if (buff[i] == ' ') i++;
		else break;
	}
	
	if (i < 0 || i >= BUFF)
		return ERR;

	int flag = 1;
	if (buff[i] == '-') // if integer was -I
	{
		flag = -1;
		i++;
	}
	else if (buff[i] == '+') // if integer was +I
	{
		flag = 1;
		i++;
	}

	// absolute value of integer is from [i,..,read_i]
	int value = 0;
	for (int k = i; k < read_i; k++)
	{
		if (buff[k] < '0' || buff[k] > '9') return ERR;

		value *= 10;
		value += flag * (buff[k] - '0');
	}

	*n = OK;
	return value;
}

int printInt(int n)
{

	char buff[BUFF];
	char zero = '0';

	int i = 0, j, k;
	int is_lower_bound_32_bit = 0;
	if (n == 0)
		buff[i++] = zero;
	else
	{
		if (n < 0)
		{
			//implementation printInt for 32-bit signed integers
			//doing n=-n for n=-(2^31), will set n=(2^31)
			//(dealing with integer overflow)
			if (n == -(1ll << 31))
			{
				is_lower_bound_32_bit = 1;
				n++;
				//	adding 1 to it so that n becomes -(2^31) +1
				//	so when we do n=-n
				//	n becomes (2^31)-1 which is in range
			}
			buff[i++] = '-';
			n = -n;
		}

		// putting digits in reverse order
		while (n)
		{
			if (i >= BUFF)
				return ERR;
			buff[i++] = zero + n % 10;
			n /= 10;
		}

		j = (buff[0] == '-') ? 1 : 0;
		k = i - 1;

		// reversing
		while (j < k)
		{
			char temp = buff[j];
			buff[j] = buff[k];
			buff[k] = temp;
			j++;
			k--;
		}
	}
	if (i >= BUFF)
		return ERR;

	if (is_lower_bound_32_bit)
		buff[i - 1]++;

	buff[i++] = '\0';

	return printStr(buff);
}