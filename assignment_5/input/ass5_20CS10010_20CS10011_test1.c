// code for factorial
//tests declarations, functions, add basic functionalities

void factorial(int num);
void main()
{
    int num = 0;
    clrscr();
    printf("Enter number \t");
    scanf("%d",&num);
    factorial(num);
}

void factorial(int num)
{
   int prod=1;
   int i=1;
   if(num == 1)
   printf("%d",prod);
   while(i <= num)
   {
      prod=prod*i;
      i++;
   }
   if(num>1)
   printf("%d",prod);
}
