# VapeLab - Architecture Documentation

## Overview

VapeLab è una web application costruita con Flutter che permette agli appassionati di vaping di condividere ricette, recensioni e consigli.

## Stack Tecnologico

### Frontend
- **Flutter Web** - Framework UI cross-platform
- **Dart** - Linguaggio di programmazione
- **Provider** - State management
- **GoRouter** - Routing e navigazione

### Backend
- **Supabase** - Backend-as-a-Service
  - PostgreSQL database
  - Authentication
  - Real-time subscriptions
  - Row Level Security (RLS)

### Deployment
- **Vercel** - Hosting e CDN
- **GitHub Actions** - CI/CD

## Architettura dell'Applicazione

### Struttura delle Directory

```
lib/
├── main.dart              # Entry point
├── models/                # Data models
│   ├── recipe.dart
│   └── review.dart
├── services/              # Business logic
│   └── supabase_service.dart
├── screens/               # UI screens
│   ├── auth/
│   ├── recipes/
│   └── profile/
└── widgets/               # Reusable widgets
```

### Pattern Architetturale

L'app segue un'architettura a layer:

1. **Presentation Layer** (Screens & Widgets)
   - Gestisce l'UI e l'interazione utente
   - Consuma i servizi tramite Provider

2. **Business Logic Layer** (Services)
   - `SupabaseService`: Gestisce comunicazione con Supabase
   - State management con Provider/ChangeNotifier

3. **Data Layer** (Models)
   - Modelli di dati immutabili
   - Serializzazione JSON

### Flusso Dati

```
User Interaction
    ↓
Widget (UI)
    ↓
Provider (State)
    ↓
Service (Business Logic)
    ↓
Supabase (Backend)
    ↓
Database
```

## Database Schema

### Tabelle Principali

1. **profiles**
   - Dati utente estesi
   - Collegata a auth.users

2. **recipes**
   - Ricette create dagli utenti
   - Contiene ingredienti come JSONB
   - RLS abilitata

3. **reviews**
   - Recensioni su ricette/dispositivi
   - Rating e commenti

4. **recipe_likes**
   - Sistema di like
   - Trigger per aggiornare count

### Row Level Security

Tutte le tabelle hanno RLS abilitata per garantire:
- Gli utenti vedono tutti i dati pubblici
- Gli utenti possono modificare solo i propri dati
- Gli utenti autenticati possono creare contenuti

## Routing

Gestito da GoRouter:

- `/` - Home page
- `/login` - Autenticazione
- `/register` - Registrazione
- `/recipes` - Lista ricette
- `/recipes/create` - Crea ricetta
- `/recipes/:id` - Dettaglio ricetta
- `/profile` - Profilo utente

## State Management

Utilizzo di Provider per:
- Stato autenticazione
- Cache dati ricette
- Notifiche UI updates

## Sicurezza

1. **Autenticazione**
   - JWT tokens via Supabase Auth
   - Session management automatico

2. **Autorizzazione**
   - Row Level Security policies
   - Client-side route guards

3. **Validazione**
   - Input validation sui form
   - Server-side validation su Supabase

## Performance

### Ottimizzazioni
- Lazy loading delle ricette
- Image caching
- Code splitting (automatico con Flutter Web)
- Pagination per liste lunghe

### Build Web
```bash
flutter build web --release
```

Ottimizzazioni applicate:
- Minification
- Tree shaking
- Asset optimization

## Testing

### Unit Tests
- Modelli (recipe_test.dart)
- Serializzazione/Deserializzazione

### Widget Tests
- TODO: Test componenti UI

### Integration Tests
- TODO: Test flussi completi

## CI/CD Pipeline

GitHub Actions workflow:
1. Checkout code
2. Setup Flutter
3. Install dependencies
4. Run tests
5. Build web
6. Deploy to Vercel

## Monitoring & Logging

- **Vercel Analytics** - Performance monitoring
- **Supabase Logs** - Database queries
- **Error Tracking** - TODO: Integrare Sentry

## Future Improvements

1. **Features**
   - [ ] Search functionality
   - [ ] Filters e sorting avanzati
   - [ ] Notifiche push
   - [ ] PWA offline support
   - [ ] Image upload
   - [ ] Social sharing

2. **Technical**
   - [ ] Add integration tests
   - [ ] Implement caching strategy
   - [ ] Add error tracking
   - [ ] Performance monitoring
   - [ ] SEO optimization

3. **DevOps**
   - [ ] Staging environment
   - [ ] Preview deployments
   - [ ] Database migrations system
   - [ ] Backup strategy

## Scaling Considerations

### Database
- Indexes su campi frequentemente cercati
- Partitioning per grandi dataset
- Connection pooling

### Frontend
- CDN per assets statici (Vercel)
- Service Worker per caching
- Code splitting per route

### Backend
- Supabase auto-scaling
- Edge functions per logica complessa
- Rate limiting su API

## Development Workflow

1. Feature branch da `main`
2. Sviluppo locale
3. Test locali
4. Push e PR
5. Review e merge
6. Auto-deploy su Vercel

## Troubleshooting

### Common Issues

**Build Errors**
- Verificare versione Flutter
- `flutter clean && flutter pub get`

**Supabase Connection**
- Verificare env variables
- Controllare RLS policies

**Routing Issues**
- Verificare configurazione GoRouter
- Check vercel.json rewrites

## Risorse

- [Flutter Docs](https://flutter.dev/docs)
- [Supabase Docs](https://supabase.com/docs)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Provider Package](https://pub.dev/packages/provider)
