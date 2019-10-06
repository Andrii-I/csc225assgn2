.text
.globl main
main:
#	lw t1, done	#oops, can't lw from text segment.
	lw t1, blah	# t1 <- 0x12345678
	la t2, blah	# t2 <- address of blah, 0x01001000 (howdoweknowthis?)
	lw t3,(t2)	# t3 <- M[t2] = 0x12345678
	lb t4, 4(t2)	# t4 <- M[0x01001000+4] = ?aa
	lbu t5, 4(t2)	# t5 <- M[0x01001000+4] = ?aa
	la t6, junk	# t6 <- 0x10010008
	lb t6, -1(t6)	# t1 <- M[0x01001008-1] = aa, bb or ?
	sw t5, blah, t6 # what changed in memory?


#exit the program
done:
    li  a7, 10          # service 10 is exit
    ecall
.data

blah:	.word	0x12345678
byteme:	.byte	0xaa
byteU:	.byte	0xbb
junk:	.word	0x11223344

