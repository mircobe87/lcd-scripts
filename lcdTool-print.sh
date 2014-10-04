#!/bin/bash

function getHexCharList () {
	echo -n $1 | hexdump -v -e '1/1 "%02X "'
}

function help () {
	echo -e "$1\n"
	echo -e "Stampa una stringa di testo sul display dalla posizione attuale del cursore.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 <STRING>\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida.\n"
	echo -e "NOTE:"
	echo -e "  lo script utilizza la variabile d'ambiente I2C_BUS per stabilire su quale"
	echo -e "  bus lavorare. Assicurarsi che la variabile sia definita correttamente.\n"
	echo -e "  STRING è una stringa di caratteri racchiusi tra doppi apici (" ")\n"
}

if [ "$1" = "-h" ]; then
	help
	exit 0
fi

if [ -z $I2C_BUS ]; then
	help "La variabile d'ambiente I2C_BUS non è definita."
	exit 1
fi

if [ -z $1 ]; then
	help "Nessuna stringa specificata"
	exit 1
fi

for c in $( getHexCharList $1 ); do
	./lcd-write-data "0x$c"
done

exit 0

