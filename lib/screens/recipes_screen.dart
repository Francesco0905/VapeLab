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
    _fetchRecipes(); // Carica le ricette all'avvio
  }

  Future<void> _fetchRecipes() async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;

    if (userId == null) {
      print('Utente non autenticato');
      return;
    }

    final response = await SupabaseConfig.client
        .from('recipes')
        .select()
        .eq('user_id', userId) // Filtra per user_id
        .execute();

    if (response.status == 200 && response.data != null) {
      // Controlla se la risposta è valida
      final data = response.data as List;
      final recipes = data.map((e) => Recipe.fromMap(e)).toList();
      setState(() {
        widget.recipesNotifier.value = recipes;
      });
    } else {
      // Gestione degli errori
      print('Errore nel caricamento delle ricette: ${response.status}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel caricamento delle ricette')),
      );
    }
  }

  Future<void> _deleteRecipe(String recipeId) async {
    try {
      final response = await SupabaseConfig.client
          .from('recipes')
          .delete()
          .eq('id', recipeId)
          .execute();

      if (response.status == 204) {
        // Rimuovi la ricetta dalla lista locale
        setState(() {
          widget.recipesNotifier.value =
              widget.recipesNotifier.value.where((r) => r.id != recipeId).toList();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ricetta eliminata con successo')),
        );
      } else {
        print('Errore durante l\'eliminazione della ricetta: ${response.status}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante l\'eliminazione della ricetta')),
        );
      }
    } catch (e) {
      print('Eccezione durante l\'eliminazione della ricetta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'eliminazione della ricetta')),
      );
    }
  }

  void _confirmDelete(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Conferma eliminazione'),
          content: Text('Sei sicuro di voler eliminare questa ricetta? Questa azione è irreversibile.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Chiudi il dialog
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
                _deleteRecipe(recipeId); // Elimina la ricetta
              },
              child: Text('Elimina'),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, recipe.id), // Conferma eliminazione
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
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

  // Funzione per accorciare il testo della descrizione
  String _short(String s, [int len = 80]) {
    return s.length <= len ? s : '${s.substring(0, len)}…';
  }
}