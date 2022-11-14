# Assignment 6 &middot;

>

Directory for the `sixth` and final assignment of Compilers Laboratory course (CS39003) offered in Autumn semester 2022, Department of CSE, IIT Kharagpur.

## Getting started

Read the assignment problem statement from [Assignment_6.pdf](/assignment_6/Assignment_6.pdf)

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

- [ass6_20CS10010_20CS10011.l](/assignment_6/ass6_20CS10010_20CS10011.l) contains the lex specification for required regular expressions
- [ass6_20CS10010_20CS10011.y](/assignment_6/ass6_20CS10010_20CS10011.y) contains the yacc specifications in the form of production rules
- [ass4_20CS10010_20CS10011_translator.h](/assignment_6/ass6_20CS10010_20CS10011_translator.h) contains header declarations for the translator file
- [ass6_20CS10010_20CS10011_translator.cxx](/assignment_6/ass6_20CS10010_20CS10011_translator.cxx) is the main driver cxx file with symbol table and TAC implmentation
- [ass6_20CS10011_20CS1011_target_translator.cxx](/assignment_6/ass6_20CS10010_20CS10011_target_translator.cxx) is the main driver file for generating assembly output files
- [./input](/assignment_6/input/) contains the test c files
- [./output](/assignment_6/output/) contains the corresponding output translations and assembly files
