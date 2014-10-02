#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Sposta il cursore all'indirizzo specificato.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 <DDRAM_ADDR>\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida.\n"
	echo -e "NOTE:"
	echo -e "  lo script utilizza la variabile d'ambiente I2C_BUS per stabilire su quale"
	echo -e "  bus lavorare. Assicurarsi che la variabile sia definita correttamente.\n"
	echo -e "  I valori di DDRAM_ADDR ammissibili variano a seconda delle linee utilizzate"
	echo -e "  sul display:\n"
	echo -e "    1 linea    0x00 <= DDRAM_ADDR <= 0x4F (80 caratteri)"
	echo -e "    2 linee    0x00 <= DDRAM_ADDR <= 0x27 (40 carattari) linea 1"
	echo -e "               0x40 <= DDRAM_ADDR <= 0x67 (40 caratteri) linea 2"
	echo -e "  Le linee sono \"circolari\": l'ultimo carattere è anche il precedente al primo.\n"
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

word=$(( 2#10000000 | $1 ))
#echo "word = $word"
lNibble=$(( $word % 16 ))
#echo "lNibble = $lNibble"
hNibble=$(( $word / 16 ))
#echo "hNibble = $hNibble"
#echo

msg1=$(echo 0x$( echo "obase=16; $(( $hNibble * 16 | 0x0C ))" | bc ) )
msg2=$(echo 0x$( echo "obase=16; $(( $hNibble * 16 | 0x08 ))" | bc ) )
msg3=$(echo 0x$( echo "obase=16; $(( $lNibble * 16 | 0x0C ))" | bc ) )
msg4=$(echo 0x$( echo "obase=16; $(( $lNibble * 16 | 0x08 ))" | bc ) )

i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg1
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg2
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg3
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg4

exit 0

