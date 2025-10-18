import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final hashtags = recipe.hashtags ?? <String>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              recipe.isPublic == true ? Icons.public : Icons.lock,
              color: recipe.isPublic == true ? Colors.white70 : Colors.white54,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Autore: ${recipe.author}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('Tipo: ${recipe.type}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('Rapporto VG/PG: ${recipe.ratio}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(recipe.description),
          const SizedBox(height: 18),
          if (hashtags.isNotEmpty) ...[
            const Text('Hashtags', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: hashtags.map((h) => Chip(label: Text('#$h'))).toList(),
            ),
            const SizedBox(height: 18),
          ],
          Text(
            recipe.isPublic == true ? 'Visibilità: Pubblica (visibile in Esplora)' : 'Visibilità: Privata',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 18),
          Text('Commenti e dettagli tecnici (da implementare)', style: TextStyle(color: Colors.grey[600])),
        ]),
      ),
    );
  }
}