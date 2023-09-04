# Domande generate

La seguente è una collezione di domande ipotizzate in aiuto e preparazione all'esame, data la scarsità delle prove d'esame. Per questo motivo non sono da considerarsi materiale ufficiale ma unicamente di supporto.

## Domanda 1

Differenza tra smart pointer condivisi come Arc ed Rc e Cell/RefCell, gli ultimi sono utilizzati come shared pointer?

<details>
<summary>Soluzione</summary>

Cell e RefCell servono per consentire la mutabilità interna o il borrowing mutabile di dati immutabili, ma mantengono sempre un singolo proprietario. Non implementano una vera condivisione dei dati.

Rc e Arc invece sono progettati per permettere il possesso condiviso e la concorrenza, implementano l'atomicità, e possono essere clonati per ottenere più "possessori".

Quindi, qualche differenza chiave:

Rc/Arc - condivisione, clonazione, atomicità, reference counting
Cell/RefCell - mutabilità interna, nessuna condivisione, proprietà singola
In generale, se si necessita di una condivisione multi-proprietario sicura tra thread, è molto più indicato usare Rc/Arc rispetto a Cell/RefCell.

Cell e RefCell vanno usati per i casi d'uso specifici di mutabilità interna per cui sono progettati, non come generici shared pointer.

</details>


## Domanda 2

Qual è la differenza tra variabili che vivono nello stack e variabili che vivono nell'heap in Rust? Fornire esempi.

## Domanda 3

Cos'è un trait in Rust? Come permette il polimorfismo statico? Fare un esempio.

<details>
<summary>Soluzione</summary>


</details>

## Domanda 4

Come si condivide efficacemente lo stato tra thread in Rust? Quali sono i pericoli?


<details>
<summary>Soluzione</summary>

In Rust esistono diversi modi per condividere dati e sincronizzare l'accesso tra thread in modo efficiente e sicuro:

Il tipo Arc<T> permette di condividere un valore immutabile tra thread usando il reference counting atomico.
Il tipo Mutex<T> può essere usato per proteggere l'accesso esclusivo a una risorsa condivisa.
I canali (channel) consentono di scambiarsi messaggi e valori tra thread.
Le Atomic variable garantiscono operazioni atomiche su tipi numerici.
I principali pericoli nella condivisione di stato sono:

Race condition quando diversi thread accedono a una risorsa senza sincronizzazione.
Deadlock se i thread si bloccano indefinitamente in attesa l'uno dell'altro.
Blocchi non necessari se si protegge troppo codice con primitive come Mutex.
Quindi in sintesi, Rust fornisce gli strumenti base per condividere lo stato tra thread, ma richiede comunque una progettazione attenta per evitare questi potenziali problemi di concorrenza.

</details>

## Domanda 5

Spiegare la differenza tra ownership e borrowing in Rust. Perché il borrow checker è importante?

<details>
<summary>Soluzione</summary>

La differenza principale tra ownership e borrowing in Rust è il trasferimento della proprietà:

- Con l'**ownership**, quando una variabile viene assegnata ad un'altra, la proprietà dei dati viene trasferita. La variabile originale non può più essere usata.

```rust
struct prova {
    a: u32,
}

impl prova {
    fn new(p_a: u32) -> Self{
        prova{a: p_a}
    }
}

fn main() { 
    let a = prova::new(1);
    let b = a;
    println!("{}", a.a); // Errore! a non ha più il possesso del dato
}
```

- Con il **borrowing**, la variabile originale presta temporaneamente l'accesso ad un'altra variabile, ma mantiene la proprietà. I dati non vengono spostati.

```rust
struct prova {
    a: u32,
}

impl prova {
    fn new(p_a: u32) -> Self{
        prova{a: p_a}
    }
}

fn main() { 
    let a = prova::new(1);
    let b = a;
    println!("{}", a.a);
}
```

Il borrow checker in Rust fa sì che non ci siano mai due proprietari di uno stesso dato, o un proprietario e un borrow simultanei. Questo previene condizioni di race e uso dopo deallocazione della memoria.

Quindi in sintesi:

- Ownership trasferisce la proprietà
- Borrowing presta l'accesso temporaneamente
- Il borrow checker previene l'aliasing mutabile

</details>

## Domanda 6

Quando si dovrebbe preferire l'allocazione sullo stack invece che sull'heap in Rust? E viceversa?

<details>
<summary>Soluzione</summary>

Ecco alcune linee guida su quando preferire lo stack o l'heap in Rust:

Preferire lo stack per:

- Dati di piccole dimensioni e scope locale (es. dentro una funzione)
- Quando si ha bisogno di ownership esclusivo e controllato
- Quando non è necessario condividere i dati tra thread
- Per performance critiche (accesso più veloce)

Preferire l'heap per:

- Dati di grandi dimensioni, specialmente se dinamici
- Dati condivisi tra thread (es. Arc, Rc)
- Quando si ha bisogno di estendere dinamicamente la durata di un dato
- Per dati polimorfi o eterogenei (es. trait object)
- Quando si vuole passare la proprietà tra funzioni (move semantics)

In sintesi:

- Stack: veloce, dati locali, ownership esclusivo
- Heap: condivisione, allocazione dinamica, estensione lifetime

Lo stack è il default in Rust, ma l'heap permette maggiore flessibilità e condivisione sicura quando serve.

</details>

## Domanda 7

Come funziona il pattern matching in Rust? Quali vantaggi offre rispetto ad altri costrutti?

<details>
<summary>Soluzione</summary>

Il pattern matching è un potente costrutto in Rust che permette di ispezionare il valore di un'espressione e scegliere un codice da eseguire in base al valore trovato. 

Funziona controllando che il valore corrisponda ad un "pattern" specificato e quindi esegue il codice associato. I pattern più comuni sono litorali, variabili leganti, tuple e enum.

Ad esempio:

```rust
let x = Some(5);

match x {
  Some(50) => println!("Il valore è 50"),
  Some(y) => println!("Il valore è {}", y), 
  None => println!("x è None"),
}
```

I vantaggi rispetto ad if/else:

- Codice più pulito ed espressivo
- Match esaurienti forzati dal compilatore
- Decomposizione strutturata di tipi complessi
- Assegnamento variabili leganti
- Controllo dei flussi basato sui dati

Quindi il pattern matching permette un controllo di flusso potente basato sui pattern dei dati in ingresso.

Utile per gestire in modo conciso ed espressivo tipi somma come enum e struct.

</details>

## Domanda 8

Cos'è e come si usa un iteratore in Rust? Quali metodi sono disponibili sugli iteratori?

<details>
<summary></summary>

In Rust, un iteratore (Iterator) è un oggetto che produce una sequenza di valori in modo lazily, restituendoli uno alla volta tramite il metodo next().

Gli iteratori vengono utilizzati principalmente in tre modi:

1. Chiamare next() dentro un ciclo per processare i valori prodotti:

```rust
let v = vec![1, 2, 3];
let mut iter = v.iter(); 

while let Some(x) = iter.next() {
  println!("Valore: {}", x); 
}
```

2. Uso dei metodi sugli iteratori come map(), filter(), fold(), etc... per trasformare e consumare i valori.

3. Uso nel pattern matching con for e while let.

Alcuni metodi comuni:

- map() - Mappa ogni elemento ad un nuovo valore 
- filter() - Filtra gli elementi
- fold() - Riduce gli elementi ad un singolo valore
- zip() - Combina due iteratori 
- collect() - Raccoglie gli elementi in una collezione

In sintesi, gli iteratori forniscono un modo elegante e funzionale di lavorare con sequenze di elementi in Rust.

</details>

## Domanda 9

Qual è la differenza tra String e &str in Rust? Quando è meglio usare uno o l'altro?

<details>
<summary>Soluzione</summary>

In Rust esistono due tipi principali per rappresentare le stringhe:

- **String** - Una stringa allocata dinamicamente sullo heap che è owner dei suoi dati.

- **&str** - Una string slice, un riferimento immutabile a una sequenza di caratteri.

Le differenze principali sono:

- String può essere modificata, &str no.

- String alloca nuova memoria e può cambiare dimensione. &str è statico.

- String ha overhead di allocazione e copia dei dati.

- &str è più efficiente quando si ha già una stringa allocata altrove.

Quando usare String:

- Quando si ha bisogno di una stringa modificabile.

- Per stringhe generate dinamicamente.


Quando usare &str:

- Quando si ha già una stringa statica o allocata altrove.

- Quando si passano riferimenti a stringhe senza assumerne ownership.

In sintesi String per stringhe owned e modificabili, &str per slicing efficiente di stringhe esistenti.

</details> 

<!-- 
<details>
<summary>Soluzione</summary>

</details> 
-->