# Inferior Mind 
**Sviluppatore:** Francesco Stocco  

---

## Descrizione del progetto
Inferior Mind è una versione molto semplice del gioco Master Mind.  
Il giocatore deve indovinare un codice di 4 colori generato casualmente dal programma.  
Viene premuto l'ElevatedButton in basso a destra per verificare se la combinazione di colori inserita 
corrisponde alla combinazione generata casualmente: se sbagliata, si ricomincia da capo con tutti e 4 i bottoni 
grigi e una nuova combinazione segreta viene generata.

---

## Scelte di sviluppo e motivazioni

- **StatefulWidget (InferiorMind)**  
  È stato scelto di utilizzare un StatefulWidget perché l'app, nel momento in cui l’utente
  clicca i bottoni, deve essere in grado di reagire alle modifiche dello stato e aggiornare l’interfaccia.

- **initState()**  
  Il metodo viene chiamato automaticamente una sola volta, all’avvio del widget, e serve per inizializzare i dati.  
  All’interno viene richiamato il metodo _generaSegreto() per creare la combinazione di colori segreta da indovinare.

- **_generaSegreto()**  
  Il metodo, tramite un oggetto Random, genera 4 numeri casuali da 0 a 3 e li inserisce nella lista segreto.  
  Ogni numero rappresenta l’indice di un colore nella lista colori.  
  Il programma crea una combinazione diversa a ogni partita.

- **_cambiaColore()**  
  Metodo chiamato quando l’utente preme uno dei 4 bottoni colorati.  
  Serve a far cambiare il colore del singolo bottone.
  Quando si arriva all’ultimo colore disponibile si ricomincia dal primo.  
  Utilizza la funzione setState() per aggiornare lo stato e ridisegnare l’interfaccia con il nuovo colore selezionato.

- **_verifica()**  
  Quando viene premuto il pulsante “Verifica”, viene chiamato questo metodo.  
  Tramite una variabile booleana controlla se la combinazione inserita dall’utente corrisponde alla combinazione segreta.  
  Se almeno un colore è diverso, la variabile passa da true a false.  
  In base al valore della variabile, viene mostrato un messaggio che comunica se la combinazione è corretta o meno.  
  Quando si preme il pulsante “OK”, il gioco si resetta: viene generata una nuova combinazione e i bottoni tornano tutti grigi.

- **showDialog() e AlertDialog**  
  Utilizzati per mostrare un messaggio di vittoria o errore all’utente.  
  Con AlertDialog è stato inserito anche un pulsante “OK”, che permette di chiudere la finestra di messaggio e ricominciare la partita.

- **build()**  
  Il metodo build() viene richiamato ogni volta che lo stato del widget cambia, ad esempio quando l’utente preme un bottone e viene eseguito setState().  
  All’interno di questo metodo viene costruita tutta l’interfaccia grafica dell’app.  
  In particolare:
    - Column viene usata per mettere gli elementi verticalmente al centro dello schermo.  
    - Row contiene i 4 bottoni circolari in linea orizzontale.  
    - Ogni bottone è un ElevatedButton a forma di cerchio e cambia colore quando viene premuto.  
    - Il FloatingActionButton.extended in basso a destra controlla se la combinazione inserita è corretta.  