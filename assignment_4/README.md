# Assignment 4 &middot;

>

Directory for the `fourth` assignment of Compilers Laboratory course (CS39003) offered in Autumn semester 2022, Department of CSE, IIT Kharagpur.

## Getting started

Read the assignment problem statement from [Assignment_4.pdf](/assignment_4/Assignment_4.pdf)

- To generate the executable file and output text file from given test and specification files, use make

```shell
make
```

- To clean and remove object files after compilation, use

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

- [ass4_20CS10010_20CS10011.l](/assignment_4/ass4_20CS10010_20CS10011.l) contains the lex specification for required regular expressions
- [ass4_20CS10010_20CS10011.y](/assignment_4/ass4_20CS10010_20CS10011.y) contains the yacc specifications in the form of production rules
- [ass4_20CS10010_20CS10011_test.c](/assignment_4/ass4_20CS10010_20CS10011_test.c) is the test file with C syntax for scanning and printing
- [ass4_20CS10010_20CS10011.c](/assignment_4/ass4_20CS10010_20CS10011.c) is the main driver c file
