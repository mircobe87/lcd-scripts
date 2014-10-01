#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Elimina il contenuto del display e riposta il cursore nella posizione iniziale.\n"
	echo -e "USO:"
	echo -e "  $0 [-h]\n"
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

# Ripulisce il display e riporta il cursore nella mosizione iniziale
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x1C
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x18
echo "Display pulito"

exit 0
