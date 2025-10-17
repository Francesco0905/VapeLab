import 'package:flutter/material.dart';
import '../supabase_config.dart';
import 'dart:html' as html;


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isAuthenticated = false; // Stato per verificare se l'utente è autenticato
  String? _userEmail; // Email dell'utente autenticato

  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); // Controlla lo stato di autenticazione all'avvio
  }

  Future<void> _checkAuthStatus() async {
    final session = SupabaseConfig.client.auth.currentSession;
    if (session != null) {
      setState(() {
        _isAuthenticated = true;
        _userEmail = session.user.email;
      });
    }
  }

  Future<void> _logout() async {
    try {
      // Effettua il logout da Supabase
      await SupabaseConfig.client.auth.signOut();

      // Resetta lo stato locale
      setState(() {
        _isAuthenticated = false;
        _userEmail = null;
      });

      // Mostra un messaggio di conferma
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout effettuato con successo')),
      );
    
      Future.delayed(Duration(milliseconds: 100), () {
      html.window.location.reload();
    });

    } catch (e) {
      print('Errore durante il logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante il logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? _buildProfileScreen() // Mostra la schermata del profilo se autenticato
        : _buildLoginScreen(); // Mostra la schermata di login/registrazione se non autenticato
  }

  Widget _buildProfileScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Text(
              'Benvenuto!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $_userEmail',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text('Esci'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Text('Utente', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Accedi per gestire le tue ricette e commenti',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showLoginDialog(context), // Mostra il dialog di login
            icon: Icon(Icons.login),
            label: Text('Accedi'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showSignupDialog(context), // Mostra il dialog di registrazione
            icon: Icon(Icons.app_registration),
            label: Text('Registrati'),
          ),
        ]),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final emailCtrl = TextEditingController();
        final passwordCtrl = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Login'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un\'email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Inserisci un\'email valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci una password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Chiudi il dialog
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  _login(context, emailCtrl.text, passwordCtrl.text);
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void _showSignupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final emailCtrl = TextEditingController();
        final passwordCtrl = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Registrazione'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un\'email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Inserisci un\'email valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci una password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Chiudi il dialog
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  _signup(context, emailCtrl.text, passwordCtrl.text);
                }
              },
              child: Text('Registrati'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login(BuildContext context, String email, String password) async {
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        print('Login effettuato con successo: ${response.user!.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login effettuato con successo!')),
        );
        setState(() {
          _isAuthenticated = true;
          _userEmail = response.user!.email;
        });
        Navigator.of(context).pop(); // Chiudi il dialog
      } else {
        print('Errore durante il login: Nessuna sessione attiva');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante il login: Nessuna sessione attiva')),
        );
      }
    } catch (e) {
      print('Eccezione durante il login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante il login: $e')),
      );
    }
  }

  Future<void> _signup(BuildContext context, String email, String password) async {
    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('Registrazione completata con successo: ${response.user!.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrazione completata con successo!')),
        );
        setState(() {
          _isAuthenticated = true;
          _userEmail = response.user!.email;
        });
        Navigator.of(context).pop(); // Chiudi il dialog
      } else {
        print('Errore durante la registrazione: Nessun utente creato');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante la registrazione: Nessun utente creato')),
        );
      }
    } catch (e) {
      print('Eccezione durante la registrazione: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la registrazione: $e')),
      );
    }
  }
}