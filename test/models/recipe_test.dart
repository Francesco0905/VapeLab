import 'package:flutter_test/flutter_test.dart';
import 'package:vapelab/models/recipe.dart';

void main() {
  group('Recipe Model Tests', () {
    test('Recipe creation from JSON', () {
      final json = {
        'id': '123',
        'user_id': 'user123',
        'title': 'Test Recipe',
        'description': 'A test recipe',
        'ingredients': [
          {'name': 'VG', 'amount': '70%', 'notes': null},
          {'name': 'PG', 'amount': '30%', 'notes': null},
        ],
        'instructions': 'Mix well',
        'image_url': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'likes_count': 5,
        'user_name': 'TestUser',
      };

      final recipe = Recipe.fromJson(json);

      expect(recipe.id, '123');
      expect(recipe.title, 'Test Recipe');
      expect(recipe.ingredients.length, 2);
      expect(recipe.ingredients[0].name, 'VG');
      expect(recipe.likesCount, 5);
    });

    test('Recipe toJson conversion', () {
      final recipe = Recipe(
        id: '123',
        userId: 'user123',
        title: 'Test Recipe',
        description: 'A test recipe',
        ingredients: [
          RecipeIngredient(name: 'VG', amount: '70%'),
          RecipeIngredient(name: 'PG', amount: '30%'),
        ],
        instructions: 'Mix well',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        likesCount: 5,
        userName: 'TestUser',
      );

      final json = recipe.toJson();

      expect(json['id'], '123');
      expect(json['title'], 'Test Recipe');
      expect(json['ingredients'].length, 2);
      expect(json['likes_count'], 5);
    });
  });

  group('RecipeIngredient Tests', () {
    test('Ingredient creation from JSON', () {
      final json = {
        'name': 'Nicotine',
        'amount': '3mg',
        'notes': 'Optional',
      };

      final ingredient = RecipeIngredient.fromJson(json);

      expect(ingredient.name, 'Nicotine');
      expect(ingredient.amount, '3mg');
      expect(ingredient.notes, 'Optional');
    });

    test('Ingredient toJson conversion', () {
      final ingredient = RecipeIngredient(
        name: 'Flavor',
        amount: '10%',
        notes: 'Strawberry',
      );

      final json = ingredient.toJson();

      expect(json['name'], 'Flavor');
      expect(json['amount'], '10%');
      expect(json['notes'], 'Strawberry');
    });
  });
}
