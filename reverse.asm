# Andrii Ieroshenko, version Count Ones
# Registers use: x1: logistical use for saving final result to M[0x10010004],
#                x2: initial M[0x10010000] value loaded here, then it will be logically shifted right to extract each subsequent bit 
#                x3: counter for the loop, 
#                x4: store reversed bits and logically shift left by 1 every loop to work with the next bit every loop
#                x5: store result of AND'ing x2 to extract rightmost bit (LSB)
#                x6: store WIP final number
# Pseudocode:
# x2 =  M[0x10010000];
# x3 = 32;
# x4 = 0;
# x5 = 0;
# while (x3 > 0){
#     x5 = x2 and 1;
#     x4 = x4 or x5;
#     x4 = x4 shifted left logically by 1;
#     x2 = x2 shifted right logically by 1;
#     x3 -= 1;
# }
# M[0x10010004] = x4;

.globl main
main:
    lw x2, 0x10010000 # x2 <- M[0x10010000]
    ori x3,x0,32 # x3 <- 32
    andi x4,x4,0x0 # clear x4
    andi x5,x5,0x0 # clear x5
loop:
    andi x5, x2, 1 # x5 <- x2 and 1
    or x4, x4, x5 # x4 <- x4 or x5
    add x6, x4, x0 # copy our work to x6 where we store WIP final number before shifting x4
    slli x4, x4, 1 # logically shift left x4 by 1
    srli x2, x2, 1 # logically shift right x2 by 1
    addi x3, x3, -1 # decrement counter
    bgtz x3, loop # initiate another cycle of the loop if counter > 0
done:
    sw x6, 0x10010004, x1 # M[0x10010004] <- x4

#.data 
#numbers: 0x00000025 #plug in numbers for testing if needed
