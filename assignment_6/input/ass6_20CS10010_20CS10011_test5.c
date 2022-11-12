int fact(int a)
{
    int ans = a;
    int x = 1;
    if (a > 1)
    {
        x = fact(a - 1);
    }
    ans = ans * x;
    return ans;
}

int main()
{
    int n, ans;
    int err = 1;
    printStr("### Factorial calculation in O(N!) ###\n\n");
    printStr("Enter n (<=9): ");
    n = readInt(&err);
    ans = fact(n);

    printInt(n);
    printStr("! = ");
    printInt(ans);
    printStr("\n");
    return 0;
}