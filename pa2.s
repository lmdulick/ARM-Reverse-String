.section .data

prompt  : .asciz "Please enter a string: \n"
formatInput  : .asciz "%[^\n]"
formatOutput : .asciz "%c"
formatNewLine: .asciz "\n"
formatEmpty: .asciz "\n\n"
.section .text

.global main

main:
    # prints out prompt: "Please enter a string:"
    ldr x0, = prompt
    bl printf

    # make space for the stack pointer
    sub sp, sp, 16

    # takes in user input
    ldr x0, = formatInput
    mov x1, sp
    bl scanf

    mov x0, sp
    ldrb w1, [x0, 0]

    # detects if the string is empty/no characters are inputted; input == 0 char
    cmp w1, 0
    beq emptyString

    mov x1, 0
    mov x2, 0
    
    # gets length of input
    inputLength:
        ldrb w1, [x0, x2]
        cmp w1, 0
        beq checkLength
        add x2, x2, 1
        b inputLength

    # checks length of input and calls singleChar + reverseSingleChar functions if input == 1 char
    checkLength:
        cmp x2, 1
        beq singleChar
        beq reverseSingleChar

    # if input > 1 char -> reverse the string
    bl reverseString

    # restore the stack pointer
    add sp, sp, 16
    ldr x0, = formatNewLine
    bl printf

    # exit the program when cycle finished
    b exit

# prints out the single char on a new line underneath the user input
singleChar:
    ldr x0, = formatOutput
    ldrb w1, [sp, 0]
    bl printf

    cmp w1, #10

    ldr x0, = formatNewLine
    bl printf

# prints out the single char inputted in reverse (which is the same as just printing out the single char again)
reverseSingleChar:
    ldr x0, = formatOutput
    ldrb w1, [sp, 0]
    bl printf

    # comparison
    cmp w1, #10

    # print new line for single char
    ldr x0, = formatNewLine
    bl printf

    # exit the program
    b exit

# prints two new lines if the inputted string == empty
emptyString:
    ldr x0, = formatEmpty
    bl printf

    b exit

# func reverses the inputted string if input > 1 char
reverseString:
    # make space for the stack pointer again
    sub sp, sp, 16
    stur x30, [sp, 8]
    stur x0, [sp, 0]
    ldrb w1, [x0, 0]

    # compare string to 0
    cmp w1, 0

    # call recursive func
    bne recursivePrint

    # print a new line
    ldr x0, = formatNewLine
    bl printf

    # restore stack pointer
    add sp, sp, 16
    ldur x30, [sp, 8]
    br x30

# recursively print the letters from the inputted string in reverse order
recursivePrint:
    ldr x0, = formatOutput
    bl printf
    ldur x30, [sp, 8]
    ldur x0, [sp, 0]
    add x0, x0, 1

    # call reverseString func
    bl reverseString
    ldur x30, [sp, 8]
    ldur x0, [sp, 0]
    ldrb w1, [x0, 0]
    ldr x0, = formatOutput
    bl printf

    ldur x30, [sp, 8]
    ldur x0, [sp, 0]

    # restore stack pointer
    add sp, sp, 16
    br x30

# exit and clean up the program
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret

