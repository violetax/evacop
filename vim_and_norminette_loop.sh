#!/bin/bash

# UTILIDAD → para cada archivo del ARRAY cfiles do →
#	vim
#	norminette 
#####################################################################################################################################
#																																	#
#	WHILE norminette NOT ok, VIM AGAIN, y ADEMAS → te append el output de norminette al archivo, y lo vuelve a borrar al cerrar vim #
#
#	cuancdo norminette OK → 

#	WHILE gcc NOT ok, VIM AGAIN, y ADEMAS → te append el STANDERROR (los errores ) de gcc al archivo, y lo vuelve a borrar al cerrar vim #
#																																	#
#####################################################################################################################################
#
#	Cunando norminette y gcc OK, ejecuta a.out
#
#	Y pide input para volver a vim el archivo una vez mas, o continuar: con el siguiente si hay mas archivos c, o terminar
#

#source Asksure.fu
#source Opte.fu
#source Continua.fu

function asksure() {
	echo -e "\033[38;5;118mAURRERA \033[38;5;15medo \033[38;5;9mEZ"

	while read -r -n 1 -s answer 
	do
		if [[ ${answer} = [AaEe] ]]; then
			[[ ${answer}  = [Aa] ]] && retval=0
			[[ ${answer}  = [Ee] ]] && retval=1
			break
		fi
	done
	echo -e "\033[38;5;228m"  # for visuals...
	return ${retval}  
}


function opte() {
	workdir=$HOME/violetapiscina/pruebas/emptypru
	dfile=$0
	dfilename=$(echo $dfile | awk -F "/" '{print $NF}' )
	dfilepath=$(echo $dfile | awk -F "/" '{NF--; print}' | tr " " "/" )

	cp ${dfile} ${workdir} 
	[[ $1 ]] && vim +$1 ${workdir}/${dfilename} || vim ${workdir}/${dfilename}
	mv ${workdir}/${dfilename} ${dfilepath} 
}
#

function continua() {
	read -n 1 -r -s -p $'💫 Continúa 👉 pulsa cualquier tecla para ello!! \n'
	echo
}
#

while getopts ":eh" o; do
case ${o} in
		e)
			opte
			exit
			;;
		h)
			whatis
			exit
			;;
		\?)
			echo -e "Nein nein nein option → ${o}"
			exit
			;;
	esac
done
shift $((OPTIND-1))


function continua() {
	read -n 1 -r -s -p $'💫 Continúa 👉 pulsa cualquier tecla para ello!! \n'
	echo
}

## ARRAY : 
cfiles=( "ex04/ft_str_is_lowercase.c" "ex05/ft_str_is_uppercase.c" "ex06/ft_str_is_printable.c" "ex07/ft_strupcase.c" "ex08/ft_strlowcase.c" "ex09/ft_strcapitalize.c" "ex10/ft_strlcpy.c" "ex11/ft_putstr_non_printable.c" "ex12/ft_print_memory.c" )

#cfiles=( "ex00/ft_strcpy.c" "ex01/ft_strncpy.c" "ex02/ft_str_is_alpha.c" "ex03/ft_str_is_numeric.c" "ex04/ft_str_is_lowercase.c" "ex05/ft_str_is_uppercase.c" "ex06/ft_str_is_printable.c" "ex07/ft_strupcase.c" "ex08/ft_strlowcase.c" "ex09/ft_strcapitalize.c" "ex10/ft_strlcpy.c" "ex11/ft_putstr_non_printable.c" "ex12/ft_print_memory.c" )

######## TO DO → que no haya que editarlo manualmente cada vez que cierras la script, y ya has avanzado

function limpiaErr() {
	cf=$1
	[[ $(grep "[Ee]rror" ${cf}) ]] && sed -i '' "/[Ee]rror/,/^Error/d" ${cf}
}

function passLaNormi() {
	cf=$1
	normioutp="${cf}.normi"
	limpiaErr ${cf}  

	norminette ${cf} >| ${normioutp}

	if [[ -e ${normioutp} && ! $(grep "OK" ${normioutp}) ]]
	then
		cat ${normioutp} >> ${cf}
	elif [[ -e ${normioutp} && $(grep "OK" ${normioutp}) ]]
	then
		echo -e "normi OK"
		sleep 1
		limpiaErr ${cf}
		normi=true
	else
		limpiaErr ${cf}
		normi=true
	fi
}

function gccIt() {
	cf=$1
	gccout="${cf}.gci"
	limpiaErr ${cf}
	gcc -fsanitize=address -g3 -Wall -Wextra -Werror ${cf} 2>|${gccout}
	[[ ! -s ${gccout} ]] && rm ${gccout} && echo "removed gcc" || ls ${gccout}
	if [[ -e ${gccout} ]]
	then
		cat ${gccout} >> ${cf}
		rm ${gccout}
		echo -e "gcc WRONG"
		sleep 1
		vim -c 'set number' ${cf}
	else
		gcci=true
		echo -e "gcc OK"
		sleep 1
	fi
}

#set -x # uncomment para debug
for cf in "${cfiles[@]}" 
do
	normi=false
	gcci=false
#	[[ $(sed "1p" ${cf} | grep "\*\*\*\*" )  ]] && sed -i '' "1,12d" ${cf}  
	while [[ ${normi} = false ]]
	do
		vim -c 'set number' ${cf} && continua
		passLaNormi ${cf}  
	done

	while [[ ${gcci} = false ]]
	do 
		gccIt ${cf} && continua
	done

	if [[ ${gcci} = true ]]
	then
		clear
		echo -e "\033[38;5;195mOUTPUT \033[38;5;190ma.out \033[38;5;195mde \033[38;5;218m ${cf} \033[0m  → "
		echo -e "-------------------------------------------------------------------"
		./a.out
		echo -e "-------------------------------------------------------------------"
		echo -e "\n👉 \033[38;5;195m Pulsa \033[38;5;118ma \033[38;5;195m(aurrera) para continuar\033[38;5;195m\n👉 o pulsa \033[38;5;9me \033[38;5;195m(ez) para volver a \033[38;5;118m vim \033[38;5;228m${cf} \033[0m "    
		if asksure; then
			echo
		else
			vim -c 'set number' ${cf}
		fi
	fi
done
 

# directorioRoot 				---- la script esta, y SE LANZA desde, aqui
# directorioRoot/copiasconMAIN
# directorioRoot/ex00
# directorioRoot/ex01
# directorioRoot/ex02
# directorioRoot/ex03
# directorioRoot/ex04
# directorioRoot/ex05
# directorioRoot/ex06
# directorioRoot/ex07
# directorioRoot/ex08
# directorioRoot/ex09
# directorioRoot/ex10
# directorioRoot/ex11
# directorioRoot/ex12


