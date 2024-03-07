bf: bf.o
	ld bf.o -o bf

bf.o: code/bf.asm
	nasm -felf64 code/bf.asm -O0 -o bf.o
