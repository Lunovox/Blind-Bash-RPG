#!/bin/bash
#
#
# Simples RPG em bash v1.1
#
# Criado em alguma horas no dia 27/2/2017
#
# Idealizado por xerxeslins (xerxeslins@gmail.com)
# Menu de Load, figlet e paplay por: Lunovox<lunovox@openmailbox.org> em 2017-JUN-09
#
# www.vivaolinux.com.br/~xerxeslins
# GPL
#
# FONTE: https://www.vivaolinux.com.br/script/Bash-RPG
# 
###########################################

NIVEL=1
EXP=0
NEXT=10
DUNGEON=1
POTION=1
KILL=0
COMBATE=0
ESCADA=0
SAUDE_ID=0
SAUDE=("HP:100% = saudável" "HP:80% = com arranhões" "HP:60% = com cortes" "HP:40% = com cortes profundos e ematomas" "HP:20% = mal consegue andar")
SFX_MOB_HIT="/usr/share/sounds/LinuxMint/stereo/dialog-warning.ogg"
SFX_MOB_ERR="/usr/share/sounds/LinuxMint/stereo/dialog-error.ogg"
SFX_MOB_DIE="/usr/share/sounds/LinuxMint/stereo/dialog-error.ogg"
SFX_NPC_HIT="/usr/share/sounds/LinuxMint/stereo/dialog-warning.ogg"
SFX_NPC_ERR="/usr/share/sounds/LinuxMint/stereo/dialog-error.ogg"
SFX_NPC_DIE="/usr/share/sounds/LinuxMint/stereo/dialog-error.ogg"
SFX_NPC_UP="/usr/share/sounds/LinuxMint/stereo/desktop-login.ogg"
SFX_NPC_POT="/usr/share/sounds/LinuxMint/stereo/desktop-logout.ogg"

function _comandos () {
	echo "Comandos:"
	echo "(a)tacar (b)eber (c)omandos (d)escer (e)xplorar (f)ugir (p)ersonagem (s)alvar (q)uit/sair"
	_menu
}

function _personagem () {
	echo "$NOME [${SAUDE[SAUDE_ID]}] nível $NIVEL, experiência $EXP/$NEXT, dungeon $DUNGEON, poções $POTION, matou $KILL."
	_menu
}

function _sair () {
	if [ $COMBATE -eq 0 ]
		then
			echo "$NOME se perdeu na dungeon e nunca mais retornou..."
			read -n 1 -s 
			clear
			_mainmenu
		else
			echo "$NOME está no meio do combate e não pode se destrair agora!"
			_menu	
	fi
}

function _dado {
	DT=$(( ( RANDOM % 6) + 1 ))
}

function _testa_morte_personagem () {
	if [ $SAUDE_ID -gt 4 ]
		then
			figlet "R.I.P."
			echo "$NOME morreu!!!

Nível: $NIVEL
Dungeon: $DUNGEON
Poções: $POTION
Matou: $KILL"
			paplay $SFX_NPC_DIE &
			read -n 1 -s
			clear
			_mainmenu
	fi
}

function _monstro_ataca () {
	_dado
	if [ $DT -lt 5 ]
		then
			echo "$NOME se desviou do ataque do monstro!"
			paplay $SFX_NPC_ERR &
	else
		echo "$NOME sofreu o ataque do monstro!"
		paplay $SFX_NPC_HIT &
		SAUDE_ID=$(( $SAUDE_ID + 1 ))
		_testa_morte_personagem
	fi
	_menu	
}

function _testa_evolucao () {
	if [ $EXP -ge $NEXT ]
		then
			NIVEL=$(( $NIVEL + 1 ))
			NEXT=$(( $NEXT + (( 1 + $NIVEL ) * 5) ))
			SAUDE_ID=0
			figlet "LEVEL UP!"
			paplay $SFX_NPC_UP &
			echo "$NOME se tornou mais forte!"
	fi	
}

function _personagem_acerta () {
	echo "$NOME atingiu o monstro!"
	paplay $SFX_MOB_HIT &
	sleep 2
	_dado
	DIFICULDADE=$(( 3 + $NIVEL - $DUNGEON ))	
	if [ $DT -le $DIFICULDADE ] || [ $DT -eq 1 ]
		then
			echo "$NOME matou o monstro!"
			paplay $SFX_MOB_DIE &
			COMBATE=0
			KILL=$(( $KILL + 1 ))
			EXP=$(( $EXP + ( RANDOM % 4) + $DUNGEON ))
			sleep 2
			_testa_evolucao
	else
		_monstro_ataca
	fi
}

function _atacar () {
	if [ $COMBATE -eq 0 ]
		then
			echo "$NOME desfere um golpe com a espada, cortando o ar!"
			paplay $SFX_MOB_ERR &
	else
		_dado
		if [ $DT -lt 5 ]
			then
				_personagem_acerta
			else
				echo "$NOME errou o ataque!"
				paplay $SFX_MOB_ERR &
				_monstro_ataca	
		fi
	fi
	_menu
}

function _beber () {
	if [ $POTION -gt 0 ]
		then
			echo "$NOME bebe uma poção e se sente muito bem!"
			POTION=$(( $POTION - 1 ))
			paplay $SFX_NPC_POT &
			SAUDE_ID=0
		else
			echo "$NOME procura uma poção na mochila, mas não encontra."
	fi
	_menu
}

function _explorar () {
	if [ $COMBATE -eq 0 ]
		then
			_dado
			if [ $DT -gt 4 ]
				then
					echo "$NOME encontrou um monstro!"
					COMBATE=1
			elif [ $DT -lt 2 ]
				then
					if [ $ESCADA -eq 0 ]
						then
							echo "$NOME encontrou escadas que levam para o próximo nível da dungeon."
							ESCADA=1
						else
							echo "$NOME encontrou uma poção e guardou na mochila."
							POTION=$(( $POTION + 1 ))
					fi
			else
				echo "$NOME explora o interior da dungeon..."
			fi		
		else
			echo "$NOME está no meio do combate e não pode explorar agora!"
	fi
	_menu
}

function _descer () {
	if [ $ESCADA -eq 1 ]
		then
			echo "$NOME desceu as escadas."
			DUNGEON=$(( $DUNGEON + 1 ))
			ESCADA=0
		else
			echo "$NOME olha em volta, mas não vê por onde descer."
	fi
	_menu
}

function _fugir () {
	if [ $COMBATE -eq 1 ]
		then
			_dado
			if [ $DT -lt 3 ]
				then
					echo "$NOME fugiu do monstro como uma garotinha assustada!"
					COMBATE=0
				else
					echo "$NOME procurou uma oportunidade para fugir, mas não encontrou!"
					_monstro_ataca
			fi
		else
			echo "$NOME não tem do que fugir no momento."
	fi
	_menu
}

function _menu () {
	read -n 1 -s -p "> " OPT
	
	#Se quiser idle de 5 segundos descomente o trecho abaixo e comente o read acima
	#read -t 5 -p "> " OPT
	#if [ -z "$OPT" ]
	#	then
	#		if [ $COMBATE -eq 1 ]
	#			then
	#				OPT="a"
	#		else
	#			OPT="e"
	#		fi
	#	echo ""
	#fi
	
	case $OPT in
		c|comandos) _comandos;;
		p|personagem) _personagem;;
		q|quit/sair) _sair;;
		s|salvar) _save;;
		a|ataque|atacar) _atacar;;
		b|beber) _beber;;
		e|explorar) _explorar;;
		d|descer) _descer;;
		f|fugir) _fugir;;
		*) echo "$NOME não entendeu o seu comando. (digite c para ver os comandos)"; _menu;;
	esac
}

function _load () {
	file="bash_rpg.sav"
	if [ -f "$file" ]
	then
		DADOS="$(cat $file)"
		NOME=$(echo $DADOS | cut -d, -f1)
		NIVEL=$(echo $DADOS | cut -d, -f2)
		EXP=$(echo $DADOS | cut -d, -f3)
		NEXT=$(echo $DADOS | cut -d, -f4)
		DUNGEON=$(echo $DADOS | cut -d, -f5)
		POTION=$(echo $DADOS | cut -d, -f6)
		KILL=$(echo $DADOS | cut -d, -f7)
		COMBATE=$(echo $DADOS | cut -d, -f8)
		ESCADA=$(echo $DADOS | cut -d, -f9)
		SAUDE_ID=$(echo $DADOS | cut -d, -f10)
		
		clear
		figlet "BASH RPG"
		echo "$NOME ao olhar o mapa, encontou a escada por onde chegou neste andar."
		echo "(digite c para ver os comandos)"
		_menu
	else
		echo "Não é possivel carregar o salve em '$file'!"
		read -n 1 -s
		clear
		_mainmenu
	fi
}

function _save () {
	if [ $COMBATE -eq 0 ]
		then
			DADOS=$(echo "$NOME,$NIVEL,$EXP,$NEXT,$DUNGEON,$POTION,$KILL,$COMBATE,$ESCADA,$SAUDE_ID" > bash_rpg.sav)
			echo "$NOME anotou no mapa a sua localização!"
		else
			echo "$NOME está no meio do combate e não pode anotar sua localização agora!"
	fi
	_menu
}

function _newgame () {
	echo "Qual o nome do seu personagem?"
	read -p "> " NOME
	echo "(digite c para ver os comandos)"
	echo "$NOME entrou na dungeon para eliminar os monstros."
	_menu
}

function _mainmenu () {
	figlet "BASH RPG"
	echo "
(n)ovo jogo
(c)arregar jogo
(q)uit / sair

"

	read -n 1 -s -p "> " OPT
	
	
	case $OPT in
		n|newgame) _newgame;;
		c|load) _load;;
		q|quit/sair) exit 0;;
		*) clear; _mainmenu;;
	esac
}

function _preload () {
	if ! foobar_loc="$(type -p 'figlet')" || [ -z "figlet" ]; then
		# install foobar here
		echo "comando 'figlet' não encontrado!"
		echo "Favor digite: sudo apt-get install figlet"
		exit 0
	fi

	if ! foobar_loc="$(type -p 'paplay')" || [ -z "paplay" ]; then
		# install foobar here
		echo "comando 'paplay' não encontrado!"
		echo "Favor digite: sudo apt-get install paplay"
		exit 0
	fi
	_mainmenu
}

_preload
