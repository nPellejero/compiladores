#include <stdio.h>
//#include "runtime.h"

//char s[] = "Hola\n";

int f(int x, int i, int h, int g, int f, int d, int e, int j, int k)
{
	return x+1+e+j+k;
}

int g(int x, int i, int h, int g, int f, int d, int e, int j, int k)
{
 	printf("chau\n");
 	printf("%d %d\n",1,2);
 	printf("%f %f\n",1.1,2.2);
	return x+1+e+j+k;
}
int main(int argc, char **argv)
{
	f(5,6,7,8,9,1,2,4,111);
	g(5,6,7,8,9,1,2,4,111);

 //	string *h;

//	h->length = 4;
//	h->chars[0] = s[0];

//	print(h);

	return 0;
}
