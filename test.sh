#!/bin/bash

declare -a myArray=(1 2 3 4)

declare -i posicion=0

for element in ${myArray[@]}; do

	echo "[+] Elemento en la posicion [$posicion] -> $element"
	let posicion+=1

done

declare -i totalValues=${#myArray[@]}
echo "[+] Total de elementos en el array -> $totalValues"

#echo "$((${myArray[0]} + ${myArray[-1]}))"

myArray+=(5)

echo ${myArray[@]}

unset myArray[0]
unset myArray[-1]

myArray=(${myArray[@]})

unset myArray[0]
unset myArray[-1]

myArray=(${myArray[@]})

echo ${myArray[@]}

if [ "${#myArray[@]}" -eq 1 ]; then

	echo "Tenemos un unico elemento"

else

	echo "Tenemos más elementos"

fi
