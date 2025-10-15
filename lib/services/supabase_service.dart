import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/recipe.dart';
import '../models/review.dart';

class SupabaseService extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // Auth methods
  Future<AuthResponse> signUp(String email, String password, String username) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    notifyListeners();
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    return response;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    notifyListeners();
  }

  // Recipe methods
  Future<List<Recipe>> getRecipes() async {
    final response = await _client
        .from('recipes')
        .select('*, profiles!recipes_user_id_fkey(username)')
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) {
          json['user_name'] = json['profiles']?['username'] ?? '';
          return Recipe.fromJson(json);
        })
        .toList();
  }

  Future<Recipe?> getRecipe(String id) async {
    final response = await _client
        .from('recipes')
        .select('*, profiles!recipes_user_id_fkey(username)')
        .eq('id', id)
        .single();
    
    if (response == null) return null;
    response['user_name'] = response['profiles']?['username'] ?? '';
    return Recipe.fromJson(response);
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    final response = await _client
        .from('recipes')
        .insert(recipe.toJson())
        .select()
        .single();
    
    notifyListeners();
    return Recipe.fromJson(response);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _client
        .from('recipes')
        .update(recipe.toJson())
        .eq('id', recipe.id);
    
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    await _client
        .from('recipes')
        .delete()
        .eq('id', id);
    
    notifyListeners();
  }

  // Review methods
  Future<List<Review>> getRecipeReviews(String recipeId) async {
    final response = await _client
        .from('reviews')
        .select('*, profiles!reviews_user_id_fkey(username)')
        .eq('recipe_id', recipeId)
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) {
          json['user_name'] = json['profiles']?['username'] ?? '';
          return Review.fromJson(json);
        })
        .toList();
  }

  Future<Review> createReview(Review review) async {
    final response = await _client
        .from('reviews')
        .insert(review.toJson())
        .select()
        .single();
    
    notifyListeners();
    return Review.fromJson(response);
  }

  // Like methods
  Future<void> likeRecipe(String recipeId) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    await _client.from('recipe_likes').insert({
      'recipe_id': recipeId,
      'user_id': userId,
    });
    
    notifyListeners();
  }

  Future<void> unlikeRecipe(String recipeId) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    await _client
        .from('recipe_likes')
        .delete()
        .eq('recipe_id', recipeId)
        .eq('user_id', userId);
    
    notifyListeners();
  }

  Future<bool> hasLikedRecipe(String recipeId) async {
    final userId = currentUser?.id;
    if (userId == null) return false;

    final response = await _client
        .from('recipe_likes')
        .select()
        .eq('recipe_id', recipeId)
        .eq('user_id', userId);
    
    return (response as List).isNotEmpty;
  }
}
