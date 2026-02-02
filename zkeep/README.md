# ZKeep  
**Sviluppatore:** Francesco Stocco

## Descrizione del progetto

ZKeep è un’applicazione sviluppata in Flutter ispirata a Google Keep.  
Il progetto nasce come una semplice Todo List e viene successivamente esteso per gestire più note, ognuna contenente una lista di promemoria.

L’app permette di creare, modificare ed eliminare note visualizzate sotto forma di card. Ogni card contiene un titolo e una lista di promemoria con checkbox per indicarne il completamento.

---

## Scelte di sviluppo

- **Struttura Note / Todo**  
  Ogni nota è composta da una lista di Todo. Questa scelta consente di organizzare i promemoria in modo chiaro e modulare.

- **Interfaccia a griglia (GridView)**  
  Le note sono visualizzate in una griglia a due colonne per sfruttare meglio lo spazio e richiamare lo stile di Google Keep.

- **Utilizzo delle Card**  
  Ogni nota è rappresentata da una Card per separare visivamente i contenuti e migliorare la leggibilità dell’interfaccia.

- **Titolo della nota separato dai promemoria**  
  Il primo Todo viene utilizzato come titolo della nota ed è visualizzato con dimensione maggiore e testo in grassetto.

- **Modifica del testo direttamente nella UI**  
  Titoli e promemoria possono essere modificati con un semplice tap, senza finestre di dialogo aggiuntive.

- **Checkbox per i promemoria**  
  Ogni Todo dispone di una checkbox che permette di segnare il promemoria come completato, applicando la barratura al testo.

- **Scroll interno alle Card**  
  Le liste di promemoria sono scrollabili per evitare problemi di overflow quando il contenuto aumenta.

- **Gestione dello stato con Provider**  
  È stato utilizzato il package Provider con ChangeNotifier per separare la logica dall’interfaccia e gestire correttamente gli aggiornamenti della UI.

- **FloatingActionButton per aggiungere nuove note**  
  L’aggiunta di una nuova nota avviene tramite FloatingActionButton, seguendo le linee guida del Material Design.
