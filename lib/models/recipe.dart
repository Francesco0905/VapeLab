class Recipe {
  final String title;
  final String description;
  final String author;

  Recipe({required this.title, required this.description, required this.author});

  // Converte una mappa (dati da Supabase) in un oggetto Recipe
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      title: map['title'] as String,
      description: map['description'] as String,
      author: map['author'] as String,
    );
  }

  // Converte un oggetto Recipe in una mappa (per inviarlo a Supabase)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'author': author,
    };
  }
}