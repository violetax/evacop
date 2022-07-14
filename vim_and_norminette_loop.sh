#!/bin/bash

# UTILIDAD → para cada archivo del ARRAY cfiles do →
#	vim
#	norminette 
#####################################################################################################################################
#																																	#
#	WHILE norminette NOT ok, VIM AGAIN, y ADEMAS → te append el output de norminette al archivo, y lo vuelve a borrar al cerrar vim #
#																																	#
#####################################################################################################################################
#	if norminette OK →  gcc 
#	if gcc OK → ./a.out (if not ok, salva el output de gcc a un archivo, y te muestra el cat)
#	continua()




function continua() {
	read -n 1 -r -s -p $'💫 Continúa 👉 pulsa cualquier tecla para ello!! \n'
	echo
}

## ARRAY : 
cfiles=( "ex03/ft_str_is_numeric.c" "ex04/ft_str_is_lowercase.c" "ex05/ft_str_is_uppercase.c" "ex06/ft_str_is_printable.c" "ex07/ft_strupcase.c" "ex08/ft_strlowcase.c" "ex09/ft_strcapitalize.c" "ex10/ft_strlcpy.c" "ex11/ft_putstr_non_printable.c" "ex12/ft_print_memory.c" )

#cfiles=( "ex00/ft_strcpy.c" "ex01/ft_strncpy.c" "ex02/ft_str_is_alpha.c" "ex03/ft_str_is_numeric.c" "ex04/ft_str_is_lowercase.c" "ex05/ft_str_is_uppercase.c" "ex06/ft_str_is_printable.c" "ex07/ft_strupcase.c" "ex08/ft_strlowcase.c" "ex09/ft_strcapitalize.c" "ex10/ft_strlcpy.c" "ex11/ft_putstr_non_printable.c" "ex12/ft_print_memory.c" )

######## TO DO → que no haya que editarlo manualmente cada vez que cierras la script, y ya has avanzado


# set -x # uncomment para debug
for cf in "${cfiles[@]}" 
do
	normioutp="${cf}.normi"
	gccout="${cf}.gci"
	[[ $(sed "1p" ${cf} | grep "\*\*\*\*" )  ]] && sed -i '' "1,12d" ${cf}  
	let whis=1
	while [ ${whis} -eq 1 ]
	do
		[[ -e ${normioutp} &&  $(sed -ne "2p" ${normioutp}) ]] && cat ${normioutp} >> ${cf}
	   	vim -c 'set number' ${cf}
		[[ $(grep "Error:" ${cf}) ]] && sed -i '' "/Error/,/^Error/d" ${cf}
		clear
		norminette ${cf} >| ${normioutp}  
		let whis=$?
		[[ ${whis} -eq 0 ]] && gcc -fsanitize=address -g3 -Wall -Wextra -Werror ${cf} 2> ${gci} && gret=$? && rm -f ${normioutp}
		[[ ${gret} -eq 0 ]] && ./a.out || cat ${gci}
		continua
	done
   continua
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


