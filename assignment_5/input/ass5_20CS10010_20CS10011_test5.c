//Program to sort an array using bubble sort
//tests array declarations and manipulations
int main(){
    int arr[5];
    scanf("%d",&arr[0]);
    scanf("%d",&arr[1]);
    scanf("%d",&arr[2]);
    scanf("%d",&arr[3]);
    scanf("%d",&arr[4]);
    int i,j;
    for(i=0;i<4;i++){
        for(j=0;j<4-i;j++){
            if(arr[j]>arr[j+1]){
                int t=arr[j];
                arr[j]=arr[j+1];
                arr[j+1]=t;
            }
        }
    }
    for(i=0;i<5;i++){
        printf("%d ",arr[i]);
    }
    printf("\n");
    return 0;
}
