#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Scrive un carattere sul display nella posizione attuale del cursore.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 <CHAR_CODE>\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida.\n"
	echo -e "NOTE:"
	echo -e "  lo script utilizza la variabile d'ambiente I2C_BUS per stabilire su quale"
	echo -e "  bus lavorare. Assicurarsi che la variabile sia definita correttamente.\n"
	echo -e "  I valori di CHAR_CODE ammissibili sono quelli UTF-8 con l'unica differenza"
	echo -e "  che, dove UTF-8 prevede caratteri non stampabili (di controllo), il display"
	echo -e "  ne definisce altri."
	echo -e "  Per maggiori dettagli di vedano le pagine 17-18 del datasheet"
	echo -e "  https://www.sparkfun.com/datasheets/LCD/HD44780.pdf\n"
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

if [ -z $1 ]; then
	help "Errore parametri"
	exit 1
fi

lNibble=$(( $1 % 16 ))
#echo "lNibble = $lNibble"
hNibble=$(( $1 / 16 ))
#echo "hNibble = $hNibble"
ctrl1=$(( 2#1101 )) # BL  E RW RS
                    #  1  1  0  1
#echo "ctrl1 = $ctrl1"
ctrl2=$(( 2#1001 )) # BL  E RW RS
                    #  1  0  0  1
#echo "ctrl2 = $ctrl2"

msg1=$(echo 0x$( echo "obase=16; $(( $hNibble * 16 | $ctrl1 ))" | bc ) )
msg2=$(echo 0x$( echo "obase=16; $(( $hNibble * 16 | $ctrl2 ))" | bc ) )
msg3=$(echo 0x$( echo "obase=16; $(( $lNibble * 16 | $ctrl1 ))" | bc ) )
msg4=$(echo 0x$( echo "obase=16; $(( $lNibble * 16 | $ctrl2 ))" | bc ) )

#echo
#echo "msg1 = $msg1"
#echo "msg2 = $msg2"
#echo "msg3 = $msg3"
#echo "msg4 = $msg4"

i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg1
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg2
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg3
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg4

exit 0

