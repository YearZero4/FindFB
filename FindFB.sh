#!/data/data/com.termux/files/usr/bin/bash

GREEN="\033[1;32m"
WHITE="\033[1;37m"
clear
echo -e -n "${WHITE}Introduzca el nombre de usuario -> ${GREEN}"
read username
nombre=$(echo "$username" | sed 's/ /-/g')
url="https://es-la.facebook.com/public/$nombre"
respuesta=$(curl -s "$url")
if [ -z "$respuesta" ]; then
echo -e "${WHITE}No se pudo obtener datos de la URL. Verifica tu conexión a internet o el nombre de usuario."
exit 1
fi
id=$(echo "$respuesta" | grep -oP 'href="\K[^"]+' | grep 'people' | grep -i "$nombre" | sort | uniq | grep -oP 'id=\K\d+')
name=$(echo "$respuesta" | grep -oP 'href="\K[^"]+' | grep 'people' | grep -i "$nombre" | sort | uniq | grep -v 'photos')
if [ -z "$name" ]; then
echo -e "${WHITE}No se encontraron coincidencias para ese nombre de usuario."
exit 1
fi
names=($(echo "$name" | cut -d'/' -f5))
ids=($(echo "$id"))
echo ""
for i in "${!names[@]}"; do
user=$(echo "${names[i]}" | sed 's/-/ /g')
echo -e "${WHITE}[${GREEN}*${WHITE}] Facebook -> ${GREEN}https://www.facebook.com/profile.php?id=${ids[i]} ${WHITE}${user}"
done
