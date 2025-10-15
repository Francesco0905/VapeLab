import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Autore: ${recipe.author}', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(recipe.description),
          const SizedBox(height: 24),
          Text('Commenti e dettagli tecnici (da implementare)', style: TextStyle(color: Colors.grey[600])),
        ]),
      ),
    );
  }
}