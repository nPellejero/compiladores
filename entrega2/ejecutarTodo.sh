#!/bin/bash

cd ../tests/good/

for archivo in *.tig
do
	#echo $archivo
	cd ../../entrega2
	./ejecutarB.sh ../tests/good/$archivo	
	cd ../tests/good/
done




