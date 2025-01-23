# Domande possibili

Questo documento raccoglie una serie di domande che potrebbero essere poste durante l'esame di Sicurezza dei sistemi informativi.

## Parte 1

### CVE e CWE

#### Cosa sono CVE e CWE?

Common Vulnerabilities and ExposuresResult (CVE)

Common Weakness Enumeration (CWE)


### Risk Management Framework (RMF)

#### Cosa è il Risk Management Framework (RMF)?

#### Quali sono i passi del RMF?

- Preparazione (frame)
- Valutazione dei rischi( assess)
- Identificazione ed implementazione delle mitigazioni (respond)
- Aggiornamento costante e analisi (risk monitoring)

### Cosa e' OWASP?

Open Web Application Security Project

## Crittografia

### definizione di numero pseudo-casuale

Numeri che sembrano casuali ma sono generati da un algoritmo, ovvero mediante un processo deterministico ma statisticamente indistinguibile da un processo casuale. Richiedono sorgenti di entropia iniziale. In caso di errori di progettazione o implementazione, possono essere prevedibili.

### Definizione di crittografia simmetrica

La crittografia simmetrica è un metodo di crittografia che utilizza la stessa chiave per cifrare e decifrare il messaggio.

Ha un basso carico di elaborazione, ma si pone il problema sul come condividere in modo sicuro la chiave.

### Cosa caratterizzano un algoritmo di crittografia simmetrica?

- tipo
- lunghezza della chiave
- tipologia
- modalita' di utilizzo
- computazione
- altri servizi di sicurezza

### Principio di Kerckhoffs

Un crittosistema deve essere sicuro anche se tutto il mondo conosce l'algoritmo di cifratura, tranne la chiave.

- Chiavi tente segrete e gestite da sistemi fidati, di lunghezza adeguata


### Salsa20

### ChaCha20

- Miglioramento di Salsa20
- Maggiore diffusione dei bit
- piu' veloce su alcune architetture
- operazine base ARX
- Sostituiscono RC4 come algoritmo a blocchi di riferimento

### Cosa e' un messaggio di digest?



### Cosa e' un HMAC?

### Cosa e' il CBC-MAC?

Il CBC-MAC è un metodo di autenticazione dei messaggi che utilizza un cifrario a blocchi in modalità CBC per generare un MAC. Con CBC si intende che il messaggio viene diviso in blocchi e il MAC viene calcolato su ogni blocco.

### Crittografia asimmetrica

#### Numero chiavi per crittografia simmetrica

Dati N utenti, il numero di chiavi necessarie da generare è pari a N(N-1)/2.

#### RSA

##### Funzionamento

- Vengono scelti P e Q due numeri primi molto grandi
- viene calcolato N = P*Q (pubblico)
- viene calcolato phi = (P-1)(Q-1)
- viene scelto un esponente `e` coprimo con phi e tale da essere 1 < `e` < phi
- viene calcolato l'esponente privato `d` tale che `d` * `e` mod phi = 1

Chiave pubblica = (N, e)
Chiave privata = (N, d)

##### lunghezza chiave

La chiave deve essere lunga almeno 2048 bit per garantire una sicurezza accettabile.

##### Debolezze

- Small encryption exponent
- stessa chiave per firma e cifratura
- oracoli di decifratura

#### Diffie-Hellman

##### Funzionamento

- Alice e Bob scelgono due numeri primi p e g
- alice calcola X = g^x mod p
- Bob calcola Y = g^y mod p
- Alice calcola K = Y^x mod p
- Bob calcola K = X^y mod p
- K è la chiave condivisa

##### Debolozza

L'algoritmo e' soggetto ad attacchi man in the middle, in quanto la comunicazione, se non in atto con qualcuno di affidabile, potrebbe essere intercettata e manipolata.

Per questo motivo e' necessario introdurre il concetto di autenticazione, in modo da assicurare che il messaggio provenga da chi dice di essere.

#### Crittografia su curve ellittiche

Vengo utilizzate delle curve matematiche per generare chiavi crittografiche. Il problema e' piu' complesso rispetto a quello del logaritmo disreto in aritmetica modulare, per tale motivo e' possibile utilizzare chiavi piu' corte (circa 1/10).

Alcune applicazioni sono:

- firma digitale = ECDSA
- key agreement = ECDH
- authenticated key agreement = ECMQV
- key distribution = ECIES

#### Diffie-Hellman su curve ellittiche

### Key Derivation Function (KDF)

### Password-Based Key Derivation Function (PBKDF)

### Post quantum cryptography

#### Algoritmo di Shor

L'algoritmo di Shor è un algoritmo quantistico che permette di fattorizzare un numero intero in tempo polinomiale. Questo algoritmo mette a rischio la sicurezza degli algoritmi crittografici asimmetrici attuali, come RSA e DH.

#### Rapporto con algoritmi di crittografia simmetrica

Pare che l'avvento dei computer quantistici con comporti particolari variazioni nel contesto della crittografia simmetrica.

#### Qualified Certificate

Il Qualified Certificate (QC) e' un certificato a chiave pubblica rilasciato per certificare l'identita' di una persona, la quale:

- indica esplicitamente che e' stato emesso come QCindica nome o pseudonimo dell'indentita' certificata
- include attributi che indicano lo scopo di emissione del certificato e di uso della chiave certificato (es per firme digitali)
- limitazioni su uso, visibilita' e altri attributi

#### AES

- Identifazione univoca del firmatario
- mezzi crittografici sicuri anche per la memorizzazione delle chiavi
- garantisce integrita' e non forgiabilita' dei dati

#### QES

- firma digitale basata su un QC e creata mediante un dispositivo per la generazione di firme sicuro
- soddisfa requisiti legli
- e' usabile come prova in tribunale

### CRA

#### Symmetric CRA

- funzionamento
- debolezze


#### Asymmetric CRA

- funzionamento
- debolezze
  - se progettata male rischia di firmare involontariamente da parte del claimant
- perche' e' piu' sicuro del symmetric CRA
  - non richiede memorizzazione di segreti sul verifier

## Sicurezza di messaggio: posta elettronica

Da ricordare che la sicurezza e' implementata all'interno di ogni applicazione, la parte in comune si limita ai canali di comunicazione (socket). Per questo motivo sono possibili errori di implementazione e non garantisce l'interoperabilitá.


## GDPR

### Cosa e' il GDPR?

### DPO


### SHTTP

#### Il problema di SHTTP

SHTTP (Secure HTTP) è stato progettato per proteggere singoli messaggi HTTP (richieste e risposte) invece di creare un canale sicuro continuo. Ciò lo rendeva più complesso da implementare e meno efficiente in termini di prestazioni.

Con la crescente adozione di HTTPS, si è visto che la sicurezza di canale fornita da SSL/TLS era sufficiente per coprire i principali requisiti di sicurezza delle comunicazioni web, come:

- Protezione contro l'intercettazione (eavesdropping).
- Prevenzione degli attacchi di tipo man-in-the-middle (MITM).
- Crittografia dell'intero flusso di dati, semplificando l'implementazione rispetto alla protezione di messaggi individuali.


#### Proprieta' di sicurezza per messaggi email

- Non ripudio: il mittente non puo' negare di aver inviato il messaggio.
- Autenticazione: identifica il mittente.
- Riservatezza (opzionale): messaggi non leggibili sia in transito sia nella casella postale. 
- Integrita': il messaggio non puo' essere modificato.
- Funzionalita': nessuna modifica agli MTA (Mail Transfer Agent) e minime ai MUA (Mail User Agent).

#### Tipi di messaggi sicuri

- Clear signed: firma digitale del messaggio in chiaro.
- Signed: msg e firma codificati, solo chi ha MUA sicuro puo' decodificarli e verificare la firma.
- Encrypted / enveloped: msg e chiave cifrate, codificato, solo chi ha MUA sicuro (con le chiavi) puo' decodificarli. 

#### PKCS#12

Personal Information Exchange Syntax Standard e' una struttura dati per il trasporto di materiale crittografico (sistemi PC, applicazioni o HSM). Consente di trasportate l'identita' digitale di un utente. Ha una implementazione critica ma e' ampiamente utilizzato.

## Sicurezza di rete

### I principi inderogabili dei firewall

1. Il firewall deve essere l'unico punto di contatto della rete interna con quella esterna.
2. Solo il traffico autorizzato puo' attraversare il firewall.
3. Il firewall deve essere un sistema altamente sicuro esso stesso.

### Politiche di autorizzazione

- Whitelisting
- Blacklisting

### Layer-7 filter

### Circui level gateway

- Viene realizzato un circuito virtuale tra il client e il server per il trasporto senza nessuna compresnione dei dati in transito.
- Livello 4/5 del modello OSI
- riasembla i segmenti TCP o datagrammi UDP in quanto protegge da alcuni attacchi a L3/L4
- Il piu' famoso e' socks

## Software protection

### Fuzzy testing

- Tecnica di test che consiste nell'inserire dati casuali o semi-casuali in un programma per verificare il suo comportamento
- testare iput non validi in quanto possono far emergere bug

### Symbolic anlysis

Interi pezzi di codice e funzioni vegnono intrpretati come formule matematiche. Gli input sono variabili indipendenti mentre le istruzioni condizionali aggiungono requisiti. Rappresentano semplificazioni necessarie per rendere le formule comprensibili.

### Concolic analysis

- Combinazione di analisi dinamica e simbolica
- alcuni valori sono concreti e altri restano simbolici

### Strategie MATE

- Attaccare il punto piu' debole
- Software presente su molte piattaforme, si parte da quella considerata piu' vulnerabile

### Anti-tampering

- Pratica per rendere il codice piu' complicato da modificare (detect, prevent react)

### Obfuscation

- Pratica per rendere il codice piu' complicato da comprendere 

### Syn flooding

Avviene quando si inviano pacchetti SYN a un server senza completare la procedura di handshake. Il server mantiene le connessioni aperte in attesa di una risposta che non arriverà mai, consumando risorse e mandandole in timeout.

#### Difese

- Abbassare il timeout (non troppo utile)
- Aumentare le dimensioni della tabella
- usare un router come syn interceptor
- usare un router come syn monitor
