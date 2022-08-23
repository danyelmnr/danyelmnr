#!/bin/bash

#Script que realiza uma faxina em um sistema linux
#Autor: Danyel Mendes
#e-mail: danyel.mendes.ramos@gmail.com

#atualizando o sistema
echo "Task 1: Update system...\n"
apt-get update && apt-get upgrade -y

#removendo lixo e pacotes temporarios de programas instalados que foram atualizados
echo "Task 2: Removing junk and temporary packages...\n"
du -h /var/cache/apt/archives/
apt-get clean && apt-get autoclean
apt-get autoremove apt-get

#Limpando a Lixeira do linux
echo "Task 3: Removing junk and temporary packages...\n"
rm -Rf ~/.local/share/Trash/files/*

#limpando os kernels que n�o s�o mais utilizados e que continuam no seu hard disk
echo "Task 4: Cleaning the kernels that are no longer used...\n"
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge

#limpando os caches
echo "Task 5: Cleaning caches...\n"
echo 3 >/proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3
#faz com que todo o cache do sistema de aquivos que est� temporariamente armazenado na mem�ria cache,
#seja despejado em disco e liberado, prevenindo assim que se tenha perda de dados.
sync
echo 1 >/proc/sys/vm/drop_caches
#Liberar pagecache, inodes e dentries:
echo 3 >/proc/sys/vm/drop_caches
