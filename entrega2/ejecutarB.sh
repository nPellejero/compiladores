#!/bin/bash


make
./tiger $1 > /home/jbaruffaldi/public_html/salida.txt
#gcc -c runtime.c
gcc -c file.s -ggdb -Wall -Wno-unused-function -Wunused-result -Wno-unused-result
gcc -o file file.o runtime.o
name=`echo $1 | sed 's/....$//g'` 
./file > $name.txt 
cp $name.txt /home/jbaruffaldi/public_html/salida2.txt
