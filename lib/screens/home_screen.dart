import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = context.watch<SupabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('VapeLab'),
        actions: [
          if (supabaseService.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => context.go('/profile'),
            )
          else
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.cloud, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Benvenuto su VapeLab',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'La community italiana per gli appassionati di vaping',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go('/recipes'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                    child: const Text(
                      'Esplora le Ricette',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            
            // Features Section
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Text(
                    'Cosa puoi fare su VapeLab',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _FeatureCard(
                        icon: Icons.book,
                        title: 'Ricette',
                        description: 'Condividi e scopri ricette per liquidi',
                      ),
                      _FeatureCard(
                        icon: Icons.rate_review,
                        title: 'Recensioni',
                        description: 'Lascia opinioni su liquidi e dispositivi',
                      ),
                      _FeatureCard(
                        icon: Icons.forum,
                        title: 'Community',
                        description: 'Scambia consigli con altri appassionati',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
