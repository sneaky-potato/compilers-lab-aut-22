#include<stdio.h>
#include<stdlib.h>

//#########################################
//## Ashish Rekhani (20CS10010)          ##
//## Ashwani Kumar Kamal (20CS10011)     ##
//## Compilers Laboratory                ##
//## Assignment - 3                      ##
//#########################################
//# GCC version: gcc (GCC) 12.1.1 20220730

const int MAX_N = 1e5 + 5;
const long long MOD = 1e9 + 7;
const long long INF = 1e9;
const double PI = 3.1415926535897;

/*
This file does not solve any problem in particular
This file is intended to serve as a test file for lexical parsing

This is still inside a multi line comment
*/

typedef struct {
    int v;
    int adj[1005][1005];
} Graph;

struct ComplexNumber {
    _Bool bool;
    _Complex comp;
};

enum weekend {
    FRIDAY,
    SATURDAY,
    SUNDAY
};

inline int inline_variadic_f(int *restrict first, ...) {
    auto int x = 1;
    volatile int volat;
    return x;
}

void solve()
{
    Graph *g;
    g = (Graph *)malloc(sizeof(Graph));

    g->v = 100;

    for(int i=0; i<100; i++) {
        g->adj[i][100-i] = 1;
    }

    int arr[MAX_N];
    for(int i=0; i<MAX_N; i++) {
        arr[i] = INF;
    }

    unsigned int count = 0;
    unsigned short int flag = 0;
    int y = 42;

    while (y) {
        y &= (y - 1);
        count++;
        flag ^= 1;
    }

}

int main()
{
    int tc = 10;
    for (int t = 1; t <= tc; t++) {
        solve();
    }
}

// <<EOF>>