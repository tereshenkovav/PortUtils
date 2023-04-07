#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/io.h>

#define BASE 0x378
#define TIME 500000

int main () {
	int x = 0xAA;
	int y = 0x55;
	printf ("Writing to parallel port!\n");
	if (ioperm (BASE, 3, 1)) {
		perror ("ioperm()");
		exit (77);
	}
	while (1) {
		outb (x, BASE);
		usleep (TIME);
		outb (y, BASE);
		usleep (TIME);
	}
return 0;
}
