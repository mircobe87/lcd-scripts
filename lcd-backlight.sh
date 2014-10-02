#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Accende o spegne la retroilluminazione.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 on|off\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida.\n"
	echo -e "NOTE:"
	echo -e "  lo script utilizza la variabile d'ambiente I2C_BUS per stabilire su quale"
	echo -e "  bus lavorare. Assicurarsi che la variabile sia definita correttamente.\n"
}

if [ "$1" = "-h" ]; then
	help
	exit 0
fi

if [ -z $I2C_BUS ]; then
	help "La variabile d'ambiente I2C_BUS non è definita."
	exit 1
fi

LCD_ADDR="0x27"
REG_ADDR="0x00"

if [ "$1" = "on" -o "$1" = "ON" -o "$1" = "1" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08

elif [ "$1" = "off" -o "$1" = "OFF" -o "$1" = "0" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x00

else
	help "Errore parametri"
	exit 1
fi

exit 0

