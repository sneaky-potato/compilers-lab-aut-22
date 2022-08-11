# Assignment 1 &middot;

>

Directory for the `first` assignment of Compilers Laboratory course (CS39003) offered in Autumn semester 2022, Department of CSE, IIT Kharagpur.

## Getting started

Read the assignment problem statement from [Assignment_1.pdf](/assignment_1/Assignment_1.pdf)

- To generate the assembly code from given c code, use this

```shell
cc -Wall -S ass1.c
```

- To generate machine annotated assembly code, use this command

```shell
cc -Wall -fverbose-asm -S ass1.c
```

## Solution

GCC version information-  

```shell
gcc (GCC) 12.1.1 20220730
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

>Generated assembly code might be slightly different depending on the compiler version

The file [ass1_20CS10011.s](/assignment_1/ass1_20CS10011.s) contains the assignment submission file with comments describing *almost* all the lines of the assembly code.
