# Linguaggi e Tecnologie per il Web - Progetto

## Web Page

### Form

**Campo** | **Regex** | **Descrizione**
:-:|:-:|---
`hotel`		| none								| Hotel
`name`		| `/^[a-z ]{30}$/g`					| Nome
`surname`	| `/^[a-z ]{30}$/g`					| Cognome
`email`		| `/[a-z1-9]{64}@[a-z1-9\.]{254}/`	| Indirizzo e-mail
`arrival`	| `/^(\d{4})-(\d{2})-(\d{2})/$`		| Data di arrivo
`departure`	| `/^(\d{4})-(\d{2})-(\d{2})/$`		| Data di partenza

---

## Database

### Hotel

**Campo** | **Tipo** | **Descrizione**
:-:|:-:|---
name	| String	| Nome
stars	| Integer	| Numero di stelle
geo\_x	| Float		| Coordinata geografica (ascissa)
geo\_y	| Float		| Coordinata geografica (ordinata)
email	| string	| Email della struttura

Primary key: hotel

---

### Camere

**Campo** | **Tipo** | **Descrizione**
:-:|:-:|---
hotel	| String	| Hotel di riferimento
type	| String	| Tipo di camera (da 2, suite presidenziale...)
price	| Float		| Prezzo dell'intera camera (anche approssimativo) per notte
quantity| Integer	| Numero di camere
available| Integer	| Numero di camere disponibili

Primary key: (hotel, type)

---

### Prenotazioni

**Campo** | **Tipo** | **Descrizione**
:-:|:-:|---
id		| Integer	| ID della prenotazione (assegnato in modo progressivo)
hotel	| String	| Hotel di riferimento
type	| String	| Tipo di camera
room	| Numeric	| Camera
arrival	| Date		| Data di arrivo (inizio soggiorno)
departure| Date		| Data di partenza (fine soggiorno)
payed	| Float		| Prezzo pagato per l'intero soggiorno
name	| String	| Nome del cliente
surname	| String	| Cognome del cliente
email	| String	| Indirizzo e-mail del cliente

Primary key: id
