import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../models/recipe.dart';
import '../../models/review.dart';
import 'package:intl/intl.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Recipe?> _recipeFuture;
  late Future<List<Review>> _reviewsFuture;
  bool _hasLiked = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final supabaseService = context.read<SupabaseService>();
    setState(() {
      _recipeFuture = supabaseService.getRecipe(widget.recipeId);
      _reviewsFuture = supabaseService.getRecipeReviews(widget.recipeId);
    });
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    final supabaseService = context.read<SupabaseService>();
    final hasLiked = await supabaseService.hasLikedRecipe(widget.recipeId);
    if (mounted) {
      setState(() => _hasLiked = hasLiked);
    }
  }

  Future<void> _toggleLike() async {
    final supabaseService = context.read<SupabaseService>();
    
    if (!supabaseService.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Devi effettuare l\'accesso per mettere mi piace')),
      );
      return;
    }

    try {
      if (_hasLiked) {
        await supabaseService.unlikeRecipe(widget.recipeId);
      } else {
        await supabaseService.likeRecipe(widget.recipeId);
      }
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli Ricetta'),
      ),
      body: FutureBuilder<Recipe?>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('Ricetta non trovata'),
            );
          }

          final recipe = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (recipe.imageUrl != null)
                  Image.network(
                    recipe.imageUrl!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.science, size: 100, color: Colors.grey),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Like Button
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              recipe.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _hasLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: _toggleLike,
                          ),
                          Text('${recipe.likesCount}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Author and Date
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            recipe.userName,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy').format(recipe.createdAt),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        recipe.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),

                      // Ingredients
                      const Text(
                        'Ingredienti',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...recipe.ingredients.map((ingredient) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 20, color: Colors.green),
                                const SizedBox(width: 8),
                                Text('${ingredient.name}: ${ingredient.amount}'),
                                if (ingredient.notes != null)
                                  Text(' (${ingredient.notes})', 
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 32),

                      // Instructions
                      const Text(
                        'Istruzioni',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        recipe.instructions,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),

                      // Reviews Section
                      const Text(
                        'Recensioni',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<List<Review>>(
                        future: _reviewsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          final reviews = snapshot.data ?? [];

                          if (reviews.isEmpty) {
                            return const Text(
                              'Nessuna recensione disponibile',
                              style: TextStyle(color: Colors.grey),
                            );
                          }

                          return Column(
                            children: reviews.map((review) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          review.userName,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              index < review.rating
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(review.comment),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(review.createdAt),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
