# Chrono  
**Sviluppatore:** Francesco Stocco  

---

## Descrizione del progetto  
**Chrono** è un semplice cronometro digitale realizzato in **Flutter** e scritto in **Dart**, che utilizza due **Stream** per simulare un flusso continuo di eventi temporali.  
L’applicazione consente di **avviare**, **mettere in pausa**, **riprendere** e **resettare** il conteggio del tempo in modo reattivo e fluido.  

Il primo stream, detto **ticker**, genera eventi con una certa frequenza (ogni frazione di secondo), mentre il secondo stream elabora tali eventi per ottenere il numero di **secondi trascorsi**.  
L’interfaccia mostra il tempo in formato leggibile (minuti:secondi.frazioni) e presenta due **FloatingActionButton** per il controllo dello stato del cronometro (START/STOP/RESET e PAUSE/RESUME).

---

## Struttura generale del codice  

Il progetto è composto da un solo file principale `main.dart`, strutturato nel seguente modo:

- **Classe `MyApp`**: contiene la configurazione principale dell’app (MaterialApp).
- **Classe `StopWatchPage` (StatefulWidget)**: rappresenta la schermata principale del cronometro.
- **Classe `_StopWatchPageState`**: contiene tutta la logica del cronometro (stream, metodi e gestione dello stato).

---

## Scelte di sviluppo e motivazioni  

### StatefulWidget (`StopWatchPage`)
È stato scelto di utilizzare un **StatefulWidget** perché l’app deve aggiornare dinamicamente l’interfaccia ogni volta che il tempo cambia, o quando vengono premuti i pulsanti di controllo.  
Grazie al metodo `setState()`, ogni variazione del tempo o dello stato (start, pausa, reset) viene immediatamente riflessa nella GUI.

---

### createTicker()
Questo metodo genera uno Stream periodico che produce un evento ogni 100 millisecondi (0.1 secondi).
L’uso di Stream.periodic() è perfetto per creare un “ticker” che scandisce il tempo, in modo simile al battito di un orologio.
È una soluzione reattiva e asincrona, quindi non blocca l’interfaccia utente.

### createSecondsStream()

Questo secondo stream filtra gli eventi del ticker:
ogni 10 eventi (cioè ogni secondo), produce un nuovo valore incrementale.
Ogni stream ha un compito distinto: uno scandisce il tempo, l’altro calcola i secondi effettivi.

### _start()
Questo metodo viene chiamato quando si preme il pulsante START.
Crea entrambi gli stream.
Si collega agli stream del ticker e dei secondi.
Aggiorna i millisecondi e i secondi solo se il cronometro non è in pausa.
setState() viene usato per aggiornare la UI in tempo reale.
Le condizioni _paused impediscono di far avanzare il tempo durante la pausa.

### _togglePause()
Permette di mettere in pausa o riprendere il cronometro senza fermarlo del tutto.
Cambiare il valore di _paused è sufficiente, perché i listener degli stream controllano già questa variabile prima di aggiornare lo stato.
Non serve fermare o ricreare gli stream.

### _reset() e _stop()
Ferma gli stream e azzera tutte le variabili, riportando l’interfaccia allo stato iniziale.

### formatTime()
Serve per convertire i millisecondi in formato leggibile “MM:SS.d”.
Usa padLeft() per mantenere sempre due cifre anche con numeri inferiori a 10.

### dispose()
Viene eseguito automaticamente quando il widget viene eliminato.
Cancella gli stream per evitare perdite di memoria o errori di aggiornamento quando l’app viene chiusa.

### build()
Il metodo build() costruisce l’interfaccia grafica.

Scaffold → struttura base dell’interfaccia.

AppBar → mostra il titolo “Chrono”.

Text() → mostra il tempo in grande formato e centrato.

FloatingActionButton → due pulsanti per il controllo dello stato:
- Il primo alterna Start e Reset.
- Il secondo alterna Pause e Resume, disabilitato se il cronometro è fermo.