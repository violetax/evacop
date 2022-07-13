#!/bin/bash

# ESTA SCRIPT EJECUTA LOS COMANDOS VIM Y GCC SOBRE EL FILE QUE SE LE PASA COMO ARGUMENTO
# Y DESPUES EJECUTA EL a.ot GENERADO
#		%> evacop.sh mifile.c

# DESPUES DE CADA COMANDO (vim y gcc con todas las flags), Y DE LA EJECUCION DE a.out, HAY UNA PAUSA
# Y NO SE REANUDA HASTA QUE SE PULSE CUALQUIER TECLA (es el momento de, si quieres salir de la script,
# pulsar CTRL-C para hacer exit)

# >>>TAMBIEN ES POSIBLE EJECUTAR LA SCRIPT RECURSIVAMENTE SOBRE TODOS LOS C FILES DEL *DIRECTORIO* DESDE 
# DONDE SE LANZA, SI EN LUGAR DE UN FILE, SE LE PASA LA OPTION -r
#		%> evacop.sh -r

# PARA USAR LA SCRIPT, ATENCION AL >> DIRECTORIO << DESDE DONDE SE LANZA
# ES DECIR, ATENCION AL RELATIVE PATH
# PORQUE LOS C FILES SOBRE LOS QUE ACTUA, SE ENCUENTRAN CON UN find DESDE `.` (EL DIRECTORIO ACTUAL)


# EL CODE → 
#SCRIPT VARIABLES 
recursive=false
which_cfile=$1

#SCRIPT FUNCTIONS
function continua() {
	# EL OBJETIVO DE ESTA FUNCION, ES PAUSAR LA EJECUCION DE LA SCRIPT
	# TAL QUE DESPUES DEL vim Y DEL gcc, SE QUEDA ESPERANDO POR UN STDINPUT
	# Y PUEDES PULSAR CUALQUIER TECLA PARA CONTINUAR, O PUEDES DARLE A CTRL-C PARA EXIT
	echo -e "\033[38;5;195m" 
    read -n 1 -r -s -p $'👉 PULSA CUALQUIER LETRA PARA CONTINUAR!! 💫 \n'
    echo -e "\033[0m" 
}

function whatis() {
	# este es una explicacion de la scrip, que se muestra con la option -h
	#       %> evacop.sh -h
	echo -e "\033[38;5;195m run vim, gcc & a.out on \033[38;5;11m\$1\033[38;5;195m ,\033[38;5;9mpero \033[38;5;195msi \033[38;5;11m\$1 \033[38;5;195mes \033[38;5;118mr \033[38;5;195m, entonces se lanzan los 3 pasos sobre todos los c files en el pwd ⚡ "
}	
 
function vim_gcc_execute_continue() {
	# ESTA ES LA FUNCION QUE HACE DE LA EVALUACION ALGO MAS COMODO...
	# SI LLEGAN TODOS LOS c FILES PREPARADOS CON EL int main(), 
	# YA SOLO HAY QUE IR DANDOLE AL ENTER
	# evacop.sh: script para evaluar copias (de las funciones.c con el main)
	which_cfile=$1
	vim ${which_cfile}  
	continua
	gcc -fsanitize=address -g3 -Wall -Wextra -Werror ${which_cfile}
	#TODO : ejecutar a.out solo si gcc no da errores
	# si no es recursivo, con poner un statement continua, suficiente
	# en recursivo, TODO
	./a.out
	continua
}

# GETOPS este es un builtin de bash, para que las scrips cojan opciones
while getopts ":hr" o; do
    case "${o}" in
        h)
            whatis
            exit
            ;;
	r)
	recursive=true
	;;
	\?)
		echo "invalid option: -$OPTARG"
		exit
		;;
    esac
done
shift $((OPTIND-1))


# MAIN
if [[ ${recursive} == true ]]
then
	for cfile in $(find . -name "*c")
	do
		vim_gcc_execute_continue ${cfile}  
	done
else
	vim_gcc_execute_continue ${which_cfile} 
fi	


