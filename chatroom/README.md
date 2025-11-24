# Chatroom

**Sviluppatore: Francesco Stocco**

## Descrizione del progetto

Il progetto **Chatroom TCP** consiste nella realizzazione di un sistema di messaggistica testuale basato su connessioni TCP, sviluppato in **Dart e Flutter**.  
Il sistema è composto da tre applicazioni principali:

- **Server TCP** scritto in Dart, responsabile della gestione delle connessioni, dei messaggi e degli utenti.
- **Client testuale** sempre in Dart, che permette agli utenti di collegarsi al server tramite terminale.
- **Client mobile Flutter**, versione evoluta e grafica del client testuale.

Quando un client si connette, il server richiede l’inserimento di uno **username**.  
Ogni messaggio inviato dal client viene distribuito a tutti gli altri utenti connessi, formando una vera e propria stanza di chat condivisa.

Il progetto dimostra l’utilizzo di socket TCP, ascolto di stream, gestione dello stato e aggiornamento dell’interfaccia grafica nel client mobile.

---

## Struttura generale del progetto

Il progetto si divide in tre componenti principali.

### **1. Server TCP (server.dart)**  
Contiene:

- configurazione del `ServerSocket`  
- classe `ChatClient` che gestisce ciascun utente  
- listener per nuovi messaggi  
- procedure di collegamento/disconnessione  
- broadcast dei messaggi verso tutti i partecipanti

### **2. Client testuale (client.dart)**  
Comprende:

- connessione al server tramite `Socket.connect()`  
- lettura dell'input da terminale  
- ascolto dei messaggi dal server tramite `socket.listen()`  
- gestione di eventuali errori o chiusure del server  

### **3. Client mobile Flutter (main.dart)**  
Strutturato in:

- Classe `ChatApp` → Impostazione dell'applicazione Flutter  
- Classe `ChatPage` (StatefulWidget) → Gestione dell’interfaccia e dello stato  
- Classe `_ChatPageState` → logica della chat, connessione, messaggi, UI  

L’interfaccia del client consiste in:

- una schermata iniziale con pulsante di connessione  
- una schermata di inserimento username  
- la lista dei messaggi scambiati  
- un campo di input e un pulsante "send"

---

## Scelte di sviluppo e motivazioni

### **ServerSocket e gestione delle connessioni**
L’utilizzo di `ServerSocket.bind()` permette di creare un server TCP semplice ma efficace.  
La scelta di ascoltare sulla porta **3000** è convenzionale e adatta per test in locale.

Il server registra ogni nuovo client in una lista (`clienti`) per poter inviare messaggi a tutti gli utenti connessi.

### **Classe ChatClient**
La creazione di una classe dedicata per ogni client permette di:

- mantenere le informazioni di ogni utente (socket, username, porta)  
- gestire i messaggi in arrivo tramite un listener dedicato  
- evitare un approccio procedurale troppo caotico  

Inoltre, nella costruzione della classe viene immediatamente registrato un ascolto sul socket, così da gestire in modo reattivo ogni nuovo messaggio.

### **Richiesta dello username come primo messaggio**
La scelta di usare il **primo messaggio** per assegnare il nome utente è semplice e funzionale:

- evita la creazione di comandi speciali  
- riduce la complessità del protocollo  
- mantiene la comunicazione leggibile  

Il server risponde confermando il nome e indicando quanti utenti sono già online.

### **Broadcast dei messaggi**
La funzione `distribuisciMessaggio()` inoltra il messaggio a tutti i client **tranne il mittente**, garantendo:

- comunicazione corretta tra utenti  
- assenza di duplicazione al mittente  
- comportamento coerente con una chatroom reale  

Questa funzione viene usata sia per i messaggi degli utenti, sia per notifiche di connessione o disconnessione.

### **Gestione della disconnessione**
Attraverso `gestoreFine()` e `gestoreErrore()`:

- il server rimuove il client dalla lista  
- informa gli altri utenti che qualcuno ha lasciato la chat  
- chiude il socket in modo sicuro  

Questa parte è fondamentale per evitare errori dovuti a socket zombie o utenti fantasma.

---

## Scelte per il client testuale

### **stdin.listen() per l'input utente**
È stato scelto `stdin.listen()` perché:

- permette di leggere input senza bloccare il programma  
- consente di scrivere in chat e ricevere messaggi contemporaneamente  
- si integra perfettamente con i socket asincroni di Dart

### **socket.listen() per ricevere messaggi**
Ogni messaggio ricevuto dal server viene immediatamente stampato nel terminale.  
Questa scelta garantisce una comunicazione **full-duplex** (bidirezionale e simultanea).

---

## Scelte per il client Flutter

### **StatefulWidget per la schermata principale**
È stato utilizzato un StatefulWidget perché la chat richiede aggiornamenti continui:

- arrivo di nuovi messaggi  
- passaggio da schermata username a schermata chat  
- aggiornamento del campo input  

`setState()` viene impiegato per modificare la lista dei messaggi in tempo reale.

### **Socket su Flutter con IP 10.0.2.2**
La scelta di usare **10.0.2.2** è obbligatoria sugli emulatori Android:  
representa l’indirizzo locale del computer host su cui gira il server.

In caso di dispositivo fisico si userebbe l’IP reale del PC sulla rete locale.

### **Interfaccia semplice e reattiva**
La UI sfrutta:

- `ListView.builder()` per mostrare i messaggi  
- un `TextField` per l’inserimento del testo  
- un `IconButton` con icona "send" per inviare  

La scelta è mirata a realizzare una chat minimalista, chiara e simile ai client di messaggistica reali.

### **Separazione tra scelta dello username e chat**
Lo stato `usernameSent` determina il passaggio tra:

1. Schermata inserimento username  
2. Chat completa  

Questo migliora l’usabilità e rispecchia il comportamento del client testuale.

### **dispose()**
Alla chiusura della schermata, il socket viene chiuso correttamente per evitare:

- memory leak  
- errori di connessione  
- problemi di aggiornamento del widget  