#!/bin/bash

I2C_BUS="1"

LCD_ADDR="0x27"
REG_ADDR="0x00"

if [ "$1" = "-d" -a "$2" = "0" -a "$3" = "-c" -a "$4" = "0" -a "$5" = "-b" -a "$6" = "0" ]; then
	# display OFF
	# cursore OFF
	# blink   OFF
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x8C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x88
	
	echo "display: OFF"
	echo "cursore: OFF"
	echo "blink:   OFF"
elif [ "$1" = "-d" -a "$2" = "0" -a "$3" = "-c" -a "$4" = "0" -a "$5" = "-b" -a "$6" = "1" ]; then
	# display OFF
	# cursore OFF
	# blink   ON
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x9C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x98
	
	echo "display: OFF"
	echo "cursore: OFF"
	echo "blink:   ON"
elif [ "$1" = "-d" -a "$2" = "0" -a "$3" = "-c" -a "$4" = "1" -a "$5" = "-b" -a "$6" = "0" ]; then
	# display OFF
	# cursore ON
	# blink   OFF
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xAC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xA8

	echo "display: OFF"
	echo "cursore: ON"
	echo "blink:   OFF"
elif [ "$1" = "-d" -a "$2" = "0" -a "$3" = "-c" -a "$4" = "1" -a "$5" = "-b" -a "$6" = "1" ]; then
	# display OFF
	# cursore ON
	# blink   ON
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xBC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xB8

	echo "display: OFF"
	echo "cursore: ON"
	echo "blink:   ON"
elif [ "$1" = "-d" -a "$2" = "1" -a "$3" = "-c" -a "$4" = "0" -a "$5" = "-b" -a "$6" = "0" ]; then
	# display ON
	# cursore OFF
	# blink   OFF
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xCC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xC8
	
	echo "display: ON"
	echo "cursore: OFF"
	echo "blink:   OFF"
elif [ "$1" = "-d" -a "$2" = "1" -a "$3" = "-c" -a "$4" = "0" -a "$5" = "-b" -a "$6" = "1" ]; then
	# display ON
	# cursore OFF
	# blink   ON
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xDC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xD8
	
	echo "display: ON"
	echo "cursore: OFF"
	echo "blink:   ON"
elif [ "$1" = "-d" -a "$2" = "1" -a "$3" = "-c" -a "$4" = "1" -a "$5" = "-b" -a "$6" = "0" ]; then
	# display ON
	# cursore ON
	# blink   OFF
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xEC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xE8
	
	echo "display: ON"
	echo "cursore: ON"
	echo "blink:   OFF"
elif [ "$1" = "-d" -a "$2" = "1" -a "$3" = "-c" -a "$4" = "1" -a "$5" = "-b" -a "$6" = "1" ]; then
	# display ON
	# cursore ON
	# blink   ON
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xFC
	i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0xF8
	
	echo "display: ON"
	echo "cursore: ON"
	echo "blink:   ON"
else
	# errore parametri
	echo -e "USO:"
	echo -e "  $0 -d <ON/OFF> -c <ON/OFF> -b <ON/OFF>\n"
	echo -e "OPZIONI:"
	echo -e "  -d  accende o spegne il display."
	echo -e "  -c  accende o spegne il cursore."
	echo -e "  -b  accende o spegne il lampeggiare del cursore.\n"
	echo -e "  <ON/OFF>  0 - spento"
	echo -e "            1 - acceso\n"
fi

exit 0

