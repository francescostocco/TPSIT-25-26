# TripReview

**Sviluppatore:** Stocco Francesco

---

## Descrizione progetto

TripReview è un'applicazione mobile sviluppata in Flutter che mostra un catalogo di strutture turistiche (hotel, B&B, campeggi, appartamenti). Per ogni struttura vengono visualizzati nome, tipo, luogo, numero di stelle e le caratteristiche principali (numero di camere, presenza di piscina, WiFi, colazione, parcheggio).

L'utente può salvare le strutture che gli interessano nei propri preferiti, aggiungere note personali, assegnare una priorità e modificare o rimuovere queste informazioni in qualunque momento. Le strutture sono in sola lettura: vengono inserite nel `db.json` del backend e l'app si limita a leggerle. Tutte le operazioni di scrittura riguardano esclusivamente i preferiti dell'utente.

Il backend è simulato tramite **json-server**, mentre il client Flutter integra un database locale **SQLite** (pacchetto `sqflite`) come cache per garantire il funzionamento anche offline. L'app implementa il CRUD completo (GET, POST, PUT, PATCH, DELETE) sull'entità preferiti.

---

## Diario di progetto

### Commit 1 — Setup iniziale
Creazione del progetto Flutter, del file `db.json` con strutture e preferiti di esempio, e del `pubspec.yaml` con le dipendenze: `provider`, `http`, `sqflite`, `path`, `connectivity_plus`.

**Motivazione:** json-server è stato scelto per simulare rapidamente un backend REST completo a partire da un singolo file JSON. 
`provider` con `ChangeNotifier` è il pattern raccomandato dal team Flutter per app di piccole/medie dimensioni. 
`sqflite` è la libreria standard per SQLite nell'ecosistema Flutter, e `connectivity_plus` permette di rilevare lo stato della rete in modo cross-platform.

---

### Commit 2 — Modelli e servizio API
Creazione di `model.dart` con le classi `Struttura` e `Preferito`, ognuna con i metodi di serializzazione `fromJson`/`toJson` per il server e `fromMap`/`toMap` per SQLite. Implementazione di `api_service.dart` con tutti i metodi HTTP richiesti: GET sulle strutture (sola lettura) e CRUD completo sui preferiti.

**Motivazione:** ho separato `toJson`/`fromJson` da `toMap`/`fromMap` perché json-server e SQLite hanno rappresentazioni diverse (per esempio i bool diventano 0/1 in SQLite). Le strutture sono in sola lettura dal lato app perché concettualmente sono "configurate dal gestore del servizio" e l'utente le consulta soltanto. Tutto il CRUD richiesto dalla consegna viene implementato sui preferiti, che rappresentano le azioni effettive dell'utente.

---

### Commit 3 — Cache locale SQLite
Implementazione di `database_helper.dart` con due tabelle (`strutture` e `preferiti`) e i metodi per leggere, salvare e cancellare i record. Uso di `batch` per le scritture multiple.

**Motivazione:** ho mantenuto lo stesso pattern di `DatabaseHelper` usato in zkeep (metodi statici, apertura del db a ogni chiamata) per coerenza. Anche se le strutture sono in sola lettura dal server, vanno comunque salvate in cache per poter essere consultate offline, come richiesto dalla consegna. Le scritture sui preferiti vengono bloccate in modalità offline anziché bufferizzate in coda, per evitare conflitti di sincronizzazione che richiederebbero una logica più complessa.

---

### Commit 4 — Notifier e logica online/offline
Creazione di `StruttureNotifier extends ChangeNotifier` con il metodo `loadAll()` che gestisce automaticamente il fallback online/offline: se c'è connessione e il server risponde i dati vengono presi dal server e salvati in cache; altrimenti vengono letti dalla cache locale. Lo stato `isOffline` viene esposto al UI per mostrare il banner e disabilitare le scritture.

**Motivazione:** il try/catch attorno alle chiamate API è importante perché la connettività di rete può segnalare "online" anche quando il server non risponde (per esempio se è spento), e l'app deve comunque fare fallback sulla cache. Tenere il flag `isOffline` nel notifier permette ai widget di reagire automaticamente ai cambi di stato senza dover ricontrollare la connettività ogni volta.

---

### Commit 5 — Home con lista strutture
Creazione di `main.dart` e dei widget `struttura_card.dart`, `stelle_widget.dart`, `carat_chip.dart`. La home mostra le strutture in card con nome, tipo, luogo, stelle, chip dei servizi e descrizione. In alto a destra di ogni card un'icona a forma di cuore permette di aggiungere o rimuovere la struttura dai preferiti, aprendo il form di inserimento. Banner offline e icona dei preferiti con badge contatore nell'AppBar.

**Motivazione:** ho scelto di dividere i widget in file separati perché rende il codice più navigabile e facilita la riusabilità (per esempio `CaratChip` viene usato per ogni servizio, `StelleWidget` può essere usato in più punti). Le chip dei servizi vengono mostrate solo se attivi (`if (struttura.piscina) const CaratChip(...)`) per evitare un'interfaccia con icone barrate o ridondanti.

---

### Commit 6 — Preferiti e rifinitura finale
Creazione di `preferiti_screen.dart`, `preferito_card.dart`, `form_preferito_screen.dart`, `priorita_badge.dart`. Il form è riusabile sia per la creazione (POST) che per la modifica (PUT). Nella card del preferito, tre `ChoiceChip` permettono il cambio rapido della priorità tramite PATCH. Aggiunta dialog di conferma per la rimozione e SnackBar di feedback. Pulizia del codice e completamento del README.

**Motivazione:** il form riusabile evita la duplicazione: lo stesso widget gestisce sia POST che PUT differenziando dal parametro opzionale `Preferito?`. L'uso di `SegmentedButton` nel form e `ChoiceChip` nella card riflette due UX diverse: nel form si compila tutto insieme (PUT), nella card si fa una modifica veloce di un solo campo (PATCH) — è il caso d'uso reale dell'aggiornamento parziale richiesto dalla consegna. I dialog di conferma sono mostrati solo per le operazioni distruttive (DELETE).