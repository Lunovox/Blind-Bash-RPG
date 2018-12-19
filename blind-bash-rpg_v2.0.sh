#!/bin/bash
#source incl.sh

FILE_BASE="${HOME}/.config/BlindBashRPG/"
FILE_SAVE="BlindBashRPG.sav"
FILE_CONF="BlindBashRPG.conf"
#ESPEAK_CONF="-v pt+f5 -p 60 -a 100 -s 165 -g 10"
ESPEAK_CONF="-v pt+f5 -p 60 -a 100 -s 165 -g 10"
NOME=""
ANDAR=1
NIVEL=1
EXPERIENCE=0
NARRADOR="ATIVADO"
DIFICULDADE="NORMAL"
MONSTER_DAMAGE=10
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
DIFICULDADE = ${DIFICULDADE}
ANDAR = ${ANDAR}
NIVEL = ${NIVEL}
EXPERIENCE = ${EXPERIENCE}
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
		DIFICULDADE=$(cat $conf | grep "DIFICULDADE" | cut -d "=" -f 2 | tr -d " ")
		ANDAR=$(cat $conf | grep "ANDAR" | cut -d "=" -f 2 | tr -d " ")
		NIVEL=$(cat $conf | grep "NIVEL" | cut -d "=" -f 2 | tr -d " ")
		EXPERIENCE=$(cat $conf | grep "EXPERIENCE" | cut -d "=" -f 2 | tr -d " ")
		POCOES=$(cat $conf | grep "POCOES" | cut -d "=" -f 2 | tr -d " ")
		HP_NOW=$(cat $conf | grep "HP_NOW" | cut -d "=" -f 2 | tr -d " ")
		HP_MAX=$(cat $conf | grep "HP_MAX" | cut -d "=" -f 2 | tr -d " ")
		_AUTOEXAME
		_CAUMA
	else
		_CABECALHO
		NARRA="NÃO EXISTE JOGO SALVO!"
		if [ "$NARRADOR" == "ATIVADO" ]; then
			doFala "$NARRA" -p "$NARRA"
		else
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
		LOADTEXT="\n\t(2) CARREGAR JOGO;"; 
	fi
	NARRA="
Selecione uma opção do menu principal:

	(1) NOVO JOGO EM $DIFICULDADE; ${LOADTEXT}
	(3) LISTAR CONQUISTAS;
	(4) DESENVOLVEDORES;
	(5) CONFIGURAÇÕES;
	(6) SAIR DO JOGO;
	"
	doFala "$NARRA" -p "$NARRA" -op "op"
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
	EXPERIENCE=0
	POCOES=0
	HP_MAX=100
	HP_NOW=100
	IF_POTION_FOUND=0
	IF_STAIR_FOUND=0
	_CABECALHO
	NARRA="Digite seu nome: "
	doFala "$NARRA" -p "$NARRA" -val "NOME"
	NOME=$(echo "$NOME" | cut -d " " -f 1)
	_INIT
}
#----------------------------------------------------------------------
function _TOGGLE_NARRATOR () {
	if [ "$NARRADOR" == "ATIVADO" ]; then
		NARRADOR="DESATIVADO"
		#pkill 'espeak' > /dev/null
		{ pkill 'espeak' && wait; } 2>/dev/null
		espeak $ESPEAK_CONF "O narrador do jogo agora está '$NARRADOR'."
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

	. Lunovox Heavenfinder. 
			Contatos em: https://libreplanet.org/wiki/User:Lunovox
	"
	doFala "$NARRA" -p "$NARRA" -op "op"
	_MAIN
}
#----------------------------------------------------------------------
function _INIT () {
	_CABECALHO
	NARRA="Você, $NOME, estava dormindo enquanto viajava de trem até a estação em sua casa."
	doFala "$NARRA" -p "$NARRA" -op "op"

	sl
	
	_CABECALHO
	NARRA="
	Após acordar, percebe que o trem está parado dentro de um galpão trancado e escuro.
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
	MENU_ADD=""
	if [[ $IF_POTION_FOUND -ge 1 ]]; then
		MENU_ADD="$MENU_ADD \n\t(3) Guardar as $IF_POTION_FOUND poções que encontrou;"
	fi
	if [[ $POCOES -ge 1 && $HP_NOW -lt $HP_MAX ]]; then
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
	(7) Dormir um pouco;
	"
	#NARRA=$((printf $NARRA))
	_CABECALHO
	doFala "$NARRA" -p "$NARRA" -op "op"
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
	fi
	_CAUMA
}
#----------------------------------------------------------------------
function _OFFMISSION () {
	#_CABECALHO
	clear
	echo -e "\n\n\n"
	figlet "GAME OVER"
	echo -e "\n\n"
	NARRA="
Você está muito cansado e resolve se deitar no chão para dormir um pouco.
Seu descuido lhe custou a vida. 
Pois ao acordar você percebe que está completamente amarrado, e sendo cozinhando dentro de um caldeirão. 

Isto é o fim de jogo para você!
	"
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
	doFala "$NARRA" -p "$NARRA"
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
		if [[ "$newop" == "" && "$newval" == "" ]]; then
			newop="op" #Força para de teclado de houve texto impresso
		fi
	fi
	if [ -n "$newop" ]; then
		if [ "$NARRADOR" == "ATIVADO" ]; then
			#pkill 'espeak' > /dev/null
			{ pkill 'espeak' && wait; } 2>/dev/null
			fala=$(echo -e $1)
			espeak $ESPEAK_CONF "$fala" &
		fi
		read -s -n 1 -p ">>> " $newop
	elif [ -n "$newval" ]; then
		if [ "$NARRADOR" == "ATIVADO" ]; then
			#pkill 'espeak' > /dev/null
			{ pkill 'espeak' && wait; } 2>/dev/null
			fala=$(echo -e "$1")
			espeak $ESPEAK_CONF "$fala" &
		fi
		read -p ">>> " $newval
	else
		if [ "$NARRADOR" == "ATIVADO" ]; then
			#pkill 'espeak' > /dev/null
			{ pkill 'espeak' && wait; } 2>/dev/null
			fala=$(echo -e "$1")
			espeak $ESPEAK_CONF "$fala"
		fi
	fi
}
#----------------------------------------------------------------------
function _AUTOEXAME () {
	_CABECALHO
	let HP_PERCENT="$HP_NOW * 100 / $HP_MAX"
	#HP_PERCENT=$( $HP_NOW * 100 / $HP_MAX )
	
	NARRA="Você, $NOME, está com a saúde em ${HP_PERCENT}%."
	if [[ $POCOES -ge 1 ]]; then
		NARRA="$NARRA \nAbriu sua mochila e contou $POCOES poções de cura."
	fi
	
	NARRA="$NARRA \nRetirou um papel em seu bolso. Leu suas anotações enquanto explorava o calabouço."

	if [[ $NIVEL -ge 2 || $ANDAR -ge 2 ]]; then
		NARRA="$NARRA \nDescobriu que está com o nível de força $NIVEL enquanto está na ${ANDAR}ª fase."
	fi

	NARRA="$NARRA \nVocê sabe o quanto este local é perigoso com a dificuldade '${DIFICULDADE}'."
	NARRA="$NARRA \nPor isso que precisa sair daqui o quanto antes."
	#let NEXT_NIVEL_XP="$NIVEL * 5"
	_CALC_NEXT_XP

	echo -e "$NARRA\n\n"
	echo $x{0..75}"-"|tr -d ' '
	echo -e "HP: ${HP_NOW}/${HP_MAX} (${HP_PERCENT}%) | XP: ${EXPERIENCE}/${NEXT_NIVEL_XP} | NÍVEL: ${NIVEL} | FASE: ${ANDAR} | DIFICULDADE: ${DIFICULDADE}"
	echo $x{0..75}"-"|tr -d ' '
	doFala "$NARRA"  -op "op"
}
#----------------------------------------------------------------------
function _EXPLORAR () {
	_CABECALHO
	SORT_ATACK=$(($RANDOM % 100))
	if [[ ( $SORT_ATACK -ge 0 ) && ( $SORT_ATACK -le $(( 19 + $ANDAR )) ) ]]; then
		clear
		_COMBATER
#	elif [[ "$IF_POTION_FOUND" == "1" || "$IF_STAIR_FOUND" == "1" ]]; then
#		NARRA="Você continua a explorar outro local. Por isso... "
#		if [ "$IF_POTION_FOUND" == "1" ]; then
#			IF_POTION_FOUND=0
#			NARRA="$NARRA Esqueceu uma poção de cura para traz."
#		fi
#		if [ "$IF_STAIR_FOUND" == "1" ]; then
#			IF_STAIR_FOUND=0
#			NARRA="$NARRA Esqueceu a localização da porta que estava aberta."
#		fi
#		doFala "$NARRA" -p "$NARRA"
	else
		SORT_POTION=$(($RANDOM % 100))
		SORT_STAIR=$(($RANDOM % 100))
		#echo "SORT_ATACK=$SORT_ATACK | SORT_POTION=$SORT_POTION | SORT_STAIR=$SORT_STAIR"
		#echo "IF_POTION_FOUND=$IF_POTION_FOUND | IF_STAIR_FOUND=$IF_STAIR_FOUND"		
		#echo -e "\n\n"
		if [[ $SORT_POTION -ge 0 && $SORT_POTION -le $((16 - $ANDAR)) ]]; then
			_POTION_FOUND
		elif [[ $IF_STAIR_FOUND -eq 0 && $SORT_STAIR -ge 0 && $SORT_STAIR -le 10 ]]; then
			_STAIR_FOUND
		else
			NARRA=""
			SORT_OBJECT=$(( $RANDOM % 5 ))
			if [ "$SORT_OBJECT" == "1" ]; then
				NARRA="$NARRA Encontra um jarro quebrado que indica que houve uma fuga desesperada."
			elif [ "$SORT_OBJECT" == "2" ]; then
				NARRA="$NARRA Encontra no chão alguns ossos humanos que indica que houve uma luta."
			elif [ "$SORT_OBJECT" == "3" ]; then
				NARRA="$NARRA Encontra uma porta de jaula trancada que impede você de sair."
			elif [ "$SORT_OBJECT" == "4" ]; then
				NARRA="$NARRA Encontra um baú trancado por magia que você não pode abrir."
			elif [ "$SORT_OBJECT" == "5" ]; then
				NARRA="$NARRA Encontra um marca de sangue no chão que te deixa mais assustado."
			else
				NARRA="$NARRA Nada aqui é de seu interesse."
			fi
			doFala "$NARRA" -p "$NARRA"
		fi
	fi
	_CAUMA
}
#----------------------------------------------------------------------
function _COMBATER () {
	_CABECALHO
	_CALC_DAMAGE
	let DANO_PERCENT="($MONSTER_DAMAGE * $ANDAR) * 100 / $HP_MAX"
	let HP_NOW="$HP_NOW - ($MONSTER_DAMAGE * $ANDAR)"
	let HP_PERCENT="$HP_NOW * 100 / $HP_MAX"

	NARRA="Um monstro te encontrou."
	doFala "$NARRA" -p "$NARRA"

	NARRA="O Monstro desfere um ataque contra você."
	NARRA="$NARRA Retirando ${DANO_PERCENT}% de sua saúde,"
	NARRA="$NARRA que agora está em ${HP_PERCENT}%!"
	doFala "$NARRA" -p "$NARRA"
	
	NARRA="Você mata o monstro!"
	doFala "$NARRA" -p "$NARRA"
	
	let EXPERIENCE="$EXPERIENCE + $ANDAR"
	_CALC_NEXT_XP
	if [[ $EXPERIENCE -ge $NEXT_NIVEL_XP ]]; then
		while [[ $EXPERIENCE -ge $NEXT_NIVEL_XP ]]; do
			let NIVEL="$NIVEL + 1"
			let HP_MAX="100 + (($NIVEL -1) * 5)"
			#let NEXT_NIVEL_XP="$NIVEL * 5"
			_CALC_NEXT_XP
			HP_NOW="$HP_MAX"
			clear
			echo -e "\n\n\n"
			figlet "LEVEL UP"
			echo -e "\n\n\n"
			NARRA="Parabéns! Você evoluiu para o nível $NIVEL!"
			doFala "$NARRA" -p "$NARRA"
		done
	fi
}
#----------------------------------------------------------------------
function _CALC_DAMAGE () {
	if [[ "$DIFICULDADE" == "GUGÚ-DADÁ" ]]; then
		MONSTER_DAMAGE=1
	elif [[ "$DIFICULDADE" == "BAIXA" ]]; then
		MONSTER_DAMAGE=2
	elif [[ "$DIFICULDADE" == "NORMAL" ]]; then
		MONSTER_DAMAGE=3
	elif [[ "$DIFICULDADE" == "ALTA" ]]; then
		MONSTER_DAMAGE=4
	elif [[ "$DIFICULDADE" == "INSANA" ]]; then
		MONSTER_DAMAGE=5
	fi
}
#----------------------------------------------------------------------
function _CALC_NEXT_XP () {
	if [[ "$DIFICULDADE" == "GUGÚ-DADÁ" ]]; then
		INCREMENTO=1
	elif [[ "$DIFICULDADE" == "BAIXA" ]]; then
		INCREMENTO=5
	elif [[ "$DIFICULDADE" == "NORMAL" ]]; then
		INCREMENTO=10
	elif [[ "$DIFICULDADE" == "ALTA" ]]; then
		INCREMENTO=15
	elif [[ "$DIFICULDADE" == "INSANA" ]]; then
		INCREMENTO=20
	fi
	let NEXT_NIVEL_XP="$NIVEL * $INCREMENTO"
}
#----------------------------------------------------------------------
function _POTION_TAKE () {
	_CABECALHO
	if [[ $IF_POTION_FOUND -ge 1 ]]; then
		#POCOES=$(( $POCOES + 1 ))
		let POCOES="$POCOES + $IF_POTION_FOUND"
		NARRA="Você coletou $IF_POTION_FOUND porção que encontrou."
		doFala "$NARRA" -p "$NARRA"
		IF_POTION_FOUND=0
	else
		NARRA="Aqui não tem nada para você coletar."
		doFala "$NARRA" -p "$NARRA"
	fi
}
#----------------------------------------------------------------------
function _POTION_FOUND () {
	_CABECALHO
	let IF_POTION_FOUND="$IF_POTION_FOUND + 1"
	#IF_POTION_FOUND=1
	NARRA="Você encontrou $IF_POTION_FOUND frasco de poção de cura."
	doFala "$NARRA" -p "$NARRA"
}
#----------------------------------------------------------------------
function _POTION_USE () {
	_CABECALHO
	if [[ $POCOES -ge 1 ]]; then
		if [[ HP_NOW -lt $HP_MAX ]]; then
			let POCOES="$POCOES - 1"
			HP_NOW="$HP_MAX"
			NARRA="Você bebeu uma poção de cura."
			doFala "$NARRA" -p "$NARRA"
		else
			NARRA="Você decide não beber uma poção de cura enquanto estiver completamente saudável."
			doFala "$NARRA" -p "$NARRA"		
		fi
	else
		NARRA="Você não tem nenhuma poção de cura."
		doFala "$NARRA" -p "$NARRA"
	fi
}
#----------------------------------------------------------------------
function _STAIR_FOUND () {
	_CABECALHO
	IF_STAIR_FOUND=1
	NARRA="Você encontrou uma porta destrancada que levará a outro local."
	doFala "$NARRA" -p "$NARRA"
}
#----------------------------------------------------------------------
function _STAIR_DOWN () {
	_CABECALHO
	if [ "$IF_STAIR_FOUND" == "1" ]; then
		IF_STAIR_FOUND=0
		IF_POTION_FOUND=0
		ANDAR=$(( $ANDAR + 1 ))
		NARRA="Você entra pela porta aberta. Ela misteriosamente se fecha após sua passagem."
		doFala "$NARRA" -p "$NARRA"
	else
		NARRA="Você ainda não encontrou nenhuma porta ou passagem livre."
		doFala "$NARRA" -p "$NARRA"
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
	if [[ "${USER}" != "lunovox" ]]; then
		_CABECALHO
		doFala "Jogo 'Blind Bash RPG' versão dois ponto zero..."
		#clear
	fi
_MAIN
