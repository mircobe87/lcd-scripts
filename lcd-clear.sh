#!/bin/bash

I2C_BUS="1"

LCD_ADDR="0x27"
REG_ADDR="0x00"

# Ripulisce il display e riporta il cursore nella mosizione iniziale
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x0C
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x08
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x1C
i2cset -y $I2C_BUS $LCD_ADDR $REG_ADDR 0x18
echo "Display is clean"

exit 0
