#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Sposta il cursore all'origine e resetta anche un eventuale shift del display.\n"
	echo -e "USO:"
	echo -e "  $0 [-h]\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida."
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

i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x2C
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x28

exit 0
