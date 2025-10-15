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
          ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.login), label: Text('Accedi (da implementare)')),
        ]),
      ),
    );
  }
}