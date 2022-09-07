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


struct struct2 {
    _Complex x;
    _Bool z;
    short i;
};

static int p;
typedef struct struct1 struct2;
int main() {

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

    double x = -3.3;
    int y = 5;
    int size_of = 4*sizeof(char);
    inline int inline_variadic_f(int *restrict first, ...) {
        auto int x = 1;
        volatile int volat;
        return x;
    }

    for(int i = 0; i<size_of;i++){
        x++;
        x--;
        x += 1;
        x -= 1;
        x *= 1;
        x /= 1;
        y |= y;
        y &= y;
        if (y % 2 == 0){
            printf("y = %d\n", y);
            y<<1;
        }
        else if (y&1 || y > 120){
            y>>1;
            y = y | 1;
        }
    }

    
    unsigned int z = 2;
    const double pi = 3.14;
    int i1 = 1e9 + 7;
    float f1 = 1.234e5;
    int i2 = -23;
    long int i3 = 12345675634;
    int i4 = (i1 >= i2)?i1:i2;
    switch(i1){
        case 1:
            printf("1");
            break;
        case 2:
            printf("2");
            break;
        default:
            printf("default");
            break;
    }
    char s1[] = "Hello";

    int u = 0;
    do{
        u++;
        if (u > 10) goto label;
        label:
            u++;
            continue;
    } while ( u < 12);

    return 0;
}

// This is a single line comment

// <<EOF>>