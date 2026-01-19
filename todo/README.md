# Todo Keep App  
**Sviluppatore:** Francesco Stocco

## Descrizione del progetto

L’applicazione **Todo App** è una modifica dell’applicazione di partenza *am032_todo_list*, realizzata in Flutter, simile all’interfaccia e al comportamento di Google Keep.

L’obiettivo del progetto è stato quello di migliorare l’esperienza utente rendendo l’interfaccia più moderna e interattiva, eliminando il dialog di inserimento e introducendo una gestione diretta dei Todo tramite card, checkbox ed editing inline.

L’app consente di creare, modificare, completare ed eliminare attività in modo semplice e immediato.

## Funzionalità principali

- Visualizzazione dei Todo tramite card verticali
- Gestione dello stato di completamento tramite checkbox
- Modifica diretta del testo del Todo con tap
- Inserimento rapido di nuovi Todo tramite FloatingActionButton
- Eliminazione di un Todo con long press

## Scelte di sviluppo

- **Eliminazione del dialog di inserimento**
  - L’inserimento dei Todo avviene tramite FloatingActionButton che crea un nuovo Todo vuoto, subito modificabile.
  - Questo rende l’esperienza più fluida e simile a Google Keep.

- **Utilizzo delle Card al posto della ListTile**
  - Ogni Todo è contenuto in una Card per migliorare la leggibilità e l’aspetto grafico.
  - Le Card sono disposte verticalmente per una visualizzazione ordinata.

- **Checkbox per la gestione dello stato**
  - Il completamento di un Todo viene gestito tramite checkbox.
  - La checkbox sostituisce la sottolineatura presente nella versione originale.

- **Editing inline del testo**
  - Toccando il testo di un Todo, questo diventa modificabile tramite TextField.
  - L’editing termina automaticamente alla conferma dell’input.

- **Architettura Provider + ChangeNotifier**
  - È stato mantenuto l’approccio originale con `Provider` e `ChangeNotifier` per una gestione pulita dello stato.
  - Questo garantisce una separazione chiara tra logica e interfaccia.
