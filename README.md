# lcd-scripts

È un set di script bash per il controllo (via RaspberryPI GPIO) di un display
LCD a 16x2 caratteri gestito da un controller HD44780 interfacciato su un bus
I<sub>2</sub>C da un opportuno I/O-expander.


## Il Display

Il dispositivo pilotato è LCD QC1602A v2.0
([datasheet](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)). Il display
presenta 16 pin di controllo come in figura.

![lcd-pinout](./lcd-pinout.gif "lcd-pinout")

01. **VSS**: GND
02. **VDD**: +Vcc
03. **V0**:  regolazione contrasto
04. **RS**:  selezione registro (0 - comandi, 1 - dati)
05. **RW**:  lettura (1) o scrittura (0)
06. **E**:   enable (attiva il diplay sul fronte di discesa)
07. **DB0**: pin 0 del bus dati
08. **DB1**: pin 1 del bus dati
09. **DB2**: pin 2 del bus dati
10. **DB3**: pin 3 del bus dati
11. **DB4**: pin 4 del bus dati
12. **DB5**: pin 5 del bus dati
13. **DB6**: pin 6 del bus dati
14. **DB7**: pin 7 del bus dati
15. **A**:   anodo retroilluminazione
16. **K**:   catodo retroilluminazione


## I<sub>2</sub>C adapter

Per dare al display un interfaccia I<sub>2</sub>C è stato utilizzato il seguente
modulo.

![i2c-adapter](./i2c-adapter.png "i2c-adapter")

Questo adattatore usa lo I/O-expander a 8 bit PCF8574T
([datasheet](http://www.nxp.com/documents/data_sheet/PCF8574.pdf)) che ha
**`0x27`** come indirizzo I<sub>2</sub>C standard. Gli 8 bit disponibili sono
stati mappati sul display nel seguente modo:

PC8574T bus pin | LCD QC1602A pin
:--------------:|:---------------:
P0              |RS
P1              |RW
P2              |E
P3              |BlackLight
P4              |DB4
P5              |DB5
P6              |DB6
P7              |DB7

Essendo utilizzati solo i 4 bit più significativi del bus dati del display, la
comunicazione con quest'ultimo avverrà in nibble anziché in byte.


## Usare il display da terminale
###Note
 - Tutti gli script in questione assumono che l'indirizzo I<sub>2</sub>C del
 dispositivo sia quello di default **`0x27`** e che la rimappatura dei pin sia
 quella mostrata nella precedente tabella.

 - Tutti gli script utilizzano il bus I<sub>2</sub>C numero **1** del
 RaspberryPi; a seconda della revisione sarà necessario modificare gli script
 impostando il bus 0.

 - Gli script sono realizzati utilizzando il tool **`i2cset`**, assicurarsi che
 il tool sia presente nel sistema.
 
 - Prima di inviare altri comandi al display è necessario impostare il formato
 di comunicazione in nibble eseguendo lo script **lcd-function-set.sh**.

### Scripts
Gli script sono realizzati con l'idea di rendere disponibile all'utente le
istruzioni descritte nel
[datasheet](http://www.nxp.com/documents/data_sheet/PCF8574.pdf) del display
(pag. 24-25).

 - **lcd-function-set.sh**: invia l'istruzione `function set` al display
 permettendo di selezionare il numero di linee e il formato dei caratteri
 visualizzi; lo script imposta il display per comunicare in nibble e può essere
 eseguito solo una volta.
 
 - **lcd-entry-mode.sh**: invia l'istruzione `entry mode set` e permette di
 specificare il comportamento del cursore e del display ogni volta che viene
 scritto un carattere; si sceglie la direzione di spostamento del cursore (a
 destra o sinistra) e se "shiftare" anche l'intero display.
 
 - **lcd-display-ctrl.sh**: invia l'istruzione `display control` e permette di
 specificare se si vuole accendere o spegnere: il display, il cursore e il
 cursore lampeggiante. A display spento è comunque possibile scrivere caratteri,
 ma questi non verranno visualizzati fintanto che il display non verrà acceso.
 Inoltre è possibile scrivere indipendentemente dalla presenza o meno del
 cursore.
 
 - **lcd-clear.sh**: invia l'istruzione `clear` con l'effetto di rimuovere il
 contenuto del display e riportare il cursore alla posizione iniziale.

