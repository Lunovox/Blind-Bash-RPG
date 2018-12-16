#!/bin/bash

SAVE=1
MAX_SAVE=3
NARRADOR="ATIVADO"
DIFICULDADE="NORMAL"

function _MAIN () {
	_CABECALHO
	NARRA="
Selecione uma opção:

	(1) Novo Jogo;
	(2) Carregar Jogo;
	(3) Narrador: '$NARRADOR';
	(4) Dificuldade: '$DIFICULDADE';
	(5) Sair do Jogo;
	"
	echo "$NARRA"
	doFala "$NARRA" "op"
	#read -n 1 -p ">>> " op
	if [ "$op" == "1" ]; then 
		_NOVO;
	elif [ "$op" == "2" ]; then 
		_CARREGAR;
	elif [ "$op" == "3" ]; then 
		if [ "$NARRADOR" == "ATIVADO" ]; then
			NARRADOR="DESATIVADO"
			espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "O narrador do jogo agora está '$NARRADOR'."
		else
			NARRADOR="ATIVADO"
		fi
		_MAIN;
	elif [ "$op" == "4" ]; then 
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
		_MAIN;
	elif [ "$op" == "5" ]; then 
		_SAIRDOJOGO
	else
		_MAIN
	fi
}

#----------------------------------------------------------------------

function _NOVO () {
	_CABECALHO
	NARRA="Digite seu nome: "
	printf "$NARRA"
	doFala "$NARRA"
	read -p ">>> " NOME
	NOME=$(echo "$NOME" | cut -d " " -f 1)
	_INIT
}
#----------------------------------------------------------------------
function _INIT () {
	_CABECALHO
	NARRA="
	A esposa do prefeito da cidade 'Crâneo-Rachado' foi raptada por Ogros. 
	Por isso, você, $NOME, foi convocado ou convocada para salvar a madame.
	Você desce por umma escadaria em um andar no subsolo escuro.
	O que você irá fazer?
	"
	echo "$NARRA"
	doFala "$NARRA" "op"
	_CAUMA
}
#----------------------------------------------------------------------
function _CAUMA () {
	_CABECALHO
	NARRA="
Selecione uma opção:
	(1) Explorar o andar;
	(2) Autoexaminar-se;
	(3) Coletar o que encontrou;
	(4) Beber uma poção de cura;
	(5) Salvar o jogo;
	(6) Desistir da missão;
	"
	echo "$NARRA"
	doFala "$NARRA" "op"
	#read -n 1 -p ">>> " op
	if [ "$op" == "1" ]; then
		_EXPLORAR
	elif [ "$op" == "2" ]; then
		_AUTOEXAME
	elif [ "$op" == "3" ]; then
		_TAKEALL
	elif [ "$op" == "4" ]; then
		_CURAR
	elif [ "$op" == "5" ]; then
		_SALVAR
	elif [ "$op" == "6" ]; then
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
	echo "$NARRA"
	doFala "$NARRA"
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
function _CARREGAR () {
	echo "carregar"
}
#----------------------------------------------------------------------
function _SAIRDOJOGO () {
	clear; 
	echo "Obrigado por jogar 'Blind Bash RPG'!"
	doFala "Obrigado por jogar 'Blind Bash RPG'!"
	exit;
}
#----------------------------------------------------------------------
function doFala () {
	if [ "$NARRADOR" == "ATIVADO" ]; then
		espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "$1"
	fi
	if [ -n "$2" ]; then
		read -n 1 -p ">>> " $2;
	fi
}
#----------------------------------------------------------------------

_CABECALHO
	espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "Jogo 'Blind Besh RPG' versão dois ponto zero..."
	# espeak -v pt+f5 -p 60 -a 100 -s 165 -g 10 "Pressione o botão (3) para ativar o narrador que auxiliará pessoas com dificuldade visual!"
_MAIN
