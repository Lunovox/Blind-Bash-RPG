#!/bin/bash

clear


read -p "Digite o numero de versão (exemplo: 2.1.2):" version
if [[ ${#version} -lt 3 ]]; then #onta caracteres
	clear
	echo "Versão '$version' não aceita!"
	echo "Formato aceito: '<version_maior>.<version_minor>.<bug_fix>'"
	echo "	* <version_maior>...: Quantas vezes esse programa foi completamente recriado."
	echo "	* <version_minor>...: Quantas recursos novos foram adicionados neste mesmo programa."
	echo "	* <bug_fix>.........: Quantos bugs/defeitos foram corrigidos neste mesmo programa."
	echo "Exemplo: '2.1.2'"
	exit; 
fi #Cancela a criação do pacote
sed -i 's/<VERSION>/$version/' blind-bash-rpg/DEBIAN/control
sed -i 's/<VERSION>/$version/' blind-bash-rpg/usr/bin/blind-bash-rpg
cd blind-bash-rpg/
find usr/ -type f -exec md5sum {} \; > DEBIAN/md5sums
cd ..
dpkg-deb -b ./blind-bash-rpg/ ./Packages
sed -i 's/$version/<VERSION>/' blind-bash-rpg/DEBIAN/control
sed -i 's/<VERSION>/$version/' blind-bash-rpg/usr/bin/blind-bash-rpg
