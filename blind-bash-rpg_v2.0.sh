#!/bin/bash
#source incl.sh

NARRADOR="ATIVADO"
DIFICULDADE="NORMAL"
FILE_BASE="${HOME}/.config/BlindBashRPG/"
FILE_SAVE="BlindBashRPG.sav"
FILE_CONF="BlindBashRPG.conf"
NOME=""
ANDAR=1
NIVEL=1
POCOES=0
HP_MAX=100
HP_NOW=100
IF_POTION_FOUND=0
IF_STAIR_FOUND=0

function _OPEN_CONF () {
	if ! [ -e $FILE_BASE ]; then
		mkdir $FILE_BASE
		#echo $FILE_BASE
		#read -n 1
	fi
	
	#FILE_SAVE="BlindBashRPG.sav"
	#FILE_CONF="BlindBashRPG.conf"
	conf="${FILE_BASE}${FILE_CONF}"
	if [ -f $conf ]; then
		NARRADOR=$(cat $conf | grep "NARRADOR" | cut -d "=" -f 2 | tr -d " ")
		DIFICULDADE=$(cat $conf | grep "DIFICULDADE" | cut -d "=" -f 2 | tr -d " ")
	else
		_SAVE_CONF
	fi
}
function _SAVE_CONF () {
	conf="${FILE_BASE}${FILE_CONF}"
	echo "
	NARRADOR = ${NARRADOR} 
	DIFICULDADE = ${DIFICULDADE}
	" > $conf
}	
#----------------------------------------------------------------------
function _SAVE_GAME () {
	_CABECALHO
	conf="${FILE_BASE}${FILE_SAVE}"
	echo "
#-------------------
NOME = ${NOME}
ANDAR = ${ANDAR}
NIVEL = ${NIVEL}
POCOES = ${POCOES}
HP_NOW = ${HP_NOW}
HP_MAX = ${HP_MAX}
#-------------------
	" > $conf
	NARRA="Você anotou sua localização em um papel que estava em seu bolso!"
	#echo $NARRA
	doFala "$NARRA" -p "$NARRA" -op "op"
	_CAUMA
}	
function _OPEN_GAME () {
	conf="${FILE_BASE}${FILE_SAVE}"
	if [ -f $conf ]; then
		NOME=$(cat $conf | grep "NOME" | cut -d "=" -f 2 | tr -d " ")
		ANDAR=$(cat $conf | grep "ANDAR" | cut -d "=" -f 2 | tr -d " ")
		NIVEL=$(cat $conf | grep "NIVEL" | cut -d "=" -f 2 | tr -d " ")
		POCOES=$(cat $conf | grep "POCOES" | cut -d "=" -f 2 | tr -d " ")
		HP_NOW=$(cat $conf | grep "HP_NOW" | cut -d "=" -f 2 | tr -d " ")
		HP_MAX=$(cat $conf | grep "HP_MAX" | cut -d "=" -f 2 | tr -d " ")
		_AUTOEXAME
		_CAUMA
	else
		_CABECALHO
		NARRA="NÃO EXISTE JOGO SALVO!"
		##echo $NARRA
		if [ "$NARRADOR" == "ATIVADO" ]; then
			#doFala "$NARRA" 
			doFala "$NARRA" -p "$NARRA"
		else
			#doFala "$NARRA" "op"
			doFala "$NARRA" -p "$NARRA" -op "op"
		fi
		_MAIN
	fi
}
#----------------------------------------------------------------------
function _MAIN () {
	_CABECALHO
	LOADTEXT=""
	if [ -f "${FILE_BASE}${FILE_SAVE}" ]; then 
		LOADTEXT="\n\t(2) Carregar Jogo;"; 
	fi
	NARRA="
Selecione uma opção do menu principal:

	(1) Novo Jogo; ${LOADTEXT}
	(3) Listar Conquistas;
	(4) Listar Desenvolvedores;
	(5) Configurar Jogo;
	(6) Sair do Jogo;
	"
	#echo "$NARRA"
	doFala "$NARRA" -p "$NARRA" -op "op"
	#read -n 1 -p ">>> " op
	if [ "$op" == "1" ]; then 
		_NOVO;
	elif [ "$op" == "2" ]; then 
		_OPEN_GAME;
	elif [ "$op" == "3" ]; then 
		_SHOW_ACHIEVEMENTS
	elif [ "$op" == "4" ]; then 
		_DELELOPER_CREDITS
	elif [ "$op" == "5" ]; then 
		_CONFIG
	elif [ "$op" == "6" ]; then 
		_SAIRDOJOGO	
	fi
	_MAIN
}
#----------------------------------------------------------------------
function _CONFIG () {
	_CABECALHO
	NARRA="
Selecione uma configuração para alterá-la:

	(1) Narrador: '$NARRADOR';
	(2) Dificuldade: '$DIFICULDADE';
	(3) Voltar ao menu principal;
	"
	doFala "$NARRA" -p "$NARRA" -op "op"
	if [ "$op" == "1" ]; then 
		_TOGGLE_NARRATOR
	elif [ "$op" == "2" ]; then 
		_CHANGE_DIFFICULTY
	elif [ "$op" == "3" ]; then 
		_MAIN	
	fi
	_CONFIG
}
#----------------------------------------------------------------------
function _NOVO () {
	NOME=""
	ANDAR=1
	NIVEL=1
	POCOES=0
	HP_MAX=100
	HP_NOW=100
	_CABECALHO
	NARRA="Digite seu nome: "
	#printf "$NARRA"
	#doFala "$NARRA"
	doFala "$NARRA" -p "$NARRA" -val "NOME"
	#read -p ">>> " NOME
	NOME=$(echo "$NOME" | cut -d " " -f 1)
	_INIT
}
#----------------------------------------------------------------------
function _TOGGLE_NARRATOR () {
	if [ "$NARRADOR" == "ATIVADO" ]; then
		NARRADOR="DESATIVADO"
		pkill 'espeak' > /dev/null
		espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "O narrador do jogo agora está '$NARRADOR'."
	else
		NARRADOR="ATIVADO"
	fi
}
#----------------------------------------------------------------------
function _CHANGE_DIFFICULTY () {
	if [ "$DIFICULDADE" == "GUGÚ-DADÁ" ]; then
		DIFICULDADE="BAIXA"
	elif [ "$DIFICULDADE" == "BAIXA" ]; then
		DIFICULDADE="NORMAL"
	elif [ "$DIFICULDADE" == "NORMAL" ]; then
		DIFICULDADE="ALTA"
	elif [ "$DIFICULDADE" == "ALTA" ]; then
		DIFICULDADE="INSANA"
	else
		DIFICULDADE="GUGÚ-DADÁ"
	fi
}
#----------------------------------------------------------------------
function _DELELOPER_CREDITS () {
	_CABECALHO
	NARRA="
	O jogo foi desenvolvido por...
	
	* Lunovox Heavenfinder. Contattos em: https://libreplanet.org/wiki/User:Lunovox
	"
	#echo "$NARRA"
	#doFala "$NARRA" "op"
	doFala "$NARRA" -p "$NARRA" -op "op"
	_MAIN
}
#----------------------------------------------------------------------
function _INIT () {
	_CABECALHO
	echo -e "DIFICULDADE: $DIFICULDADE\n\n"
	NARRA="Você, $NOME, estava dormindo enquanto viajava de trem até a estação em sua casa."
	doFala "$NARRA" -p "$NARRA" -op "op"

	sl
	
	_CABECALHO
	echo -e "DIFICULDADE: $DIFICULDADE\n\n"
	NARRA="
	Ao acorda percebeu que o tem estava parado dentro de um galpão trancado e escuro.
	Você não sabe por que está trancado aqui, mas deseja saber onde está e o porquê de está aqui."
	doFala "$NARRA" -p "$NARRA" -op "op"

	_CABECALHO
	NARRA="
	De repente, você escuta um grito de mulher em agonia que vem de algum lugar.
	E o faz desejar sair deste lugar o quanto antes.
	"
	doFala "$NARRA" -p "$NARRA" -op "op"
	_CAUMA
}
#----------------------------------------------------------------------
function _CAUMA () {
	_CABECALHO
	MENU_ADD=""
	if [ "$IF_POTION_FOUND" == "1" ]; then
		MENU_ADD="$MENU_ADD \n\t(3) Coletar o que encontrou;"
	fi
	if [ $POCOES -gt 0 ]; then
		MENU_ADD="$MENU_ADD \n\t(4) Beber uma poção de cura;"
	fi
	if [ "$IF_STAIR_FOUND" == "1" ]; then
		MENU_ADD="$MENU_ADD \n\t(5) ir para outro local;"
	fi
	
	NARRA="
O que você irá fazer?
	(1) Explorar o local;
	(2) Autoexaminar-se; $MENU_ADD
	(6) Salvar o jogo;
	(7) Desistir da missão;
	"
	NARRA=$(( echo -e "$NARRA" ))
	#echo "$NARRA"
	#doFala "$NARRA" "op"
	doFala "$NARRA" -p "$NARRA" -op "op"
	#read -n 1 -p ">>> " op
	if [ "$op" == "1" ]; then
		_EXPLORAR
	elif [ "$op" == "2" ]; then
		_AUTOEXAME
	elif [ "$op" == "3" ]; then
		_POTION_TAKE
	elif [ "$op" == "4" ]; then
		_POTION_USE
	elif [ "$op" == "5" ]; then
		_STAIR_DOWN
	elif [ "$op" == "6" ]; then
		_SAVE_GAME
	elif [ "$op" == "7" ]; then
		_OFFMISSION
	else
		_CAUMA
	fi
}
#----------------------------------------------------------------------
function _OFFMISSION () {
	_CABECALHO
	NARRA="
Você acha que já desceu demais, e não quer chegar do outro lado desta bandeija chamada 'planeta'. 
Então, resolve desistir da missão e voltar para a superfície.
	"
	#echo "$NARRA"
	#doFala "$NARRA"
	doFala "$NARRA" -p "$NARRA" -op "op"
	_MAIN
}
#----------------------------------------------------------------------
function _CABECALHO () {
	clear
	echo $x{0..75}"-"|tr -d ' '
	figlet "BLIND BASH RPG"
	echo $x{0..75}"-"|tr -d ' '
	echo "versão 2.0"
	echo $x{0..75}"-"|tr -d ' '
}
#----------------------------------------------------------------------
function _SAIRDOJOGO () {
	_SAVE_CONF
	_CABECALHO
	NARRA="Obrigado por jogar 'Blind Bash RPG'!"
	doFala "$NARRA" -p "$NARRA" -op "op"
	clear
	exit;
}
#----------------------------------------------------------------------
function doFala () {
	newprint=""
	newop=""
	newval=""
	if (( $# >= 2 )); then
		for (( i=1; i <= $#; ++i ))
		do
			next=$((i+1))
			if [[ "${!i}" == "-p" && -n "${!next}" ]]; then
				newprint="${!next}"
			elif [[ "${!i}" == "-op" && -n "${!next}" ]]; then
				newop=${!next}
			elif [[ "${!i}" == "-val" && -n "${!next}" ]]; then
				newval=${!next}
			fi
		done
	fi
	#echo "newprint=$newprint"
	if [ -n "$newprint" ]; then
		echo -e "$newprint"
	fi
	if [ -n "$newop" ]; then
		#echo "newop=$newop"
		if [ "$NARRADOR" == "ATIVADO" ]; then
			pkill 'espeak' > /dev/null
			fala=$(( echo -e "$1" ))
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$fala" &
		fi
		read -n 1 -p ">>> " $newop
	elif [ -n "$newval" ]; then
		#echo "newval=$newval"
		if [ "$NARRADOR" == "ATIVADO" ]; then
			pkill 'espeak' > /dev/null
			fala=$(( echo -e "$1" ))
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$fala" &
		fi
		read -p ">>> " $newval
	else
		if [ "$NARRADOR" == "ATIVADO" ]; then
			pkill 'espeak' > /dev/null
			fala=$(( echo -e "$1" ))
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$fala"
		fi
	fi
}
#----------------------------------------------------------------------
function _AUTOEXAME () {
	_CABECALHO
	let HP_PERCENT="$HP_NOW * 100 / $HP_MAX"
	NARRA="
Você, $NOME, está no nível $NIVEL com a saúde em ${HP_PERCENT}%. 
Abriu sua mochila e contou $POCOES poções de cura. 
Retirou um papel em seu bolso.
Leu suas anotações enquanto explorava o calabouço.
Descobriu que está no andar $ANDAR. 
	"
	#echo $NARRA
	#doFala "$NARRA" "op"
	doFala "$NARRA" -p "$NARRA" -op "op"

}
#----------------------------------------------------------------------
function _EXPLORAR () {
	SORT_ATACK=$(( $RANDOM % 100 ))
	if [ ( $SORT_ATACK -lt $(( 11 - $ANDAR )) ) && ( $SORT_ATACK -gt 0 ) ]; then
		NARRA="Um monstro te encontrou."
		doFala "$NARRA" -p "$NARRA" -op "op"
		_COMBATER
	elif [ "$IF_POTION_FOUND" == "1" || "$IF_STAIR_FOUND" == "1" ]; then
		NARRA="Você continua e explorar outra sala. Por isso... "
		if [ "$IF_POTION_FOUND" == "1" ]; then
			IF_POTION_FOUND=0
			NARRA="$NARRA Esqueceu uma poção de cura para traz."
		fi
		if [ "$IF_STAIR_FOUND" == "1" ]; then
			IF_STAIR_FOUND=0
			NARRA="$NARRA Esqueceu a localização da porta que estava aberta."
		fi
		doFala "$NARRA" -p "$NARRA" -op "op"
	else
		SORT_POTION=$(( $RANDOM % 100 ))
		SORT_STAIR=$(( $RANDOM % 100 ))
		if [ ( $SORT_POTION -lt $(( 11 - $ANDAR )) ) && ( $SORT_POTION -gt 0 ) ]; then
			_POTION_FOUND
		elif [ ( $SORT_STAIR -lt 5 ) && ( $SORT_STAIR -gt 0 ) ]; then
			_STAIR_FOUND
		else
			NARRA="Você explora a sala."
			SORT_OBJECT=$(( $RANDOM % 5 ))
			if [ "$SORT_OBJECT" == "1" ]; then
				NARRA="$NARRA Encontra apenas um jarro quebrado."
			elif [ "$SORT_OBJECT" == "2" ]; then
				NARRA="$NARRA Encontra no chão alguns ossos humanos."
			elif [ "$SORT_OBJECT" == "3" ]; then
				NARRA="$NARRA Encontra uma porta de jaula trancada."
			elif [ "$SORT_OBJECT" == "4" ]; then
				NARRA="$NARRA Encontra um baú trancado por magia ancestral."
			elif [ "$SORT_OBJECT" == "5" ]; then
				NARRA="$NARRA Encontra um marca de sangue no chão."
			fi
			NARRA="$NARRA Nada aqui é de seu interesse."
			doFala "$NARRA" -p "$NARRA" -op "op"	
		fi
	fi
	_CAUMA
}
#----------------------------------------------------------------------
function _POTION_TAKE () {
	if [ "$IF_POTION_FOUND" == "1" ]; then
		IF_POTION_FOUND=0
		POCOES=$(( $POCOES + 1 ))
		NARRA="Você coletou a porção que encontrou."
		doFala "$NARRA" -p "$NARRA" -op "op"
	else
		NARRA="Aqui não tem nada para você coletar."
		doFala "$NARRA" -p "$NARRA" -op "op"	
	fi
}
#----------------------------------------------------------------------
function _POTION_FOUND () {
	IF_POTION_FOUND=1
	NARRA="Você encontrou um frasco de poção de cura."
	doFala "$NARRA" -p "$NARRA" -op "op"
}
#----------------------------------------------------------------------
function _STAIR_FOUND () {
	IF_STAIR_FOUND=1
	NARRA="Você encontrou uma porta destrancada que levará a outro local."
	doFala "$NARRA" -p "$NARRA" -op "op"
}
#----------------------------------------------------------------------
function _STAIR_DOWN () {
	if [ "$IF_STAIR_FOUND" == "1" ]; then
		IF_STAIR_FOUND=0
		ANDAR=$(( $ANDAR + 1 ))
		NARRA="Você entra pela porta aberta. Ela misteriosamente se fecha após sua passagem."
		doFala "$NARRA" -p "$NARRA" -op "op"
	else
		NARRA="Você ainda não encontrou nenhuma porta ou passagem livre."
		doFala "$NARRA" -p "$NARRA" -op "op"	
	fi	
}
#----------------------------------------------------------------------
function _CHECK_DEPENDENCIES () {
	if ! foobar_loc="$(type -p 'figlet')" || [ -z "figlet" ]; then
		echo "comando 'figlet' não encontrado!"
		echo "Favor digite: sudo apt-get install figlet"
		exit 0
	fi
	if ! foobar_loc="$(type -p 'sl')" || [ -z "sl" ]; then
		echo "comando 'sl' não encontrado!"
		echo "Favor digite: sudo apt-get install sl"
		exit 0
	fi
	if ! foobar_loc="$(type -p 'espeak')" || [ -z "espeak" ]; then
		echo "comando 'espeak' não encontrado!"
		echo "Favor digite: sudo apt-get install espeak"
		exit 0
	fi
	if ! foobar_loc="$(type -p 'espeak')" || [ -z "espeak" ]; then
		echo "comando 'espeak' não encontrado!"
		echo "Favor digite: sudo apt-get install espeak"
		exit 0
	fi
	if ! foobar_loc="$(type -p 'paplay')" || [ -z "paplay" ]; then
		# install foobar here
		echo "comando 'paplay' não encontrado!"
		echo "Favor digite: sudo apt-get install paplay"
		exit 0
	fi
}
#----------------------------------------------------------------------
_CHECK_DEPENDENCIES
_OPEN_CONF
	#_CABECALHO
	#doFala "Jogo 'Blind Bash RPG' versão dois ponto zero..."
	#clear
_MAIN

