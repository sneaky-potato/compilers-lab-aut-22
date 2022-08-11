#########################################
## Ashwani Kumar Kamal                 ##
## 20CS10011                           ##
## Compilers Laboratory Assignment - 1 ##
#########################################

    .file    "ass1.c"           # name of the c code file
    .text
    .section    .rodata         # read only data
    .align 8                    # align with 8-byte boundary
.LC0:                                   
    .string    "Enter the string (all lower case): "        # f-string 1st printf
.LC1:
    .string    "%s"                                         # f-string 1st scanf
.LC2:
    .string    "Length of the string: %d\n"                 # f-string 2nd printf
    .align 8                                                # align with 8-byte boundary
.LC3:
    .string    "The string in descending order: %s\n"       # f-string 3rd printf
    .text                       # executable code starts
    .globl    main              # using main as a global name
    .type    main, @function    # defining main as a function
main:
.LFB0:
    .cfi_startproc              # beginning of function, call frame information
    pushq    %rbp               # Save old base pointer
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp          # set stack pointer to store base pointer address    
    .cfi_def_cfa_register 6
    subq    $80, %rsp           # space for allocating arrays
    movq    %fs:40, %rax        # segment addressing (buffer creation)
    movq    %rax, -8(%rbp)      # rax -> rbp-8, set rax = len
    xorl    %eax, %eax          # clear eax

    # printf("Enter the string (all lower case): ");    

    leaq    .LC0(%rip), %rax    # LC0 + rip -> rax
    movq    %rax, %rdi          # rax -> rdi, store first argument of printf function
    movl    $0, %eax            # 0 -> eax, clear eax
    call    printf@PLT          # call printf fucntion

    # scanf("%s", str);

    leaq    -64(%rbp), %rax     # rbp - 64 -> rax, store str pointer to rax
    movq    %rax, %rsi          # rax -> rsi, store second argument of scanf function
    leaq    .LC1(%rip), %rax    # LC1 + rip -> rax, store f-string pointer to rax
    movq    %rax, %rdi          # rax -> rdi, store first argument of scanf function
    movl    $0, %eax            # 0 -> eax, clear eax
    call    __isoc99_scanf@PLT  # call scanf function

    # len = length(str);

    leaq    -64(%rbp), %rax     # rbp - 64 -> rax, store str pointer to rax
    movq    %rax, %rdi          # rax -> rdi, store the first argument of length
    call    length              # call length function
    movl    %eax, -68(%rbp)     # eax -> rpb - 68, store the return value to (rbp - 68) (len)

    # printf("Length of the string: %d\n", len);
    
    movl    -68(%rbp), %eax     # (rbp - 68) -> eax, set eax = len
    movl    %eax, %esi          # eax -> esi, set second argument, len -> esi
    leaq    .LC2(%rip), %rax    # LC2 + rip -> rax, store f-string pointer to rax
    movq    %rax, %rdi          # rax -> rdi, store the first argument of printf function 
    movl    $0, %eax            # 0 -> eax, set eax = 0
    call    printf@PLT          # call printf function

    # sort(str, len, dest); 

    leaq    -32(%rbp), %rdx     # (rbp - 32) -> rdx, store the third argument of sort (dest -> rdx)
    movl    -68(%rbp), %ecx     # (rbp - 68) -> ecx, store the second argument of sort (len -> ecx)
    leaq    -64(%rbp), %rax     # (rbp - 64) -> rax, store the first argument of sort (src -> rax)
    movl    %ecx, %esi          # ecx -> esi, store the second argument of sort function
    movq    %rax, %rdi          # rax -> rdi, store the first argument of sort function
    call    sort                # call sort function

    # printf("The string in descending order: %s\n", dest);

    leaq    -32(%rbp), %rax     # (rbp - 32) -> rax, set rax = dest
    movq    %rax, %rsi          # rax -> rsi, set second argument, dest -> rsi
    leaq    .LC3(%rip), %rax    # LC3 + rip -> rax, store f-string pointer to rax
    movq    %rax, %rdi          # rax -> rdi, store the first argument of printf function 
    movl    $0, %eax            # 0 -> eax, set eax = 0
    call    printf@PLT          # call printf function

    # return 0; terminate program

    movl    $0, %eax            # 0 -> eax, clear eax, return value from main, 0
    movq    -8(%rbp), %rdx      # (rbp - 8) -> rdx
    subq    %fs:40, %rdx        # clear buffer
    je    .L3                   # call termination segment    
    call    __stack_chk_fail@PLT
.L3:
    leave
    .cfi_def_cfa 7, 8
    ret                         # return from main function
    .cfi_endproc                # end of main, closes its unwind entry previously opened by .cfi_startproc
.LFE0:
    .size    main, .-main
    .globl    length
    .type    length, @function
length:
.LFB1:
    .cfi_startproc              # beginning of function, call frame information
    pushq    %rbp               # Save old base pointer
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp          # set stack pointer to store base pointer address    
    .cfi_def_cfa_register 6
    movq    %rdi, -24(%rbp)     # rdi -> (rbp - 24), store the first argument of function in (rbp - 24)
    movl    $0, -4(%rbp)        # 0 -> (rbp - 4), set i = 0
    jmp    .L5                  # jump to L5, loop starts
.L6:
    addl    $1, -4(%rbp)        # (rbp - 4) + 1 -> rbp - 4, set i = i + 1 
.L5:
    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = i
    movslq    %eax, %rdx        # eax -> rdx, set rdx = i
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set str pointer to i, or str[i] 
    movzbl    (%rax), %eax
    testb    %al, %al           # test condition for loop 
    jne    .L6                  # continue to increment
    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = i for returning from the function
    popq    %rbp                # pop base pointer rbp
    .cfi_def_cfa 7, 8
    ret                         # return from length function
    .cfi_endproc                # end of length, closes its unwind entry previously opened by .cfi_startproc
.LFE1:
    .size    length, .-length
    .globl    sort
    .type    sort, @function
sort:
.LFB2:
    .cfi_startproc              # beginning of function, call frame information
    pushq    %rbp               # Save old base pointer
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp          # set stack pointer to store base pointer address
    .cfi_def_cfa_register 6
    subq    $48, %rsp           # space for allocating variables
    movq    %rdi, -24(%rbp)     # rdi -> (rbp - 24), set first argument, str -> (rbp - 24)
    movl    %esi, -28(%rbp)     # esi -> (rbp - 28), set second argument, len -> (rbp - 28)
    movq    %rdx, -40(%rbp)     # rdx -> (rbp - 40), set third argument, dest -> (rbp - 40)
    movl    $0, -8(%rbp)        # 0 -> (rbp - 8), set i = 0
    jmp    .L9                  # jump to L9, loop starts
.L13:
    movl    $0, -4(%rbp)        # 0 -> (rbp - 4), set j = 0
    jmp    .L10                 # jump tp L10, nested loop starts
.L12:
    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    movslq    %eax, %rdx        # eax -> rdx, set rdx = i
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set rax = str + i 
    movzbl    (%rax), %edx        
    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = j
    movslq    %eax, %rcx        # eax -> rcx, set rcx = j
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, store str pointer to rax
    addq    %rcx, %rax          # rcx + rax -> rax, set rax = str + j
    movzbl    (%rax), %eax
    cmpb    %al, %dl            # compare al and dl, check comparison of str[i] and str[j]
    jge    .L11                 # continue to increment if (str[i] >= str[j]) (jump greather than or equal)

    # temp = str[i]

    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    movslq    %eax, %rdx        # eax -> rdx, set rdx = i
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set rax = str + i
    movzbl    (%rax), %eax      # rax -> eax, set eax = str + i
    movb    %al, -9(%rbp)       # al -> (rbp - 9), set temp = str[i]

    # str[i] = str[j]

    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = j
    movslq    %eax, %rdx        # eax -> rdx, set rdx = j
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set rax = str + i
    movl    -8(%rbp), %edx      # (rbp - 8) -> edx, set edx = i
    movslq    %edx, %rcx        # edx -> rcx, set rcx = i
    movq    -24(%rbp), %rdx     # (rbp - 24) -> rdx, set store str pointer to rdx
    addq    %rcx, %rdx          # rcx + rdx -> rdx, set rdx = str + i
    movzbl    (%rax), %eax      # rax -> eax, set eax = str pointer
    movb    %al, (%rdx)         # al -> rdx, set str[i] = str[j]

    # str[j] = temp

    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = j
    movslq    %eax, %rdx        # eax -> rdx, set rdx = j
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rax, %rdx          # rax + rdx -> rdx, set rdx = str + j 
    movzbl    -9(%rbp), %eax    # (rbp - 9) -> eax, set eax = temp
    movb    %al, (%rdx)         # set str[j] = temp
.L11:
    addl    $1, -4(%rbp)        # (1 + rbp) - 4 -> (rbp - 4), set j = j + 1
.L10:
    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = j
    cmpl    -28(%rbp), %eax     # compare (rbp - 28) and eax, check comparison of j and len
    jl    .L12                  # continue nested loop if j < len (jump less than)
    addl    $1, -8(%rbp)        # 1 + (rbp - 8) -> rbp - 8, set i = i + 1
.L9:
    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    cmpl    -28(%rbp), %eax     # compare (rbp - 28) and eax, check comparison of i and len
    jl    .L13                  # continue to increment if i < len (jump less than)
    movq    -40(%rbp), %rdx     # (rbp - 40) -> rdx, set rdx = dest
    movl    -28(%rbp), %ecx     # (rbp - 28) -> ecx, set ecx = len 
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set rax = str
    movl    %ecx, %esi          # ecx -> esi, store the second argument of reverse (len -> esi)
    movq    %rax, %rdi          # rax -> rdi, store the first argument of reverse 
    call    reverse             # call reverse function
    nop                         # no operation
    leave
    .cfi_def_cfa 7, 8
    ret                         # return from sort function
    .cfi_endproc                # end of sort, closes its unwind entry previously opened by .cfi_startproc
.LFE2:
    .size    sort, .-sort
    .globl    reverse
    .type    reverse, @function
reverse:
.LFB3:
    .cfi_startproc              # beginning of function, call frame information
    pushq    %rbp               # Save old base pointer
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp          # set stack pointer to store base pointer address
    .cfi_def_cfa_register 6
    movq    %rdi, -24(%rbp)     # rdi -> (rbp - 24), set first argument, str -> (rbp - 24)
    movl    %esi, -28(%rbp)     # esi -> (rbp - 28), set second argument, len -> (rbp - 28)
    movq    %rdx, -40(%rbp)     # rdx -> (rbp - 40), set third argument, dest -> (rbp - 40)
    movl    $0, -8(%rbp)        # 0 -> (rbp - 8), set i = 0
    jmp    .L15                 # jump L15, loop starts
.L20:
    movl    -28(%rbp), %eax     # (rbp - 28) -> eax, set eax = len
    subl    -8(%rbp), %eax      # eax - (rbp - 8) -> eax, set eax = len - i
    subl    $1, %eax            # eax - 1 -> eax, set eax = len - i - 1 
    movl    %eax, -4(%rbp)      # eax -> (rbp - 4), set j = len - i - 1
    nop                         # no operation
    movl    -28(%rbp), %eax     # (rbp - 28) -> eax, set eax = len
    movl    %eax, %edx          # eax -> edx, set edx = len
    shrl    $31, %edx           # right shift edx by 31
    addl    %edx, %eax          # edx + eax -> eax 
    sarl    %eax                # eax will now store len / 2
    cmpl    %eax, -4(%rbp)      # compare eax and (rbp - 4), check comparison of len / 2 and j 
    jl    .L18                  # continue to increment outer loop if j < len / 2 (jump less than)
    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    cmpl    -4(%rbp), %eax      # compare eax and (rbp - 4), check comparison of i and j
    je    .L23                  # jump to L23, if(i == j) (jump equal to) break out of nested loop

    # temp = str[i]

    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    movslq    %eax, %rdx        # eax -> rdx, set rdx = i
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set rax = str + i
    movzbl    (%rax), %eax      #
    movb    %al, -9(%rbp)       # al -> (rbp - 9), set temp = str[i]

    # str[i] = str[j]

    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = j
    movslq    %eax, %rdx        # eax -> rdx, set rdx = j
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set rax = str + j
    movl    -8(%rbp), %edx      # (rbp - 8) -> edx, set edx = i
    movslq    %edx, %rcx        # eax -> rcx, set rcx = i
    movq    -24(%rbp), %rdx     # (rbp - 24) -> rdx, set store str pointer to rdx
    addq    %rcx, %rdx          # rdx + rcx -> rdx, set rdx = str + i
    movzbl    (%rax), %eax      # 
    movb    %al, (%rdx)         # al -> (rdx), set str[i] = str[j]

    # str[j] = temp

    movl    -4(%rbp), %eax      # (rbp - 4) -> eax, set eax = j
    movslq    %eax, %rdx        # eax -> rdx, set rdx = j
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rax, %rdx          # rdx + rax -> rax, set rax = str + j
    movzbl    -9(%rbp), %eax    # (rbp - 9) -> eax, set eax = temp
    movb    %al, (%rdx)         # al -> (rdx), set str[j] = temp 
    jmp    .L18                 # continue loop
.L23:
    nop                         # no operation
.L18:
    addl    $1, -8(%rbp)        # 1 + (rbp - 8) -> (rbp - 8), set i = i + 1
.L15:
    movl    -28(%rbp), %eax     # (rbp - 28) -> eax, set eax = len
    movl    %eax, %edx          # eax -> edx, set edx = len
    shrl    $31, %edx           # right shift edx by 31
    addl    %edx, %eax          # edx + eax -> eax
    sarl    %eax                # eax now has value len / 2 
    cmpl    %eax, -8(%rbp)      # compare eax and (rbp - 8), check comparison of len / 2 and i
    jl    .L20                  # continue loop if (i < len / 2) (jump less than)
    movl    $0, -8(%rbp)        # 0 -> (rbp - 8), set i = 0
    jmp    .L21
.L22:                           # Label for setting dest[i] = str[i] and incrementing i
    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    movslq    %eax, %rdx        # eax -> rdx, set rdx = i
    movq    -24(%rbp), %rax     # (rbp - 24) -> rax, set store str pointer to rax
    addq    %rdx, %rax          # rdx + rax -> rax, set rax = str + i
    movl    -8(%rbp), %edx      # (rbp - 8) -> edx, set edx = i
    movslq    %edx, %rcx        # edx -> rcx, set rcx = i
    movq    -40(%rbp), %rdx     # (rbp - 40) -> rdx, set store dest pointer to rdx
    addq    %rcx, %rdx          # rdx + rcx -> rdx, set rdx = dest + i
    movzbl    (%rax), %eax      # (rax) -> eax
    movb    %al, (%rdx)         # set dest[i]=str[i]
    addl    $1, -8(%rbp)        # 1 + (rbp - 8) -> (rbp - 8), set i = i + 1 
.L21:
    movl    -8(%rbp), %eax      # (rbp - 8) -> eax, set eax = i
    cmpl    -28(%rbp), %eax     # compare (rbp - 28) and eax, check comparison of len and i
    jl    .L22                  # jump to L22 (to set dest[i] = str[i]) if(i < len) (jump less than)
    nop                         # no operation
    nop                         # no operation
    popq    %rbp                # pop base pointer rbp
    .cfi_def_cfa 7, 8
    ret                         # return from reverse function
    .cfi_endproc                # end of sort, closes its unwind entry previously opened by .cfi_startproc

.LFE3:
    .size    reverse, .-reverse
    .ident    "GCC: (GNU) 12.1.1 20220730"
    .section    .note.GNU-stack,"",@progbits
