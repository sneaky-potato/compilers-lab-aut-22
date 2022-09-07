# Assignment 3 &middot;

>

Directory for the `third` assignment of Compilers Laboratory course (CS39003) offered in Autumn semester 2022, Department of CSE, IIT Kharagpur.

## Getting started

Read the assignment problem statement from [Assignment_3.pdf](/assignment_3/Assignment_3.pdf)

- To generate the executable file from given header and c code, use make

```shell
make
```

- To run the executable file and print the lexical analysis on terminal as well as output.txt file, use

```shell
make run
```

- To clean and remove executable and lex C file after compilation use

```shell
make clean
```

## Solution

GCC version information-  

```shell
gcc (GCC) 12.1.1 20220730
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

- [head.c](/assignment_3/head.h) contains the required macro definitions used in returning token values
- [ass3_20CS10010_20CS10011.l](/assignment_3/ass3_20CS10010_20CS10011.l) contains the lex specification for required regular expressions
- [ass3_20CS10010_20CS10011.c](/assignment_3/ass3_20CS10010_20CS10011.c) is the driving C code for scanning and printing output
- [ass3_20CS10010_20CS10011_test.c](/assignment_3/ass3_20CS10010_20CS10011_test.c) is the test file with C syntax for scanning and printing
