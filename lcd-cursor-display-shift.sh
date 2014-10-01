#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Muove il corsore e il contenuto del display senza modificare i dati scritti.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 -s <CURSOR/DISPLAY> -d <LEFT/RIGHT>\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida."
	echo -e "  -s  specifica su cosa effettuare lo spostamento."
	echo -e "  -d  specifica la direzione dello spostamento.\n"
	echo -e "  <CURSOR/DISPLAY>  0 - CURSOR"
	echo -e "                    1 - DISPLAY\n"
	echo -e "  <LEFT/RIGHT>  0 - LEFT"
	echo -e "                1 - RIGHT\n"
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

if [ "$1" = "-s" -a "$2" = "0" -a "$3" = "-d" -a "$4" = "0" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x1C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x18
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08

elif [ "$1" = "-s" -a "$2" = "0" -a "$3" = "-d" -a "$4" = "1" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x1C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x18
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x4C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x48

elif [ "$1" = "-s" -a "$2" = "1" -a "$3" = "-d" -a "$4" = "0" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x1C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x18
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x8C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x88

elif [ "$1" = "-s" -a "$2" = "1" -a "$3" = "-d" -a "$4" = "1" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x1C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x18
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xCC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xC8

else
	help "Errore parametri."
	exit 1
fi

exit 0

