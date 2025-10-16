import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatelessWidget {
  final ValueNotifier<List<Recipe>> recipesNotifier;

  const RecipesScreen({super.key, required this.recipesNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Recipe>>(
      valueListenable: recipesNotifier,
      builder: (context, recipes, _) {
        // Controlla se la lista delle ricette è vuota
        if (recipes.isEmpty) {
          return Center(
            child: Text(
              'Nessuna ricetta ancora. Sii il primo a condividere!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          );
        }

        // Mostra la lista delle ricette
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final recipe = recipes[i];
            return ListTile(
              title: Text('${recipe.name} (${recipe.type})'), // Mostra il tipo accanto al nome
              subtitle: Text(
                '${recipe.author} · ${_short(recipe.description)} · ${recipe.ratio}',
              ), // Mostra il rapporto VG/PG
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecipeDetailScreen(recipe: recipe),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Funzione per accorciare il testo della descrizione
  String _short(String s, [int len = 80]) {
    return s.length <= len ? s : '${s.substring(0, len)}…';
  }
}