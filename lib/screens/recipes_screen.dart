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
        if (recipes.isEmpty) {
          return Center(child: Text('Nessuna ricetta ancora. Sii il primo a condividere!'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, i) {
            final r = recipes[i];
            return ListTile(
              title: Text(r.title),
              subtitle: Text('${r.author} · ${_short(r.description)}'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: r),
              )),
            );
          },
        );
      },
    );
  }

  String _short(String s, [int len = 80]) => s.length <= len ? s : '${s.substring(0, len)}…';
}