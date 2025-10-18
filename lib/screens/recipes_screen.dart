import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../supabase_config.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  final ValueNotifier<List<Recipe>> recipesNotifier;

  const RecipesScreen({super.key, required this.recipesNotifier});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await SupabaseConfig.client
        .from('recipes')
        .select()
        .eq('user_id', userId)
        .execute();

    final status = response.status;
    if (status != null && status >= 200 && status < 300 && response.data != null) {
      final data = response.data as List;
      final recipes = data.map((e) => Recipe.fromMap(e)).toList();
      if (!mounted) return;
      setState(() {
        widget.recipesNotifier.value = recipes;
      });
    } else {
      print('Errore nel caricamento delle ricette: status=$status body=${response.data}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore nel caricamento delle ricette')),
        );
      }
    }
  }

  Future<bool> _deleteRecipe(String recipeId) async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utente non autenticato')),
        );
      }
      return false;
    }

    try {
      final response = await SupabaseConfig.client
          .from('recipes')
          .delete()
          .eq('id', recipeId)
          .eq('user_id', userId)
          .execute();

      final status = response.status;
      final success = status != null && status >= 200 && status < 300;

      print('DELETE /recipes id=$recipeId user_id=$userId status=$status body=${response.data}');

      if (success) {
        if (mounted) await _fetchRecipes();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ricetta eliminata con successo')),
          );
        }
        return true;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Errore eliminazione: status=$status')),
          );
        }
        return false;
      }
    } catch (e) {
      print('Eccezione durante l\'eliminazione della ricetta: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore durante l\'eliminazione della ricetta')),
        );
      }
      return false;
    }
  }

  void _confirmDelete(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Conferma eliminazione'),
          content: const Text(
              'Sei sicuro di voler eliminare questa ricetta? Questa azione è irreversibile.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                );

                final deleted = await _deleteRecipe(recipeId);

                if (mounted) Navigator.of(context).pop();

                if (!deleted) {
                  // opzionale: altre azioni
                }
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Recipe>>(
      valueListenable: widget.recipesNotifier,
      builder: (context, recipes, _) {
        if (recipes.isEmpty) {
          return Center(
            child: Text(
              'Nessuna ricetta ancora. Sii il primo a condividere!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final recipe = recipes[i];
            final hashtags = recipe.hashtags ?? <String>[];
            return ListTile(
              isThreeLine: hashtags.isNotEmpty,
              leading: Icon(
                recipe.isPublic == true ? Icons.public : Icons.lock,
                color: recipe.isPublic == true ? Colors.green : Colors.grey,
              ),
              title: Text('${recipe.name} (${recipe.type})'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${recipe.author} · ${_short(recipe.description)} · ${recipe.ratio}'),
                  if (hashtags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: hashtags.map((h) {
                        return Chip(
                          label: Text('#$h', style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, recipe.id),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _short(String s, [int len = 80]) {
    return s.length <= len ? s : '${s.substring(0, len)}…';
  }
}