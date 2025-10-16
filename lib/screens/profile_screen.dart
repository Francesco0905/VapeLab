import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Text('Utente', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Accedi per gestire le tue ricette e commenti', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showLoginDialog(context), // Mostra il dialog
            icon: Icon(Icons.login),
            label: Text('Accedi'),
          ),
        ]),
      ),
    );
  }

  // Funzione per mostrare il dialog di login
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final _emailCtrl = TextEditingController();
        final _passwordCtrl = TextEditingController();
        final _formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Text('Login'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailCtrl,
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
                  controller: _passwordCtrl,
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
                if (_formKey.currentState?.validate() ?? false) {
                  // Esegui il login
                  _login(context, _emailCtrl.text, _passwordCtrl.text);
                }
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  // Funzione per gestire il login
  void _login(BuildContext context, String email, String password) {
    // TODO: Implementa il login con Supabase
    print('Email: $email, Password: $password');
    Navigator.of(context).pop(); // Chiudi il dialog dopo il login
  }
}