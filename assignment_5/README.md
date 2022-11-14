# Assignment 5 &middot;

>

Directory for the `fifth` assignment of Compilers Laboratory course (CS39003) offered in Autumn semester 2022, Department of CSE, IIT Kharagpur.

## Getting started

Read the assignment problem statement from [Assignment_5.pdf](/assignment_5/Assignment_5.pdf)

- To generate the executable file + output text from given test and specification files, use make

```shell
make
```

- To test the executable against test files, use

```shell
make test
```

- To clean and remove build files after compilation use

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

- [ass5_20CS10010_20CS10011.l](/assignment_5/ass5_20CS10010_20CS10011.l) contains the lex specification for required regular expressions
- [ass5_20CS10010_20CS10011.y](/assignment_5/ass5_20CS10010_20CS10011.y) contains the yacc specifications in the form of production rules
- [ass4_20CS10010_20CS10011_translator.h](/assignment_5/ass5_20CS10010_20CS10011_translator.h) contains header declarations for the translator file
- [ass5_20CS10010_20CS10011_translator.cxx](/assignment_5/ass5_20CS10010_20CS10011_translator.cxx) is the main driver cxx file with symbol table and TAC implmentation
- [./input](/assignment_5/input/) contains the test c files
- [./output](/assignment_5/output/) contains the corresponding output translations
