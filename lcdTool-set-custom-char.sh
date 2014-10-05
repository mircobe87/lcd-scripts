#!/bin/bash

exec 5<&0 # copio lo stdin su fd 5

function restorStdin () {
	exec 0<&5
	exec 5<&-
}

function help () {
	echo -e "$1\n"
	echo -e "Imposta un carattere personalizzato ad un indirizzo specificato.\n"
	echo -e "USO:"
	echo -e "  $0 -h"
	echo -e "  $0 -a <DDRAM_ADDR> [-f <PATTERN_FILE>]\n"
	echo -e "OPZIONI:"
	echo -e "  -h  Mostra questa guida."
	echo -e "  -a  Specifica l'indirizzo di memoria dove salvare il carattere."
	echo -e "      Valori possibili sono da 0x00 a 0x07."
	echo -e "  -f  Nome del file sul quale il carattere è definito; se omesso, il"
	echo -e "      il pattern viene letto da stdIn.\n"
	echo -e "NOTE:"
	echo -e "  lo script utilizza la variabile d'ambiente I2C_BUS per stabilire su quale"
	echo -e "  bus lavorare. Assicurarsi che la variabile sia definita correttamente.\n"
	echo -e "  Un PATTERN_FILE è un file di testo dove ogni riga del pattern è definita da"
	echo -e "  una riga di 5 caratteri 0 o 1; 0 indica un pixel spento, 1 acceso. Le righe"
	echo -e "  vuote o che incominciano con '#' vengono ignorate.\n"
}

if [ -z $1 ]; then
	help "Errore parametri"
	exit 1
fi

if [ "$1" = "-h" ]; then
	help
	exit 0
fi

addr=0
if [ "$1" = "-a" ]; then
	if [ "$2" != "" -a $(( $2 )) -ge 0 -a $(( $2 )) -lt 8 ]; then
		addr=$(( $2 * 8 ))
	else
		echo "Indirizzo non valido"
		exit 1
	fi
fi
#echo "addr = $addr"

if [ "$3" = "-f" ]; then
	# si deve leggere da file
	if [ -r $4 ]; then
		# il file esiste ed è regolare
		exec 0<"$4" # ridirigo il file sullo stdin
	else
		help "Il file non esiste o non è regolare"
		exit 1
	fi
elif [ -z "$3" ]; then
	# si legge da stdin
	echo "Inserire le 8 righe del pattern:"
else
	help "Errore parametri"
	exit 1
fi

inputLines=0
patternLines=0
byteList=""

while read line; do
	(( inputLines += 1 ))
	if [ "${line:0:1}" != "#" -a ! -z "${line:0:1}" ]; then
		echo $line
		(( patternLines += 1 ))
		binaryLine=2#$line
		lineVal=$(( binaryLine ))
		if [ $lineVal -gt $(( 2#11111 )) ]; then
			echo "$inputLines: riga non valida."
			restorStdin
			exit 1
		fi
		byte=$(echo 0x$( echo "obase=16; $lineVal" | bc ))
		byteList="$byteList$byte "
	fi
done

#echo $patternLines
#echo $byteList

if [ $patternLines -gt 8 ]; then
	echo "Patter troppo grande"
	restorStdin
	exit 1
fi

if [ $patternLines -lt 8 ]; then
	echo "Pattern troppo piccolo"
	restorStdin
	exit 1
fi

./lcd-set-cgram-addr.sh $addr
for data in $byteList; do
	./lcd-write-data.sh $data
	#echo $data
done

exit 0
