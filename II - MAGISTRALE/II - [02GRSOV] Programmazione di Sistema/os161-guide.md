# Os161

## Inizializzare il nuovo kernel

Per creare una nuova versione del kernel è necessario:

- entrare in `os161/src/kern/conf` ed eseguire una copia del kernel base `DUMBVM` mediante il comando `cp DUMBVM kname`
- eseguire, all'interno della medesima cartella, `./config kname`
- entrare in `os161/kern/compile/kname/` ed eseguire `bmake depend && bmake && bmake install`

Riassunto:

```bash
cd ~/os161/src/kern/conf
cp DUMBVM kname
./config kname

cd ~/os161/src/kern/compile/kname/
bmake depend && bmake && bmake install
```

## Buildare il kernel

E' possibile ricompilare il kernel dopo aver fatto le dovute modifiche mediante il comando dopo essere entrati in `os161/kern/compile/kname/`:

```bash
bmake depend && bmake && bmake install`
```

## definire una opzione

Le opzioni si definiscono in `conf.kern` sempre con nomi esclusivamente in minuscolo. Permettono di scrivere codice incrementale utilizzando funzionalità che in base alle necessità possono essere disabilitate.

Per riutilizzare le opzioni all'interno del codice C è necessario mettere OPT_ all'inizio e usare la voce in maiuscolo.

```bash
syscalls -> OPT_SYSCALLS
```
ATTENZIONE: è necessario richiamare il ./config kname ogni qual volta venga modificata una opzione del file conf.kern o di un kernel.

### Abilitare una option

Dopo aver definito una option in `conf.kern` è necessario abilitarla per la configurazione utilizzata. Per fare ciò è necessario aprire `kname` e aggiungere alla fine del file:

```bash
option option-name
```

### Optfile

L'opzione `optfile` consente di includere un file a una opzione se questa è abilitata. Va scritta per ogni file sotto la rispettiva `defoption`.

```bash
optfile option-name path/to/file
```

## debuggare

## Istruzioni

### `KASSERT`

Blocca il kernel se l'espressione è falsa, causando panic.

## Syscall

Che syscall più interne solitamente utilizzano un doppio `_`

## Sync

### spinlock

Attesa attiva. Utile per fare cose rapide. vengono utilizzati dai wait channel.

### lock

Non è presente attesa attiva, è leggermente più lento. Vengono utilizzate dalle conditional variables.

Il semaforo non protegge da un errore perché non c'è controllo su chi rilascia o meno, è necessario verificare che chi rilascia sia esattamente chi lo ha richiesto.
