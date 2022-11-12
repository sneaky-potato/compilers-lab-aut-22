int upper_bound(int d[],int n,int x)
{
    int l=0;
    int r=n-1;
    int ans=n;
    int m;

    while (l<=r)
    {
        m=(l+r)/2;
        if(d[m]>x){
            ans=m;
            r=m-1;
        }else{
            l=m+1;
        }
    }
    return ans;
}

int lis_length(int a[],int n) {
	int INF = 1000;
	int i,j,d[101];
    for(i=1;i<=100;i++)
        d[i]=INF;
	d[0] = -INF;
	for (i = 0; i < n; i++) {
		j = upper_bound(d, n+1, a[i]);
		if (d[j-1] < a[i] && a[i] < d[j])d[j] = a[i];
	}

	int ans = 0;
	for (i = 0; i <= n; i++) {
		if (d[i] < INF)
		    ans = i;
	}

	return ans;
}

int main() {
    int a[100], i, n,l;
    int eP = 1;
    printStr("### Calculate size of LIS of an array in O(NlogN) ###\n\n");
    printStr("Enter size of array (n<=100) : \n");
    n = readInt(&eP);
    printStr("Enter the elements of the array (separated by newlines): \n");
    for (i = 0; i < n; i++)
        a[i] = readInt(&eP);
        
    printStr("The array elements are:\n");
    for (i = 0; i < n; i++)
    {
        printInt(a[i]);
        printStr(" ");
    }
    printStr("\n");

    l = lis_length(a, n);
    printStr("Length of Longest Incresing Subsequence (LIS) of the given array is : ");
    printInt(l);
    printStr("\n");

    return 0;
}
