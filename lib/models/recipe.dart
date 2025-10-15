class Recipe {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<RecipeIngredient> ingredients;
  final String instructions;
  final String? imageUrl;
  final DateTime createdAt;
  final int likesCount;
  final String userName;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    required this.createdAt,
    this.likesCount = 0,
    this.userName = '',
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((i) => RecipeIngredient.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: json['instructions'] ?? '',
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      likesCount: json['likes_count'] ?? 0,
      userName: json['user_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'likes_count': likesCount,
      'user_name': userName,
    };
  }
}

class RecipeIngredient {
  final String name;
  final String amount;
  final String? notes;

  RecipeIngredient({
    required this.name,
    required this.amount,
    this.notes,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] ?? '',
      amount: json['amount'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'notes': notes,
    };
  }
}
