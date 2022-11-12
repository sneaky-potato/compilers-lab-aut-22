int computeLPSArray(char s[], int m, int pi[])
{
	int i,j;
    for(i=0;i<m;i++)pi[i]=0;
	for (i = 1; i < m; i++) {
		j = pi[i-1];
		while (j > 0 && s[i] != s[j])
			j = pi[j-1];
		if (s[i] == s[j])
			j++;
		pi[i] = j;
	}

    return 0;
}

int KMPSearch(char pat[],int M, char txt[],int N)
{
	int lps[100];
	computeLPSArray(pat, M, lps);

	int i = 0;
	int j = 0;
    int ind = -1;
	while (i < N) {
		if (pat[j] == txt[i]) {
			j++;
			i++;
		}

		if (j == M) {
            ind=i-j;
            printInt(ind);
            printStr(" ");
			j = lps[j - 1];
		}

		// mismatch after j matches
		else if (i < N && pat[j] != txt[i]) {
			if (j != 0)
				j = lps[j - 1];
			else
				i++;
		}
	}

    return 0;
}



// Driver program to test above function
int main()
{
	char txt[100];
	char pat[100];

    printStr("\n### Implementation of KMP pattern searching in O(N+M) ###\n\n");

    txt[0]='a';
    txt[1]='b';
    txt[2]='c';
    txt[3]='b';
    txt[4]='c';
    txt[5]='d';
    txt[6]='b';
    txt[7]='c';
    txt[8]='b';
    txt[9]='\0';

    pat[0]='b';
    pat[1]='c';
    pat[2]='b';
    pat[3]='\0';


    int n=9;
    int m=3;

    printStr("Text = ");
    printStr(txt);
    printStr("\n");
    printStr("Pattern = ");
    printStr(pat);
    printStr("\n");
    printStr("Pattern occurs at follwing indexes(0-based) in text : ");
    printStr("\n");
	KMPSearch(pat,m,txt,n);
    printStr("\n");

	return 0;
}
