#!/bin/bash

#make
#./tiger ../tests/good/sumatest.tig > /home/npellejero/public_html/salida.txt
gcc -c file.s -ggdb -Wall -Wno-unused-function -Wunused-result -Wno-unused-result
gcc -o file file.o

