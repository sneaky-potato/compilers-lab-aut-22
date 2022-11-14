//code for sum of natural numbers upto n
//tests for loop

int main(){
    int n,i;
    scanf("%d",&n);
    int sum=0;
    for(i=1;i<=n;i++){
        sum=sum+i;
    }
    printf("%d\n",sum);
    return 0;
}
