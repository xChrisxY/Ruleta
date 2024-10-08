#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Añadir función del dinero ganado

function ctrl_c() {

	echo -e "\n\n${redColour} Saliendo...${endColour}\n"
	tput cnorm; exit 1

}

# Ctrl + C
trap ctrl_c INT

function helpPanel() {

	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso: ${endColour}${purpleColour}$0${endColour}"
	echo -e "\t${blueColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
	echo -e "\t${blueColour}-t)${endColour}${grayColour} Técnica a utilizar${endColour} ${purpleColour}(martingala/inverseLabrouchere${endColour})\n"
	exit 1

}

function martingala() {

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}\$${yellowColour}$money${endColour}"
	echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿Cuánto dinero tienes pensando apostar? -> ${endColuour}" && read initial_bet
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

	echo -e "${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de ${endColour}${yellowColour}\$$initial_bet${endColour} a ${yellowColour}$par_impar${endColour}"

	backup_bet=$initial_bet
	player_counter=1
	jugadas_malas="[ "

	tput civis # Ocultar el cursor
	while true; do

		money=$(($money-$initial_bet))
		#echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar ${endColour} ${yellowColour}\$$initial_bet${endColour} ${grayColour}y tienes ${endColour}${yellowColour}$money${endColour}"
		random_number="$(($RANDOM % 37))"

		echo $random_number

		#echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el número ${endColour}${blueColour}$random_number${endColour}"
		
		if [ ! "$money" -lt 0 ]; then

			if [ "$par_impar" == "par" ]; then

				if [ "$(($random_number % 2))" -eq 0 ]; then

					if [ "$random_number" -eq 0 ]; then
						#echo -e "${redColour}[+] Ha salido el 0, por tanto perdemos${endColour}"
						initial_bet=$(($initial_bet*2)) 
						jugadas_malas+="$random_number "
						#echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en ${endColour}${yellowColour}\$$money${endColour}"
					else
						#echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es par, !ganas!${endColour}"
						reward=$(($initial_bet*2))
						#echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de ${endColour}${yellowColour}\$$reward${endColour}"
						money=$(($money+$reward))
						#echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}$money${endColour}"
						initial_bet=$backup_bet
						jugadas_malas="[ "
					fi
				else
					#echo -e "${yellowColour}[+]${endColour}${redColour} El número que ha salido es impar, ¡pierdes!${endColour}"
					initial_bet=$(($initial_bet*2)) 
					jugadas_malas+="$random_number "
					#echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en ${endColour}${yellowColour}\$$money${endColour}"

				fi
				
			else # Se ha escogido impar // En esta función no hace falta evaluar si cae 0

				if [ "$(($random_number % 2))" -eq 1 ]; then

					#echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es par, !ganas!${endColour}"
					reward=$(($initial_bet*2))
					#echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de ${endColour}${yellowColour}\$$reward${endColour}"
					money=$(($money+$reward))
					#echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}$money${endColour}"
					initial_bet=$backup_bet
					jugadas_malas="[ "

				else
					initial_bet=$(($initial_bet*2)) 
					jugadas_malas+="$random_number "

				fi
				

			fi

		else
			# Nos quedamos sin dinero
			echo -e "\n${redColour}[!] Te has quedado sin pasta cabrón${endColour}\n"
			echo -e "${yellowColour}[+]${endColour} ${grayColour}Han habito un total de ${endColour}${yellowColour}$player_counter ${endColour}${grayColour}jugadas${endColour}"
			echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
			echo -e "${blueColour}$jugadas_malas]${endColour}\n"
			
			tput cnorm; exit 0

		fi

		let player_counter+=1 # agregar let por buenas prácticas

	done

	tput cnorm # Recuperamos el cursor
}


function inverseLabrouchere() {

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual: ${endColour}\$${yellowColour}$money${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

	declare -a my_secuence=(1 2 3 4)

	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comenzamos con la secuencia${endColour} ${greenColour}[${my_secuence[@]}]${endColour}"

	bet=$((${my_secuence[0]} + ${my_secuence[-1]}))

	#unset my_secuence=${my_secuence[0]}
	#unset my_secuence=${my_secuence[-1]}

	#my_secuence=(${my_secuence[@]})

	#echo -e "${yellowColour}[+]${endColour} ${grayColour}Invertimos ${endColour}${yellowColour}\$$bet${endColour}${grayColour} y nuestra secuencia se queda en${endColour}${greenColour} [2 3]${endColour}"

	tput civis
	while true; do
		
		random_number=$(($RANDOM % 37))
		money=$(($money - $bet))
		echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos ${endColour}${yellowColour}\$$money${endColour}"

		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número ${endColour}${blueColour}$random_number${endColour}"

		if [ $par_impar == "par" ]; then

			if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then 
				
				echo -e "${yellowColour}[+]${endColour}${grayColour} El número es par, ¡ganas!${endColour}"
				reward=$(($bet * 2))
				let money+=$reward
				echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes ${endColour}${yellowColour}$money${endColour}"

				my_secuence+=($bet)
				my_secuence=(${my_secuence[@]})

				echo -e "${yellowColour}[+]${endColour} ${grayColour} Nuestra nueva secuencia es ${endColour}${greenColour}[${my_secuence[@]}]${endColour}"
				if [ "${#my_secuence[@]}" -ne 1 ]; then
					bet=$((${my_secuence[0]} + ${my_secuence[-1]}))
				elif [ "${#my_secuente[@]}" -eq 1]; then
					bet=${my_secuence[0]}
				fi

			elif [ "$random_number" -eq 0 ]; then
				echo -e "${redColour}[!] Ha salido el número cero, ¡pierdes!${endColour}"
			else
				echo -e "${redColour}[!] El número es impar, ¡pierdes!${endColour}"
			fi

		fi
		
		sleep 5
	done
	tput cnorm

}

while getopts "m:t:h" arg; do

	case $arg in 

		m) money="$OPTARG";;
		t) technique="$OPTARG";;
		h) helpPanel;;

	esac

done

if [ $money ] && [ $technique ]; then

	 if [ $technique == 'martingala' ]; then
		 martingala
	 elif [ "$technique" == 'inverseLabrouchere' ]; then
		 inverseLabrouchere

	 else
		 echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}\n"
		 helpPanel
	 fi
else
	helpPanel
fi
