int main()
{
    int n,i,j,eP=1;
    int spf[101];

    printStr("### Find all prime numbers till N in O(NloglogN) using Sieve of Eratosthenes ###\n\n");
    printStr("Enter N(<=100) : ");
    n = readInt(&eP);

    spf[0]=1;
    spf[1] = 1;
	for (i = 2; i <= n; i++)spf[i] = i;
	for (i = 4; i <= n; i =i+2)spf[i] = 2;
	for (i = 3; i * i <= n; i++)
		if (spf[i] == i)
			for (j = i * i; j <= n; j =j+i)
                if (spf[j] == j)
                    spf[j] = i;

    printStr("Prime numbers till ");
    printInt(n);
    printStr(" are : \n");
    for(i=2;i<=n;i++){
        if(spf[i]==i){
            printInt(i);
            printStr(" ");
        }
    }
    printStr("\n");


    return 0;
}