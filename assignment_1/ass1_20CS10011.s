#########################################
## Ashwani Kumar Kamal                 ##
## 20CS10011                           ##
## Compilers Laboratory Assignment - 1 ##
#########################################
# GCC version: gcc (GCC) 12.1.1 20220730
    .file    "ass1.c"           # name of the c code file
    .text
    .section    .rodata         # section for read only data 
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
    .cfi_def_cfa_offset 16      # Set CFA to use offset of 16
    .cfi_offset 6, -16          # Set rule to set register 6 at offset of -16 from CFI
    movq    %rsp, %rbp          # set stack pointer to store base pointer address    
    .cfi_def_cfa_register 6     # Set CFA to use offset of 16
    subq    $80, %rsp           # space for allocating arrays
    movq    %fs:40, %rax        # segment addressing (buffer creation)
    movq    %rax, -8(%rbp)      # rbp-8 <- rax, set rax = len
    xorl    %eax, %eax          # clear eax (explanation: xor operation takes fewer bytes than mov)

    # printf("Enter the string (all lower case): ");    

    leaq    .LC0(%rip), %rax    # rax <- LC0 + rip, store f-string pointer to rax
    movq    %rax, %rdi          # rdi <- rax, store first argument of printf function
    movl    $0, %eax            # eax <- 0, clear eax
    call    printf@PLT          # call printf fucntion

    # scanf("%s", str);

    leaq    -64(%rbp), %rax     # rax <- rbp - 64, store str pointer to rax
    movq    %rax, %rsi          # rsi <- rax, store second argument of scanf function
    leaq    .LC1(%rip), %rax    # rax <- LC1 + rip, store f-string pointer to rax
    movq    %rax, %rdi          # rdi <- rax, store first argument of scanf function
    movl    $0, %eax            # eax <- 0, clear eax
    call    __isoc99_scanf@PLT  # call scanf function

    # len = length(str);

    leaq    -64(%rbp), %rax     # rax <- rbp - 64, store str pointer to rax
    movq    %rax, %rdi          # rdi <- rax, store the first argument of length
    call    length              # call length function
    movl    %eax, -68(%rbp)     # (rbp - 68) <- eax, store the return value to (rbp - 68) (len)

    # printf("Length of the string: %d\n", len);
    
    movl    -68(%rbp), %eax     # eax <- (rbp - 68), set eax = len
    movl    %eax, %esi          # esi <- eax, set second argument, len -> esi
    leaq    .LC2(%rip), %rax    # rax <- LC2 + rip, store f-string pointer to rax
    movq    %rax, %rdi          # rdi <- rax, store the first argument of printf function 
    movl    $0, %eax            # eax <- 0, set eax = 0
    call    printf@PLT          # call printf function

    # sort(str, len, dest); 

    leaq    -32(%rbp), %rdx     # rdx <- (rbp - 32), store the third argument of sort (dest -> rdx)
    movl    -68(%rbp), %ecx     # ecx <- (rbp - 68), store the second argument of sort (len -> ecx)
    leaq    -64(%rbp), %rax     # rax <- (rbp - 64), store the first argument of sort (src -> rax)
    movl    %ecx, %esi          # esi <- ecx, store the second argument of sort function
    movq    %rax, %rdi          # rdi <- rax, store the first argument of sort function
    call    sort                # call sort function

    # printf("The string in descending order: %s\n", dest);

    leaq    -32(%rbp), %rax     # rax <- (rbp - 32), set rax = dest
    movq    %rax, %rsi          # rsi <- rax, set second argument, dest -> rsi
    leaq    .LC3(%rip), %rax    # rax <- LC3 + rip, store f-string pointer to rax
    movq    %rax, %rdi          # rdi <- rax, store the first argument of printf function 
    movl    $0, %eax            # eax <- 0, set eax = 0
    call    printf@PLT          # call printf function

    # return 0; terminate program

    movl    $0, %eax            # eax <- 0, clear eax, return value from main, 0
    movq    -8(%rbp), %rdx      # rdx <- (rbp - 8)
    subq    %fs:40, %rdx        # clear buffer
    je    .L3                   # call termination segment    
    call    __stack_chk_fail@PLT
.L3:
    leave                       # restore state of base pointer to original
    .cfi_def_cfa 7, 8           # directive for setting computing CFA from register 7 and 8
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
    movq    %rdi, -24(%rbp)     # (rbp - 24) <- rdi, store the first argument of function in (rbp - 24)
    movl    $0, -4(%rbp)        # (rbp - 4) <- 0, set i = 0
    jmp    .L5                  # jump to L5, outer loop starts
.L6:
    addl    $1, -4(%rbp)        # (rbp - 4) <- (rbp - 4) + 1, set i = i + 1 
.L5:
    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = i
    movslq    %eax, %rdx        # rdx <- eax, set rdx = i
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set str pointer to i, or str[i] 
    movzbl    (%rax), %eax      # eax <- rax, move and zero padding the destination register
    testb    %al, %al           # test condition for loop (logical AND of al and al), str[i] and '\0'
    jne    .L6                  # jump to L6 if not equal, continue to increment (jump not equal to)
    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = i for returning from the function
    popq    %rbp                # pop base pointer rbp
    .cfi_def_cfa 7, 8           # directive for setting computing CFA from register 7 and 8
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
    movq    %rdi, -24(%rbp)     # (rbp - 24) <- rdi, get first argument, str -> (rbp - 24)
    movl    %esi, -28(%rbp)     # (rbp - 28) <- esi, get second argument, len -> (rbp - 28)
    movq    %rdx, -40(%rbp)     # (rbp - 40) <- rdx, get third argument, dest -> (rbp - 40)
    movl    $0, -8(%rbp)        # (rbp - 8) <- 0, set i = 0
    jmp    .L9                  # jump to L9, loop starts
.L13:
    movl    $0, -4(%rbp)        # (rbp - 4) <- 0, set j = 0
    jmp    .L10                 # jump tp L10, nested loop starts
.L12:
    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    movslq    %eax, %rdx        # rdx <- eax, set rdx = i
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set rax = str + i 
    movzbl    (%rax), %edx      # edx <- rax, move and zero padding the destination register
    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = j
    movslq    %eax, %rcx        # rcx <- eax, set rcx = j
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), store str pointer to rax
    addq    %rcx, %rax          # rax <- rcx + rax, set rax = str + j
    movzbl    (%rax), %eax      # eax <- rax, move and zero padding the destination register
    cmpb    %al, %dl            # compare al and dl, check comparison of str[i] and str[j]
    jge    .L11                 # continue to increment if (str[i] >= str[j]) (jump greather than or equal)

    # temp = str[i]

    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    movslq    %eax, %rdx        # rdx <- eax, set rdx = i
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set rax = str + i
    movzbl    (%rax), %eax      # eax <- rax, set eax = str + i (move and zero padding the destination register)
    movb    %al, -9(%rbp)       # (rbp - 9) <- al, set temp = str[i]

    # str[i] = str[j]

    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = j
    movslq    %eax, %rdx        # rdx <- eax, set rdx = j
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set rax = str + i
    movl    -8(%rbp), %edx      # edx <- (rbp - 8), set edx = i
    movslq    %edx, %rcx        # rcx <- edx, set rcx = i
    movq    -24(%rbp), %rdx     # rdx <- (rbp - 24), set store str pointer to rdx
    addq    %rcx, %rdx          # rdx <- rcx + rdx, set rdx = str + i
    movzbl    (%rax), %eax      # eax <- rax, set eax = str pointer (move and zero padding the destination register)
    movb    %al, (%rdx)         # (rdx) <- al, set str[i] = str[j]

    # str[j] = temp

    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = j
    movslq    %eax, %rdx        # rdx <- eax, set rdx = j
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rax, %rdx          # rdx <- rax + rdx, set rdx = str + j 
    movzbl    -9(%rbp), %eax    # eax <- (rbp - 9), set eax = temp (move and zero padding the destination register)
    movb    %al, (%rdx)         # (rdx) <- al, set str[j] = temp
.L11:
    addl    $1, -4(%rbp)        # (rbp - 4) <- (1 + rbp) - 4, set j = j + 1
.L10:
    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = j
    cmpl    -28(%rbp), %eax     # compare (rbp - 28) and eax, check comparison of j and len
    jl    .L12                  # jump to L12 if j < len (jump less than)
    addl    $1, -8(%rbp)        # (rbp - 8) <- 1 + (rbp - 8), set i = i + 1
.L9:
    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    cmpl    -28(%rbp), %eax     # compare (rbp - 28) and eax, check comparison of i and len
    jl    .L13                  # jump to L13 if i < len (jump less than)
    movq    -40(%rbp), %rdx     # rdx <- (rbp - 40), set rdx = dest
    movl    -28(%rbp), %ecx     # ecx <- (rbp - 28), set ecx = len 
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set rax = str
    movl    %ecx, %esi          # esi <- ecx, store the second argument of reverse (len -> esi)
    movq    %rax, %rdi          # rdi <- rax, store the first argument of reverse 
    call    reverse             # call reverse function
    nop                         # no operation
    leave                       # restore state of base pointer to original
    .cfi_def_cfa 7, 8           # directive for setting computing CFA from register 7 and 8
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
    movq    %rdi, -24(%rbp)     # (rbp - 24) <- rdi, get first argument, str -> (rbp - 24)
    movl    %esi, -28(%rbp)     # (rbp - 28) <- esi, get second argument, len -> (rbp - 28)
    movq    %rdx, -40(%rbp)     # (rbp - 40) <- rdx, get third argument, dest -> (rbp - 40)
    movl    $0, -8(%rbp)        # (rbp - 8) <- 0, set i = 0
    jmp    .L15                 # jump L15, loop starts
.L20:
    movl    -28(%rbp), %eax     # eax <- (rbp - 28), set eax = len
    subl    -8(%rbp), %eax      # eax <- eax - (rbp - 8), set eax = len - i
    subl    $1, %eax            # eax <- eax - 1, set eax = len - i - 1 
    movl    %eax, -4(%rbp)      # (rbp - 4) <- eax, set j = len - i - 1
    nop                         # no operation
    movl    -28(%rbp), %eax     # eax <- (rbp - 28), set eax = len
    movl    %eax, %edx          # edx <- eax, set edx = len
    shrl    $31, %edx           # right shift edx by 31
    addl    %edx, %eax          # eax <- edx + eax 
    sarl    %eax                # eax will now store len / 2
    cmpl    %eax, -4(%rbp)      # compare eax and (rbp - 4), check comparison of len / 2 and j 
    jl    .L18                  # jump to L18 if j < len / 2 (jump less than)
    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    cmpl    -4(%rbp), %eax      # compare eax and (rbp - 4), check comparison of i and j
    je    .L23                  # jump to L23, if(i == j) (jump equal to) break out of nested loop

    # temp = str[i]

    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    movslq    %eax, %rdx        # rdx <- eax, set rdx = i
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set rax = str + i
    movzbl    (%rax), %eax      # eax <- rax, move and zero padding the destination register
    movb    %al, -9(%rbp)       # (rbp - 9) <- al, set temp = str[i]

    # str[i] = str[j]

    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = j
    movslq    %eax, %rdx        # rdx <- eax, set rdx = j
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set rax = str + j
    movl    -8(%rbp), %edx      # rdx <- (rbp - 8), set edx = i
    movslq    %edx, %rcx        # rcx <- eax, set rcx = i
    movq    -24(%rbp), %rdx     # rdx <- (rbp - 24), set store str pointer to rdx
    addq    %rcx, %rdx          # rdx <- rdx + rcx, set rdx = str + i
    movzbl    (%rax), %eax      # eax <- rax, move and zero padding the destination register
    movb    %al, (%rdx)         # (rdx) <- al, set str[i] = str[j]

    # str[j] = temp

    movl    -4(%rbp), %eax      # eax <- (rbp - 4), set eax = j
    movslq    %eax, %rdx        # rdx <- eax, set rdx = j
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rax, %rdx          # rdx <- rdx + rax, set rax = str + j
    movzbl    -9(%rbp), %eax    # eax <- (rbp - 9), set eax = temp (move and zero padding the destination register)
    movb    %al, (%rdx)         # (rdx) <- al, set str[j] = temp 
    jmp    .L18                 # continue loop
.L23:
    nop                         # no operation
.L18:
    addl    $1, -8(%rbp)        # (rbp - 8) <- 1 + (rbp - 8), set i = i + 1
.L15:
    movl    -28(%rbp), %eax     # eax <- (rbp - 28), set eax = len
    movl    %eax, %edx          # edx <- eax, set edx = len
    shrl    $31, %edx           # right shift edx by 31
    addl    %edx, %eax          # eax <- edx + eax
    sarl    %eax                # eax now has value len / 2 
    cmpl    %eax, -8(%rbp)      # compare eax and (rbp - 8), check comparison of len / 2 and i
    jl    .L20                  # jump to L20 if (i < len / 2) (jump less than)
    movl    $0, -8(%rbp)        # (rbp - 8) <- 0, set i = 0
    jmp    .L21                 # jump to L21, check for loop termination
.L22:
                           
    # Label for setting dest[i] = str[i] and incrementing i

    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    movslq    %eax, %rdx        # rdx <- eax, set rdx = i
    movq    -24(%rbp), %rax     # rax <- (rbp - 24), set store str pointer to rax
    addq    %rdx, %rax          # rax <- rdx + rax, set rax = str + i
    movl    -8(%rbp), %edx      # edx <- (rbp - 8), set edx = i
    movslq    %edx, %rcx        # rcx <- edx, set rcx = i
    movq    -40(%rbp), %rdx     # rdx <- (rbp - 40), set store dest pointer to rdx
    addq    %rcx, %rdx          # rdx <- rdx + rcx, set rdx = dest + i
    movzbl    (%rax), %eax      # eax <- (rax), move and zero padding the destination register
    movb    %al, (%rdx)         # set dest[i] = str[i]
    addl    $1, -8(%rbp)        # (rbp - 8) <- 1 + (rbp - 8), set i = i + 1 
.L21:
    movl    -8(%rbp), %eax      # eax <- (rbp - 8), set eax = i
    cmpl    -28(%rbp), %eax     # compare (rbp - 28) and eax, check comparison of len and i
    jl    .L22                  # jump to L22 (to set dest[i] = str[i]) if(i < len) (jump less than)
    nop                         # no operation
    nop                         # no operation
    popq    %rbp                # pop base pointer rbp
    .cfi_def_cfa 7, 8           # directive for setting computing CFA from register 7 and 8
    ret                         # return from reverse function
    .cfi_endproc                # end of sort, closes its unwind entry previously opened by .cfi_startproc

.LFE3:
    .size    reverse, .-reverse
    .ident    "GCC: (GNU) 12.1.1 20220730"      # GCC information
    .section    .note.GNU-stack,"",@progbits
