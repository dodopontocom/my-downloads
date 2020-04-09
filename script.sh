#!/bin/bash
# help on backuping my Downloads folder
# version: 0.1
#
SAVEIFS=$IFS

download_folder="/home/${USER}/Downloads"
bkp_folder="/tmp/download-bkp"
download_new_month="${download_folder}/$(date +%Y_%b)"

[[ -d ${download_new_month} ]] || mkdir ${download_new_month}

ignore_folders=($(find ${download_folder} -maxdepth 1 -type d | grep -v "^.$" | grep -v "${download_new_month}" | tr '\n' ' '))

#antes de tudo, encontrar diretorios/pastas e joga-los na pasta backup do mes
for i in ${ignore_folders[@]}; do
    IFS=$(echo -en "\n\b")
    mv ${i} ${download_new_month}/
    IFS=$SAVEIFS
done

#lista de possíveis extensoes, as mais comuns que eu tenho/baixo
types=(doc docx pdf jpg png mp3 mp4 avi mkv deb iso gz zip srt epub rar txt sh torrent)

#criar pastas dentro da pasta do mes com os nomes das extensoes e jogar os arquivos relacionados la
for t in ${types[@]}; do
    [[ -d ${download_new_month}/${t^^} ]] || mkdir ${download_new_month}/${t^^}
    IFS=$(echo -en "\n\b")
    for i in $(find ${download_folder} -type f -iname "*.${t}" | grep -v "${download_new_month}"); do
        mv ${i} ${download_new_month}/${t^^}
    done
    IFS=$SAVEIFS
done

#se sobrar arquivos(extensoes nao listadas anteriormente) entao jogar esses arquivos soltos na pasta do mes
IFS=$(echo -en "\n\b")
for r in $(find ${download_folder} -type f -iname "*" | grep -v "${download_new_month}"); do
    mv ${r} ${download_new_month}
done
IFS=$SAVEIFS

