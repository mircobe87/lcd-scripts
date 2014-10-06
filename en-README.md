# lcd-scripts

È un set di script bash per il controllo (via RaspberryPI GPIO) di un display
LCD a 16x2 caratteri gestito da un controller HD44780 interfacciato su un bus
I<sup>2</sup>C da un opportuno I/O-expander.


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


## I<sup>2</sup>C adapter

Per dare al display un interfaccia I<sup>2</sup>C è stato utilizzato il seguente
modulo.

![i2c-adapter](./i2c-adapter.png "i2c-adapter")

Questo adattatore usa lo I/O-expander a 8 bit PCF8574T
([datasheet](http://www.nxp.com/documents/data_sheet/PCF8574.pdf)) che ha
**`0x27`** come indirizzo I<sup>2</sup>C standard. Gli 8 bit disponibili sono
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
- Tutti gli script in questione assumono che l'indirizzo I<sup>2</sup>C del
dispositivo sia quello di default **`0x27`** e che la rimappatura dei pin sia
quella mostrata nella precedente tabella.

- Tutti gli script utilizzano la variabile d'ambiente `I2C_BUS` per operare sul
bus I<sup>2</sup>C corretto. Impostare questa variabile prima dell'utilizzo
degli scripts. Valori comuni sono `0` o `1`.

- Gli script sono realizzati utilizzando il tool **`i2cset`**, assicurarsi che
il tool sia presente nel sistema.
 
- Prima di inviare altri comandi al display è necessario impostare il formato
di comunicazione in nibble eseguendo lo script **lcd-function-set.sh**.
 
- Lo script **lcd-set-ddram-addr.sh** utilizza il tool bash `bc`, assicurarsi
che tale strumento sia installato nel sistema.
 
- Il Tool **lcdTool-print.sh** utilizza il comando bash `hexdump`, assicurarsi
che tale strumento sia installato nel sistema.
 
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
 
- **lcd-return-home.sh**: invia l'istruzione `return home` con l'effetto di
portare sia il cursore che il display nella loro posizione iniziale. Il
contenuto in caratteri del display non viene alterato.
 
- **lcd-cursor-display-shift.sh**: invia l'istruzione `display or cursor shift`
con l'effetto di muovere il cursore o il display di una posizione a destra o
sinistra senza modificare il contenuto.
 
- **lcd-backlight.sh**: accende o spegne la retroilluminazione del display.
 
- **lcd-set-ddram-addr.sh**: invia l'istruzione `set DDRAM address` con l'effetto
di spostare il cursore in maniera *random* sul display. Ogni posizione del
cursore ha un indirizzo; i possibili indirizzi variano se si lavora su una o
dure righe:
  - *1 Linea*: Si hanno a disposizione **80** posizioni con indirizzi che
  variano da **0x00** a **0x4F**.
  - *2 Linee*: Si hanno a disposizione **40** posizioni per riga con
  indirizzi che variano:
    - *riga 1*: da **0x00** a **0x27**
    - *riga 2*: da **0x40** a **0x67**

  Ogni riga è come un vettore "circolare", ovvero l'indirizzo dell'ultima
  posizione è anche quello della posizione precedente alla prima.

- **lcd-write-data.sh**: invia l'istruzzione `Write data to CG or DDRAM` con
l'effetto di scrivere un carattere sul display nella posizione corrente del
cursore. I valori ammessi per i caratteri sono quelli della codifica UTF-8 con
la particolarità che per quei valori che in UTF-8 sono caratteri non stampabili
(di controllo) mentre, nel controller del display sono rimappati con caratteri
particolari (vedi pagine 17-18 del
[datasheet](http://www.nxp.com/documents/data_sheet/PCF8574.pdf)).
 
- **lcd-set-cgram-addr.sh**: invia l'istruzione `set CGRAM address` con
l'effetto di spostare il cursore nell'area di memoria dove definire caratteri.
L'invio successivo di dati viene interpretato come la definizione di un nuovo
pattern. Per tornare a scrivere sul display è necessario spostare il cursore
in una posizione della DDRAM. L'indirizzo specificato in questo comando non
indica la locazione dove verrà memorizzato il carattere ma indica la locazione
della prima riga che compone il pattern del carattere. Avendo a disposizione
spazio per 8 caratteri ci sono indirizzi per tutte le 64 righe che li
compongono (da 0x00 a 0x3F). Per maggiori dettagli si veda la pag. 19 del
[datasheet](http://www.nxp.com/documents/data_sheet/PCF8574.pdf)).

###Tools
Sono stati realizzati alcuni tool sugli script precedenti per agevolare qualche
operazione sul display:

- **lcdTool-print.sh**: consente di scrivere sul display una stringa di testo
possatagli come argomento. La stringa deve essere specificata tra doppi apici (
" "). La stringa viene scritta sul display a partire dalla attuale posizione
del cursore.
 
- **lcdTool-set-custom-char.sh**: consente di inviare al display un carattere
personalizzato. Il pattern è composto da 8 righe di testo di 5 caratteri 0 o 1:
0 indica un pixel spento, 1 acceso. Il pattern può essere letto da file o da
standard input. Il nuovo carattere viene memorizzato in uno degli 0 indirizzi
DDRAM disponibili (da 0x00 a 0x07).
