# FAQ

Elenco di errori che è comune riscontrare nel corso dello sviluppo del progetto.

## `req.body` è undefined

Può succedere che nella chiamata a una `POST` si abbia come body sempre `undefined`, ciò può essere dovuto alla seguente riga mancante nel file delle API:

```js
app.use(express.json());
```

## React non carica correttamente bootstrap

Può succedere che Boostrap non venga correttamente mostrato nella pagina, ciò può essere dovuto al fatto che non è stato importato correttamente nel file `App.jsx`:

```js
import 'bootstrap/dist/css/bootstrap.min.css';
```
