# Andrii Ieroshenko, version Count Ones
# Registers use: x1: logistical use for saving result to memory
#                x2: (shifted) M[0x10010000], 
#                x3: counter for the loop, 
#                x4: count of 1s in M[0x10010000],
#                x5: store result of AND'ing
# Pseudocode:
# x2 =  M[0x10010000];
# x3 = 32;
# x4 = 0;
# while (x3 > 0){
#     x4 += x2 and 1;     
#     x3 -= 1;
#     x2 = x2 shifted right lofically by 1;
# }
# M[0x10010004] = x4;
#
# Questions and answers for part 1:
# Q: What is the total calculated by adding the 10 numbers?
# A: 0xabcdef00

# Q: Describe how register x2 is used by the program.  (What does it represent?)
# A: It is used as a pointer, to store addresses of/point to the numbers to be added to sum. 
#    On line 9, address of the beginning of tbl label memory loaded into it (it points to 1st word/number to be added
#    and each subsequent word is a next number to be added)
#    On line 11, value of x2 is used as an memory adress and value from this address is loaded into x3 (next number to be added)
#    On line 12, value of x2 is incremented by 0x4 so it now "points" to next word/number to be added 

# Q:Why is x2 incremented by 4 in the instruction at 0x00400018?
# A: Because this way (due to addnums logic and data from data.asm) x2 will point to the next word at tbl label/to the next number
#    to be added

# Q:Why is the value 10 loaded into x4?
# A: Because x4 serves as a loop counter: it is decremented by 1 at line 14 by, checked vs 0 at line 15 and new loop is 
#    initiated if it is > 0. And program is designed to run 10 times/add 10 numbers

.text
.globl main
main:
    lw x2, 0x10010000 # x2 <- M[0x10010000]
    ori x3,x0,32 # x3 <- 32
    andi x4,x4,0x0 # clear x4
    andi x5,x5,0x0 # clear x5
loop:
    andi x5, x2, 1 # x5 <- x2 and 1
    add x4, x4, x5 # add the result of and'ing to the count of 1s
    srli x2, x2, 1 # logically shift x2 by 1
    addi x3, x3, -1 # decrement counter
    bgtz x3, loop # initiate another cycle of the loop if counter > 0
done:
    sw x4, 0x10010004, x1 # M[0x10010004] <- x4

#.data 
#numbers: 0x68F6 #plug in numbers for testing if needed
