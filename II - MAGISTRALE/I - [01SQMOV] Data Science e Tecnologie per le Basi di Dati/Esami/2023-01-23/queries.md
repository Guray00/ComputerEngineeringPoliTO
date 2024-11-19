# 2023-01-23

## Query 1

Visualizzare per ogni intermediario finanziario e quadrimestre li numero totale di acquisti e li corrispondente valore. Associare ad ogni record un rango:

- che identifica al posizione del record ni funzione del valore complessivo degli acquisti 1( per li valore complessivo più basso)
- che identifica la posizione del record in ordine decrescente del numero di acquisti, separatamente per stato dell'intermediario finanziario

```sql
select intermediarioFinanziario, 4-Mesi,
sum(NumeroAcquisti), sum(ValoreAcquisti),
rank() over  (order by sum(ValoreAcquisti) asc),
rank() over (partition by stato order by sum(NumeroAcquisti) desc)

from INTERMEDIARIO-FINANZIARIO IF, TEMPO T, ACQUISTO A
where
    IF.IdIntermediarioFinanziario = A.idIntermediarioFinanziario and
	T.IDTempo = A.IDTempo 

group by IntermediarioFinanziario, stato, 4-Mesi
```


## Query 2

Per i prodotti finanziari appartenenti alla categoria contratti derivati (CategoriaP='Contratti Derivati'), visualizzare separatamente per ogni intermediario finanziario e quadrimestre:

- li valore complessivo degli acquisti,
- li valore cumulativo degli acquisti dall'inizio dell'anno al trascorrere dei quadrimestri, separatamente per intermediario finanziario,
- li valore complessivo dei prodotti indipendente dall'intermediario finanziario

```sql
select IntermediarioFinanziario, 4-Mesi,
sum(ValoreAcquisti),
sum(sum(ValoreAcquisti)) over (partition by anno, IntermediarioFinanziario order by 4-mesi ROW UNBOUND PRECEDEING),
sum(sum(valoreAcquisti)) over (partition by 4-Mesi)

from
	PRODOTTI-FINANZIARI PF, TEMPO T, ACQUISTO A, INTERMEDIARIO-FINANZIARIO IF

where
	PF.categoriaP='Contratti Derivati') and
	IF.idIntermediarioFinanziario = A.idIntermediarioFinanziario and
	A.idTempo = T.idTempo and
	A.idProdottoFinanziario = PF.idProdottoFinanziario

group by intermediarioFinanziario, 4-mesi, anno
```

## Query 3

Visualizzare per ogni prodotto finanziario, professione del cliente e trimestre:

- li numero degli acquisti,
- li valore medio per acquisto,
- li valore medio mensile degli acquisti,
- la percentuale del valore degli acquisti rispetto al valore complessivo dei prodotti finanziari appartenenti alla stessa Categoria, separatamente per professione del cliente e trimestre

```sql
select prodottoFinanziario, Professione, CategoriaP, 3-Mesi,
	sum(numeroAcquisti),
	sum(ValoreAcquisti)/sum(numeroAcquisti),
	sum(valoreAcquisti)/count(distinct mese),
	sum(valoreAcquisti)*100 / sum(sum(ValoreAcquisti)) over
		(partition by categoriaP, professione, 3-mesi)

from 
	JUNK-CARATTERISTICHE-CLIENTE JC,
	PRODOTTO-FINANZIONARI PF, 
	TEMPO T

where 
	JC.IDJCC = A.IDJCC and
	IF.IDintermediarioFinanziario = A.idIntermediarioFinanziario and
	A.IdTempo = T.IdTempo and
	PF.idProdottoFinanziario = A.idProdottoFinanziario

group by prodottoFinanziario, professione, 3-mesi, categoriaP
```