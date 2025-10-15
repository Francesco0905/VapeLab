# Deployment Guide - VapeLab

## Deployment su Vercel

### Step 1: Configurazione Supabase

1. Vai su [supabase.com](https://supabase.com) e crea un nuovo progetto
2. Nel SQL Editor, esegui il contenuto del file `supabase_schema.sql`
3. Annota:
   - Project URL (es: `https://xxxxx.supabase.co`)
   - Anon/Public Key (dalla sezione API settings)

### Step 2: Build del progetto Flutter

```bash
# Installa le dipendenze
flutter pub get

# Build per web con variabili d'ambiente
flutter build web \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --release
```

### Step 3: Deploy su Vercel

#### Opzione 1: Vercel CLI

```bash
# Installa Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod
```

#### Opzione 2: Vercel Dashboard

1. Vai su [vercel.com](https://vercel.com)
2. Importa il repository GitHub
3. Configura le variabili d'ambiente:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Aggiungi Build Command:
   ```
   flutter build web --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
   ```
5. Output Directory: `build/web`
6. Click su "Deploy"

### Step 4: Configurazione Post-Deploy

1. Verifica che l'app sia accessibile
2. Configura il dominio personalizzato (opzionale)
3. Abilita HTTPS (automatico su Vercel)
4. Configura redirect rules se necessario

## Deploy Automatico

Ogni push al branch `main` attiverà automaticamente un nuovo deploy su Vercel.

## Troubleshooting

### Problema: "Failed to load Supabase configuration"
- Verifica che le variabili d'ambiente siano configurate correttamente
- Controlla che l'URL Supabase sia corretto

### Problema: "Build failed"
- Assicurati che Flutter sia installato correttamente
- Verifica che tutte le dipendenze siano installate (`flutter pub get`)

### Problema: "Database connection error"
- Verifica che lo schema SQL sia stato eseguito correttamente
- Controlla le Row Level Security policies

## Monitoraggio

- Dashboard Vercel: monitoraggio deploy e analytics
- Supabase Dashboard: monitoraggio database e autenticazione
- Logs disponibili in entrambe le piattaforme
