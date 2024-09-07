bf: bf.o
	ld bf.o -o bf
	rm bf.o
bf.o: code/main.asm
	nasm -felf64 code/main.asm -O0 -o bf.o
