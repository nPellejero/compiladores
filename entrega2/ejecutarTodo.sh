#!/bin/bash

cd $1

for archivo in *.tig
do
	echo $archivo
	cd ../../../entrega2
	./ejecutar.sh $1$archivo	
	cd $1
done




