#!/bin/bash

function help () {
	echo -e "$1\n"
	echo -e "Specifica l'indirizzo sul quale inserire i dati per la definizione di un"
	echo -e "carattere personalizzato.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 <CGRAM_ADDR>\n"
	echo -e "OPZIONI:"
	echo -e "  -h  mostra questa guida.\n"
	echo -e "NOTE:"
	echo -e "  lo script utilizza la variabile d'ambiente I2C_BUS per stabilire su quale"
	echo -e "  bus lavorare. Assicurarsi che la variabile sia definita correttamente.\n"
	echo -e "  I valori di CGRAM_ADDR ammissibili sono 64 e variano da 0x00 a 0x3F.\n"
}

if [ -z $1 ]; then
	help "Errore parametri"
	exit 1
fi

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

if [ $(( $1 )) -ge 0 -a $(( $1 )) -le 63 ]; then
	word=$(( 2#00111111 & $1 | 2#01000000 ))
	#echo "word = $word"
	lNibble=$(( $word % 16 ))
	#echo "lNibble = $lNibble"
	hNibble=$(( $word / 16 ))
	#echo "hNibble = $hNibble"
	#echo
	#                     BL  E RW RS
	ctrl1=$(( 2#1100 )) #  1  1  0  0
	ctrl2=$(( 2#1000 )) #  1  0  0  0
	#echo "ctrl1 = $ctrl1"
	#echo "ctrl2 = $ctrl2"
	#echo
	
	msg1=$(echo 0x$( echo "obase=16; $(( $hNibble * 16 | $ctrl1 ))" | bc ) )
	msg2=$(echo 0x$( echo "obase=16; $(( $hNibble * 16 | $ctrl2 ))" | bc ) )
	msg3=$(echo 0x$( echo "obase=16; $(( $lNibble * 16 | $ctrl1 ))" | bc ) )
	msg4=$(echo 0x$( echo "obase=16; $(( $lNibble * 16 | $ctrl2 ))" | bc ) )
	#echo "msg1 = $msg1"
	#echo "msg2 = $msg2"
	#echo "msg3 = $msg3"
	#echo "msg4 = $msg4"

	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg1
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg2
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg3
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR $msg4
else
	help "Indirizzo non valido"
	exit 1
fi

exit 0

