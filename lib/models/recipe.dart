class Recipe {
  final String name; // Nome della ricetta
  final String description; // Descrizione della ricetta
  final String author; // Autore della ricetta
  final String type; // Tipo: MTL o DTL
  final String ratio; // Rapporto VG/PG: 50/50, 70/30, ecc.

  Recipe({
    required this.name,
    required this.description,
    required this.author,
    required this.type,
    required this.ratio, // Campo obbligatorio
  });

  // Converte una mappa (dati da Supabase) in un oggetto Recipe
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      name: map['name'] as String,
      description: map['description'] as String,
      author: map['author'] as String,
      type: map['type'] as String,
      ratio: map['ratio'] as String, // Nuovo campo
    );
  }

  // Converte un oggetto Recipe in una mappa (per inviarlo a Supabase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'author': author,
      'type': type,
      'ratio': ratio, // Nuovo campo
    };
  }
}