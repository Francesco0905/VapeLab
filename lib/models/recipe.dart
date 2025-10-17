class Recipe {
  final String id;
  final String name;
  final String description;
  final String author;
  final String type;
  final String ratio;
  final String userId;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.author,
    required this.type,
    required this.ratio,
    required this.userId,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String? ?? '', // Gestisce il caso in cui 'id' sia null
      name: map['name'] as String? ?? 'Senza nome',
      description: map['description'] as String? ?? 'Nessuna descrizione',
      author: map['author'] as String? ?? 'Anonimo',
      type: map['type'] as String? ?? 'MTL',
      ratio: map['ratio'] as String? ?? '50/50',
      userId: map['user_id'] as String? ?? '', // Gestisce il caso in cui 'user_id' sia null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'author': author,
      'type': type,
      'ratio': ratio,
      'user_id': userId,
    };
  }
}