# Domande es 4

La lista mostrata è non esaustiva e contiene un elenco di domande che sono state proposte come quarto esercizio nel corso degli anni.

## Generici

- Baseline sta a versioni di sistema come codeline sta a versioni di componente. (F)
percorsi. (V)
- In un modello dataflow (DFD) un'attività composta non può essere collegata direttamente ad un attore esterno. (F)
- Il CMMI è totalmente slegato dal CMM. (F)
- Un task d'interazione (taskI) rappresenta una singola interazione di un modello di collaborazione. (F)
- Nel project management il metodo PERT chiede 3 stime (di durata) per ogni task; il risultato è la media delle 3 stime. (F)
- In un sistema bancario ogni bonifico ha un importo (Integer) ed è collegato ad un conto (corrente) che è collegato a vari bonifici. Dato il contoX l'espressione navigazionale contoX.bonifici ([importo <= 4000]) dà l'elenco dei bonifici con importi inferiori a 4000. (F)
- Una classe associativa (association class) ha due relazioni obbligatorie con molteplicità 1 (V)
-  Il metodo di Fagan può essere complementare al testing del software
- Le confluenze si trovano nelle reti di tipo State Machine e Grafi Marcati. (F, Non ci cono confluenze nei grafi marcati)
- La regola di riduzione che riguarda le transizioni in parallelo si applica quando due o più transizioni hanno un posto di input in comune e un posto di output in comune. (Falso. Occorre aggiungere che le transizioni non devono avere altri posti di input (output) oltre a quello in comune.)

## Reti di petri

- Nelle reti AC il numero dei token presenti nei posti di una trappola non è mai zero. (F)
- Due posti, p1 e p2, di una rete di Petri si dicono in serie se c'è una transizione t che ha p1 come unico input e p2 come unico output. (F)
- Un grafo marcato può essere analizzato mediante trappole e sifoni; in questo caso i circuiti corrispondono a trappole (F)
- Una rete free-choice bounded e fortemente connessa è sicuramente live. (F)
- Una rete free-choice fortemente connessa i cui task sono passanti o fork è unbounded (V)
- In una rete di Petri due transizioni si dicono in parallelo se hanno un solo posto di input che è comune ad entrambe (F)

## B2B

- Un'interazione partecipativa ha lo scopo di collegare il dato trasmesso con un dato trattato dal processo B2B al quale l'interazione si riferisce. (T)
- l'espressione navigazionale seguente dà la lista dei nomi dei dipartimenti che hanno almeno un progettista tra i loro impiegati.dipartimenti ([impiegati (qualifica == progettista)] > 0).nome (V)

## BPN

- Nei processi BPN un task composto è equivalente ad una scelta composta. (F)
- Nei processi BPN tutti i task umani hanno almeno 1 posto di input e almeno 1 posto di output. (F, una entry task non ha task di input)
- Per determinare il percorso critico in un progetto si può usare la tecnica di calcolo del tempo ciclo nei grafi marcati temporizzati. (V)
- Un modello di processo BPN può combinare i lifecycle di due o più tipi di entità. (V)

## BPMN

- Nel BPMN tutti i gateway (xor, and, or) sono rappresentabili direttamente con reti di Petri. (F)

## Whitebox testing

- Nel testing white box il numero minimo di casi di test necessari per la copertura dei branch (edge o link) di un programma può essere uguale a quello per la copertura dei percorsi. (V)
- In un white box testing la copertura delle condizioni multiple può essere uguale alla copertura dei percorsi (in termini di casi di test). (V)
- Nel testing white box il numero minimo di casi di test necessari per la copertura delle condizioni multiple è sempre maggiore di quello per la copertura dei link (edge). (F)
- Nel testing white box (WBT) di un programma è possibile che il numero minimo di test necessari a coprire le condizioni multiple sia maggiore di quello dei test necessari a coprire i 
- In un grafo WBT che, oltre ai nodi d'azione, contiene tre condizioni in cascata la prima è la tripla x||y||z, la seconda è la doppia a&&b e la terza è la doppia c&&d - il numero minimo di test per la copertura dei percorsi è uguale al minimo numero di test per la copertura delle condizioni multiple. (Vero: le tre condizioni sono sequenziali: 8 casi per la tripla (CM), 8 percorsi per le 3 condizioni sequenziali)
- In un grafo WBT che oltre ai nodi d'azione contiene due condizioni, la doppia a && b e la semplice x > 10, il numero minimo di test per la copertura dei percorsi può essere uguale al minimo numero di test per la copertura delle condizioni multiple. (Falso se si considerano i test, vero se si considerano i numeri dei test; valide entrambe le risposte Falso e Vero)

## Git

- In Git il comando commit esporta un progetto locale nel repository remoto. (F)
- Nel repository di Git un oggetto commit può essere collegato ad un altro commit al più (F)
- Il punto di partenza della pipeline di un sistema di continuous integration può essere un ambiente di version control come Git. (V)

## Sviluppo moderno

- Nel manifesto dello sviluppo agile i processi sono più importanti delle persone. (F)
- Il team di sviluppo e il team delle operations si occupano entrambi dell'integrazione continua. (Falso: l'operations team si occupa del continuous delivery)
- I microservizi possono essere rilasciati separatamente perché hanno un buon grado di autonomia (V)
- Un'istanza di processo SCRUM è governata dallo SCRUM master. X (F)