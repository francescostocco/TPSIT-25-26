# ZKeep  
**Sviluppatore:** Francesco Stocco

## Descrizione del progetto

ZKeep è un'applicazione sviluppata in Flutter ispirata a Google Keep.  
Il progetto nasce come una semplice Todo List e viene successivamente esteso per gestire più note, ognuna contenente una lista di promemoria.

L'app permette di creare, modificare ed eliminare note visualizzate sotto forma di card. Ogni card contiene un titolo e una lista di promemoria con checkbox per indicarne il completamento.

**Persistenza dei dati:** L'applicazione utilizza SQLite per salvare in modo permanente tutte le note e i promemoria, garantendo che i dati rimangano disponibili anche dopo la chiusura dell'app.

---

## Scelte di sviluppo

- **Struttura Note / Todo**  
  Ogni nota è composta da una lista di Todo. Questa scelta consente di organizzare i promemoria in modo chiaro e modulare.

- **Interfaccia a griglia (GridView)**  
  Le note sono visualizzate in una griglia a due colonne per sfruttare meglio lo spazio e richiamare lo stile di Google Keep.

- **Utilizzo delle Card**  
  Ogni nota è rappresentata da una Card per separare visivamente i contenuti e migliorare la leggibilità dell'interfaccia.

- **Titolo della nota separato dai promemoria**  
  Il primo Todo viene utilizzato come titolo della nota ed è visualizzato con dimensione maggiore e testo in grassetto.

- **Modifica del testo direttamente nella UI**  
  Titoli e promemoria possono essere modificati con un semplice tap, senza finestre di dialogo aggiuntive. Le modifiche vengono salvate automaticamente nel database.

- **Checkbox per i promemoria**  
  Ogni Todo dispone di una checkbox che permette di segnare il promemoria come completato, applicando la barratura al testo. Lo stato viene immediatamente persistito nel database.

- **Scroll interno alle Card**  
  Le liste di promemoria sono scrollabili per evitare problemi di overflow quando il contenuto aumenta.

- **Gestione dello stato con Provider**  
  È stato utilizzato il package Provider con ChangeNotifier per separare la logica dall'interfaccia e gestire correttamente gli aggiornamenti della UI. Il notifier comunica con il DatabaseHelper per tutte le operazioni sui dati.

- **FloatingActionButton per aggiungere nuove note**  
  L'aggiunta di una nuova nota avviene tramite FloatingActionButton, seguendo le linee guida del Material Design.

- **Indicatore di caricamento**  
  Durante il caricamento dei dati dal database viene mostrato un CircularProgressIndicator per migliorare l'esperienza utente.

---

## Gestione Database

### DatabaseHelper

Il progetto implementa la persistenza dei dati tramite SQLite attraverso la classe `DatabaseHelper`, che gestisce tutte le operazioni sul database locale.

**Struttura del database:**  
Il database `zkeep.db` è organizzato in due tabelle principali collegate tra loro: una per le note e una per i singoli promemoria (todo). Ogni nota può contenere multipli todo, creando una relazione uno-a-molti. Quando una nota viene eliminata, tutti i suoi todo vengono automaticamente rimossi grazie alla configurazione CASCADE DELETE.

**Funzionalità principali:**
- Inizializzazione automatica del database all'avvio dell'app
- Operazioni di lettura per recuperare tutte le note con i relativi todo
- Inserimento di nuove note e promemoria con generazione automatica degli ID
- Aggiornamento dello stato e del testo dei promemoria
- Eliminazione di note e todo con gestione automatica delle relazioni
- Funzione di debug per popolare il database con dati di esempio

**Integrazione con l'app:**  
Il `NoteListNotifier` si interfaccia direttamente con il `DatabaseHelper` per ogni operazione. Quando l'utente aggiunge, modifica o elimina una nota o un promemoria, l'azione viene immediatamente salvata nel database. Al riavvio dell'app, tutte le note vengono automaticamente ricaricate, garantendo la persistenza completa dei dati tra le sessioni.