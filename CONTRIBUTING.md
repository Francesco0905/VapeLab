# Contributing to VapeLab

Grazie per il tuo interesse nel contribuire a VapeLab! 🎉

## Come Contribuire

### Segnalare Bug

Se trovi un bug, per favore apri una issue con:
- Descrizione dettagliata del problema
- Passi per riprodurre il bug
- Comportamento atteso vs comportamento attuale
- Screenshot se applicabile
- Informazioni sul browser/dispositivo

### Proporre Nuove Funzionalità

Per proporre una nuova funzionalità:
1. Apri una issue con tag "enhancement"
2. Descrivi la funzionalità in dettaglio
3. Spiega perché sarebbe utile
4. Fornisci eventuali mockup o esempi

### Pull Request

1. Fai un fork del repository
2. Crea un branch dalla `main`:
   ```bash
   git checkout -b feature/nome-feature
   ```
3. Fai le tue modifiche
4. Assicurati che il codice compili:
   ```bash
   flutter pub get
   flutter analyze
   flutter test
   ```
5. Commit con messaggi descrittivi:
   ```bash
   git commit -m "Add: descrizione della modifica"
   ```
6. Push al tuo fork:
   ```bash
   git push origin feature/nome-feature
   ```
7. Apri una Pull Request verso `main`

## Linee Guida per il Codice

### Style Guide

- Segui le convenzioni Dart/Flutter
- Usa `flutter format` prima di committare
- Commenta il codice quando necessario
- Mantieni le funzioni piccole e focalizzate

### Struttura Commit

Usa i seguenti prefissi per i commit:
- `Add:` per nuove funzionalità
- `Fix:` per bug fix
- `Update:` per modifiche a funzionalità esistenti
- `Docs:` per modifiche alla documentazione
- `Style:` per modifiche di formattazione
- `Refactor:` per refactoring del codice

### Testing

- Aggiungi test per le nuove funzionalità
- Assicurati che tutti i test passino
- Mantieni la copertura del codice alta

## Processo di Review

1. Un maintainer revisionerà la tua PR
2. Potrebbero essere richieste modifiche
3. Una volta approvata, la PR verrà mergiata
4. Il deploy avverrà automaticamente

## Codice di Condotta

- Sii rispettoso e professionale
- Accetta feedback costruttivi
- Aiuta altri contributori
- Mantieni un ambiente inclusivo

## Domande?

Se hai domande, apri una issue con tag "question" o contatta i maintainer.

Grazie per il tuo contributo! 🚀
