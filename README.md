# VapeLab

Sito web per gli appassionati di vaping o semplicemente per possessori di sigaretta elettronica, lo scopo è fornire uno spazio per scambiarsi principalmente "ricette" ma anche opinioni su liquidi e dispositivi e consigli.

## 🚀 Tecnologie Utilizzate

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL, Authentication, Storage)
- **Deployment**: Vercel

## 📋 Funzionalità

- ✅ Sistema di autenticazione (registrazione/login)
- ✅ Creazione e condivisione di ricette per liquidi
- ✅ Sistema di like per le ricette
- ✅ Recensioni e commenti
- ✅ Profilo utente
- ✅ Design responsive per web

## 🛠️ Setup del Progetto

### Prerequisiti

- Flutter SDK (>=3.0.0)
- Account Supabase
- Account Vercel (per deployment)

### Installazione Locale

1. Clona il repository:
```bash
git clone https://github.com/Francesco0905/VapeLab.git
cd VapeLab
```

2. Installa le dipendenze:
```bash
flutter pub get
```

3. Configura Supabase:
   - Crea un nuovo progetto su [supabase.com](https://supabase.com)
   - Esegui lo script SQL in `supabase_schema.sql` nel SQL Editor di Supabase
   - Copia l'URL e la chiave anonima del progetto

4. Configura le variabili d'ambiente:
```bash
export SUPABASE_URL=your_supabase_url
export SUPABASE_ANON_KEY=your_supabase_anon_key
```

5. Esegui l'applicazione:
```bash
flutter run -d chrome --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

## 🚢 Deployment su Vercel

1. Compila il progetto per il web:
```bash
flutter build web --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

2. Collega il repository a Vercel:
```bash
vercel
```

3. Configura le variabili d'ambiente su Vercel:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

4. Deploy automatico ad ogni push su main branch

## 📁 Struttura del Progetto

```
lib/
├── models/          # Modelli dati (Recipe, Review, etc.)
├── services/        # Servizi (Supabase integration)
├── screens/         # Schermate dell'app
│   ├── auth/       # Login e registrazione
│   ├── recipes/    # Liste e dettagli ricette
│   └── profile/    # Profilo utente
└── main.dart       # Entry point
```

## 🗄️ Database Schema

Il database Supabase include le seguenti tabelle:

- `profiles` - Profili utente
- `recipes` - Ricette create dagli utenti
- `reviews` - Recensioni e commenti
- `recipe_likes` - Sistema di like

## 🤝 Contribuire

Le contribuzioni sono benvenute! Per favore:

1. Fai un fork del progetto
2. Crea un branch per la tua feature (`git checkout -b feature/AmazingFeature`)
3. Commit le tue modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📄 Licenza

Questo progetto è distribuito sotto licenza MIT.

## 👥 Autori

- Francesco0905

## 🙏 Ringraziamenti

- Flutter team per il fantastico framework
- Supabase per il backend-as-a-service
- Vercel per l'hosting
