class Review {
  final String id;
  final String userId;
  final String recipeId;
  final String deviceId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String userName;
  final String? targetType; // 'recipe', 'device', 'liquid'
  final String? targetId;

  Review({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.deviceId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userName = '',
    this.targetType,
    this.targetId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      recipeId: json['recipe_id'] ?? '',
      deviceId: json['device_id'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      userName: json['user_name'] ?? '',
      targetType: json['target_type'],
      targetId: json['target_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'recipe_id': recipeId,
      'device_id': deviceId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'user_name': userName,
      'target_type': targetType,
      'target_id': targetId,
    };
  }
}
