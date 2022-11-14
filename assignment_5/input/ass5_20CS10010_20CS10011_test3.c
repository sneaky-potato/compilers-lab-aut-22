//code to test recursion...fatorial via recursion

int factorial(int num);
void main()
{
    int num = 0;
    int fact;
    clrscr();
    printf("Enter number \t");
    scanf("%d",&num);
    fact=factorial(num);
    printf("%d",fact);
}

int factorial(int num)
{
	if(num==1)
	return 1;
	else{
		int q;
		q=num*factorial(num-1);
		return q;
	}
}
