int merge(int a[], int left, int mid, int right)
{
    int i = left;
    int j = mid + 1;
    int k = 0;
    int inversions = 0;
    int temp[100];

    while (i <= mid && j <= right)
    {
        if (a[i] <= a[j])
        {
            temp[k++] = a[i++];
        }
        else
        {
            temp[k++] = a[j++];
            inversions = inversions + mid - i + 1;
        }
    }

    while (i <= mid)
    {
        temp[k++] = a[i++];
    }
    while (j <= right)
    {
        temp[k++] = a[j++];
    }
    for (i = left; i <= right; i++)
    {
        a[i] = temp[i - left];
    }

    return inversions;
}

int merge_sort(int a[], int left, int right)
{
    int inversions = 0;
    int mid = 0;
    if (left < right)
    {
        mid = (left + right) / 2;
        inversions = inversions + merge_sort(a, left, mid);
        inversions = inversions + merge_sort(a, mid + 1, right);
        inversions = inversions + merge(a, left, mid, right);
    }

    return inversions;
}

int main()
{
    int a[100], i, n;
    int err = 1;
    printStr("### Merge Sort and also find no. of inversions in an array in O(NlogN) ###\n\n");
    
    printStr("Enter size of array (n<=100) : \n");
    n = readInt(&err);
    printStr("Enter the numbers (separated by newlines): \n");
    for (i = 0; i < n; i++)
        a[i] = readInt(&err);
    printStr("The array elements before sorting are:\n");
    for (i = 0; i < n; i++)
    {
        printInt(a[i]);
        printStr(" ");
    }
    printStr("\n");
    
    int x;
    x = merge_sort(a, 0, n - 1);
    printStr("The number of inversions in the array before sorting are : ");
    printInt(x);
    printStr("\n");
    
    printStr("The array elements after sorting are:\n");
    for (i = 0; i < n; i++)
    {
        printInt(a[i]);
        printStr(" ");
    }
    printStr("\n");
    
    return 0;
}
