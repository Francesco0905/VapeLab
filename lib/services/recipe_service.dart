import '../models/recipe.dart';
import '../supabase_config.dart';

class RecipeService {
  static Future<List<Recipe>> fetchRecipes() async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;

    if (userId == null) {
      print('Utente non autenticato');
      return [];
    }

    final response = await SupabaseConfig.client
        .from('recipes')
        .select()
        .eq('user_id', userId) // Filtra per user_id
        .execute();

    if (response.status == 200 && response.data != null) {
      final data = response.data as List;
      return data.map((e) => Recipe.fromMap(e)).toList();
    } else {
      print('Errore nel caricamento delle ricette: ${response.status}');
      return [];
    }
  }
}