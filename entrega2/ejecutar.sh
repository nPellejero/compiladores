#!/bin/bash


make
./tiger $1 > /home/npellejero/public_html/salida.txt
#gcc -c runtime.c
gcc -c file.s -ggdb -Wall -Wno-unused-function -Wunused-result -Wno-unused-result
gcc -o file file.o runtime.o

