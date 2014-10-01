#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Imposta il comportamento del display dirante la scrittura.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 -d <LEFT/RIGHT> -s <ON/OFF>\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida"
	echo -e "  -d  imposta la direzione dello spostamento del cursore durante la scrittura."
	echo -e "  -s  indica se shiftare o meno il display durante la scrittura.\n"
	echo -e "<LEFT/RIGHT>  l - sinistra"
	echo -e "              r - destra\n"
	echo -e "<ON/OFF>  0 - OFF"
	echo -e "          1 - ON\n"
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

if [ "$1" = "-d" -a "$2" = "l" -a "$3" = "-s" -a "$4" = "0" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x4C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x48

	echo "Direzine cursore: SINISTRA"
	echo "Display shift:    OFF"
elif [ "$1" = "-d" -a "$2" = "l" -a "$3" = "-s" -a "$4" = "1" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x5C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x58
	
	echo "Direzine cursore: SINISTRA"
	echo "Display shift:    ON"
elif [ "$1" = "-d" -a "$2" = "r" -a "$3" = "-s" -a "$4" = "0" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x6C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x68
	
	echo "Direzine cursore: DESTRA"
	echo "Display shift:    OFF"
elif [ "$1" = "-d" -a "$2" = "r" -a "$3" = "-s" -a "$4" = "1" ]; then
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x7C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x78
	
	echo "Direzine cursore: DESTRA"
	echo "Display shift:    ON"
else

	help "Errore parametri"
	exit 1
fi

exit 0
