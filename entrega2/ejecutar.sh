#!/bin/bash

name=`echo $1 | sed 's/....$//g'`

make
./tiger $1 > $name-tiger.txt
cp $name-tiger.txt /home/npellejero/public_html/salida.txt
gcc -c runtime.c
gcc -c file.s -ggdb -Wall -Wno-unused-function -Wunused-result -Wno-unused-result
gcc -o file file.o runtime.o
./file > $name.txt
cp $name.txt /home/npellejero/public_html/salida2.txt

