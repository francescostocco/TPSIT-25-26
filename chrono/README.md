# Chrono  
**Sviluppatore:** Francesco Stocco  

---

## Descrizione del progetto  

**Chrono** è un cronometro digitale realizzato in **Flutter** e scritto in **Dart**, che utilizza due *Stream* per simulare un flusso continuo di eventi temporali.  
L’app consente di **avviare**, **mettere in pausa**, **riprendere** e **resettare** il conteggio del tempo in modo reattivo e fluido.

Il primo stream, detto **ticker**, genera eventi con una certa frequenza (ogni 100 millisecondi), mentre il secondo stream elabora tali eventi per ottenere il numero di **secondi trascorsi**.  
L’interfaccia mostra il tempo in formato leggibile **(minuti:secondi)** e presenta due **FloatingActionButton** per il controllo dello stato del cronometro (**START/STOP** e **PAUSE/RESUME**).

---

## Struttura generale del codice

Il progetto è composto da un solo file principale `main.dart`, strutturato nel seguente modo:

- **Classe `MyApp`** → contiene la configurazione principale dell’app (`MaterialApp`).  
- **Classe `StopWatchPage` (StatefulWidget)** → rappresenta la schermata principale del cronometro.  
- **Classe `_StopWatchPageState`** → contiene tutta la logica del cronometro (stream, metodi e gestione dello stato).

---

## Scelte di sviluppo e motivazioni

### StatefulWidget (`StopWatchPage`)
È stato scelto un **StatefulWidget** perché l’app deve aggiornare dinamicamente l’interfaccia ogni volta che cambia il tempo o lo stato (start, pausa, reset).  
Grazie al metodo `setState()`, ogni variazione viene immediatamente riflessa nella GUI.

---

### `_ticker()`
Questo metodo genera uno **Stream periodico** che produce un evento ogni **100 millisecondi**.  
L’uso di `Stream.periodic()` è perfetto per creare un “battito d’orologio” reattivo, senza bloccare l’interfaccia utente.

---

### `_secondsStream()`
Questo secondo stream **filtra gli eventi del ticker**, producendo un nuovo valore ogni **secondo**.  
Ogni stream ha un compito distinto:
- Il primo scandisce il tempo.
- Il secondo calcola i **secondi effettivi** trascorsi.

---

### `_start()`
Avvia il cronometro.  
Crea e collega gli stream, aggiornando i secondi solo se il cronometro non è in pausa.  
Grazie alla variabile `_seconds`, il tempo **riprende correttamente da dove era stato messo in pausa**.

---

### `_pauseResume()`
Permette di **mettere in pausa o riprendere** il cronometro.  
Non è necessario interrompere gli stream, perché i listener verificano la variabile `_paused` prima di aggiornare il tempo.

---

### `_reset()`
Ferma gli stream e **azzera** tutte le variabili, riportando l’interfaccia allo stato iniziale.

---

### `formatTime()`
Converte i secondi totali nel formato **“MM:SS”**, mantenendo sempre due cifre anche con numeri inferiori a 10 (grazie a `padLeft()`).

---

### `dispose()`
Eseguito automaticamente quando il widget viene eliminato.  
Chiude gli stream per evitare perdite di memoria o errori di aggiornamento.

---

### `build()`
Costruisce l’interfaccia grafica:

- **Scaffold** → struttura base dell’app.  
- **AppBar** → mostra il titolo “Chrono”.  
- **Text()** → mostra il tempo in grande formato e centrato.  
- **FloatingActionButton** → due pulsanti:
  - Uno alterna **Start** e **Stop**.  
  - L’altro alterna **Pause** e **Resume**.