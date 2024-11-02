asm: dz.asm
		fasm dz.asm 

c: asm test.c
		gcc -no-pie test.c dz.o -o prog

run: c prog
		./prog

clean:
        rm -f *.o