import 'dart:convert';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String author;
  final String type;
  final String ratio;
  final String userId;
  final bool isPublic;
  final List<String> hashtags;
  final DateTime? createdAt;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.author,
    required this.type,
    required this.ratio,
    required this.userId,
    this.isPublic = false,
    List<String>? hashtags,
    this.createdAt,
  }) : hashtags = hashtags ?? <String>[];

  factory Recipe.fromMap(Map<String, dynamic> map) {
    // helper per gli hashtags: supporta text[] (List), json string o csv
    List<String> parseHashtags(dynamic v) {
      if (v == null) return <String>[];
      if (v is List) {
        return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      }
      if (v is String) {
        // prova json array
        try {
          final decoded = json.decode(v);
          if (decoded is List) {
            return decoded.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
          }
        } catch (_) {
          // non JSON: split per virgola/spazio
          return v.split(RegExp(r'[,\s]+')).map((s) => s.trim().replaceFirst(RegExp(r'^#'), '')).where((s) => s.isNotEmpty).toList();
        }
      }
      return <String>[];
    }

    bool parseIsPublic(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return Recipe(
      id: (map['id'] ?? map['ID'] ?? '') as String,
      name: (map['name'] ?? map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      author: (map['author'] ?? 'Anonimo') as String,
      type: (map['type'] ?? '') as String,
      ratio: (map['ratio'] ?? '') as String,
      userId: (map['user_id'] ?? map['userId'] ?? '') as String,
      isPublic: parseIsPublic(map['is_public'] ?? map['isPublic']),
      hashtags: parseHashtags(map['hashtags']),
      createdAt: parseDate(map['created_at'] ?? map['createdAt']),
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
      'is_public': isPublic,
      'hashtags': hashtags,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? description,
    String? author,
    String? type,
    String? ratio,
    String? userId,
    bool? isPublic,
    List<String>? hashtags,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      author: author ?? this.author,
      type: type ?? this.type,
      ratio: ratio ?? this.ratio,
      userId: userId ?? this.userId,
      isPublic: isPublic ?? this.isPublic,
      hashtags: hashtags ?? this.hashtags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, isPublic: $isPublic, hashtags: $hashtags)';
  }
}